// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockingbird_messaging/src/crypto/rsa_helper.dart';
import 'package:mockingbird_messaging/src/transport/encrypt.dart';
import 'package:pointycastle/export.dart';

const privateKeyPEM = """-----BEGIN PRIVATE KEY-----
MIIFogIBAAKCAQEArFV4nJuQBRq3dB+pmpWjPcNwzXXUgw8C8+qdG3jvs2ubARAu72+pYDB4egd4/B/qHtfztrO5tVxfTjZhpPdEPrFc+oDVnWUgNZJIZCtTKskN+Phov+y/ojLoMzwIa9YH8wG07UGuf1NTlYcN+uGXrawko72qFsHxXN5A1N5S/7LyoKbmn3V5XwLI1gjedcHs4F6ETNKkVetYe+ZVMmGgbX5oE5fMTclphFVvT8+k/6FmlQDH2Fwpp34y0rY2A7QrL+4hQ3ZHf0Wq+kpmHouBwcplvbWImbBKDro6gHJlkJlzNUUFI51Khau2MJRJVeO/XugEfWX9l0r4Q/5IjKs5xwKCAQAd0xTylYGRQJRrRmeF10vPDpnhFPlYTSrHp9zUulNRi9fhkTluOrbnbLwM8mofyC4udFU7U1NabcgYsxSnBhwLdYqP1+ggOzYdz1kz7MOR7gW7BtKqFID9wy2oYEVc1Ee/6JW1Ud6vLm6SvDLRLmWfquEUbWiYU6w/1D8IGAnpMngmY+Ov3rps+pjyCSUh7px8m63l/wY8o6McoApsjasj/xyCWeewu8iv2VDSCBsd79T6g4dR2a4Q4eVoCroZxJNcCpwV3wwgrSOgeMyHDFophjbjTE8YQctfNIYMTMZCdijHI1uyzb0t12OavmWTFMS+BCVExLRTRb0jTI5PqWDBAoIBAB3TFPKVgZFAlGtGZ4XXS88OmeEU+VhNKsen3NS6U1GL1+GROW46tudsvAzyah/ILi50VTtTU1ptyBizFKcGHAt1io/X6CA7Nh3PWTPsw5HuBbsG0qoUgP3DLahgRVzUR7/olbVR3q8ubpK8MtEuZZ+q4RRtaJhTrD/UPwgYCekyeCZj46/eumz6mPIJJSHunHybreX/BjyjoxygCmyNqyP/HIJZ57C7yK/ZUNIIGx3v1PqDh1HZrhDh5WgKuhnEk1wKnBXfDCCtI6B4zIcMWimGNuNMTxhBy180hgxMxkJ2KMcjW7LNvS3XY5q+ZZMUxL4EJUTEtFNFvSNMjk+pYMECgYEA4SsiJAs+sf+JaHdA1ZlOO+8uwm2SYvMAKtV6MQ9ltccQ9E8G6t9AX2JvJ7S0lObG/R5lMZlHK+KNho7zqtcwUEs1dEDBz2M4VNVGImBRnREZETRCfye8MMGP/vIfq+jtvvtJtyipResPoF6crjQEQcKN/co9m7Z3j0dIFdEi6fECgYEAw+5RS+f88f5Zx16wZiUubxj/fTfvIUxOLiQGxheyTAdjA1TUjCTrsBUf0hIrVUx5YZnOmd8tjObXs/CyG9e5JGpuuv5kEkaMFpfwPoKS4swKS7M5Sp4JgSaGnCQhdnSyLS15aY7w8t9kqdZvrSfegGRPeqYcwZRmKEZ7Bp+7ZzcCgYEA1+qApoeR6yXbIa2ZIjoL5zUIZbCkevYB5xEmRv04zwLAo0VUoMzL8at2Y2DI+TADCJ2o89LDiLWKeMmDpwMKdTRpYbznHHNMhSyuQDCUkkTfALxYN45my2oRJqwO6s5FjKlymowHJeCt715KaFHA8z4Y4pCYW0SxiVcVLLaLAEECgYB3CnKmVbrfJJRTh3pRdUGzClMgNz24022kpwrejEMt4kcMHRxOUZhJEWyV66gcWSxeWl6mKmy4cQCZOSJdvEGmmGvSfQE8AVTX3VSABkFMPn/64ldquH4507hxYZpbKCehP0HHGqvWRFgawEh1wgVzqH6JnCdYjdtLmRbiPWZVHQKBgGgLpjErj92cTgnoqI7kNCZL9DvgbsfLBzbV/zkrrIlBb0sUPhw2PJKPEklSYrJRPRloiq7Aggoym5w9cPP8jEZReMHjIg4inJior6S0G03c12mO7TEOqTPPP+PCNHesDvnVasPJZCmRxfc8mriuqTWb3eS2Jn/euCv3KgwtAPqO
-----END PRIVATE KEY----- """;

const publicKeyPEM = """-----BEGIN PUBLIC KEY-----
MIIBCgKCAQEArFV4nJuQBRq3dB+pmpWjPcNwzXXUgw8C8+qdG3jvs2ubARAu72+pYDB4egd4/B/qHtfztrO5tVxfTjZhpPdEPrFc+oDVnWUgNZJIZCtTKskN+Phov+y/ojLoMzwIa9YH8wG07UGuf1NTlYcN+uGXrawko72qFsHxXN5A1N5S/7LyoKbmn3V5XwLI1gjedcHs4F6ETNKkVetYe+ZVMmGgbX5oE5fMTclphFVvT8+k/6FmlQDH2Fwpp34y0rY2A7QrL+4hQ3ZHf0Wq+kpmHouBwcplvbWImbBKDro6gHJlkJlzNUUFI51Khau2MJRJVeO/XugEfWX9l0r4Q/5IjKs5xwIDAQAB
-----END PUBLIC KEY-----""";

main() {
  group("test rsa", () {
    // test("generate key pair", () {
    //   var keyPair = RSAHelper.generateKeyPair();
    //   var privateKeyPEM =
    //       RSAHelper.encodePrivateKeyToPem(keyPair.privateKey as RSAPrivateKey);
    //   print(privateKeyPEM);
    //   var publicKeyPEM =
    //       RSAHelper.encodePublicKeyToPem(keyPair.publicKey as RSAPublicKey);
    //   print(publicKeyPEM);
    // });
    var names = ["SHA-1", "SHA-224", "SHA-256", "SHA-384", "SHA-512"];
    for (var name in names) {
      test("encrypt $name", () async {
        var privateKey = RSAHelper.parsePrivateKeyFromPem(privateKeyPEM);
        if (privateKey == null) {
          return;
        }
        var publicKey = RSAHelper.parsePublicKeyFromPem(publicKeyPEM);
        if (publicKey == null) {
          return;
        }
        var enc = RSAEncrypter(
            publicKey: publicKey,
            privateKey: privateKey,
            digestFactory: RSAEncrypter.getDigestFactory(name));
        var encrypted =
            await enc.encode(Uint8List.fromList("hello world".codeUnits));
        var r = await enc.decode(encrypted);
        var ret = String.fromCharCodes(r);
        expect(ret, "hello world");
      });
    }
  });
}
