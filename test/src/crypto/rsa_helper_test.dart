// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockingbird_messaging/src/crypto/rsa_helper.dart';
import 'package:mockingbird_messaging/src/transport/encrypt.dart';
import 'package:pointycastle/export.dart';

const privateKeyPEM = """""";

const publicKeyPEM = """""";

main() {
  group("test rsa", () {
    test("generate key pair", () {
      var keyPair = RSAHelper.generateKeyPair();
      var privateKeyPEM =
          RSAHelper.encodePrivateKeyToPem(keyPair.privateKey as RSAPrivateKey);
      print(privateKeyPEM);
      var publicKeyPEM =
          RSAHelper.encodePublicKeyToPem(keyPair.publicKey as RSAPublicKey);
      print(publicKeyPEM);
    });
    test("decode", () {
      var base64d =
          "sXsavT2M+81FsdXPKC14rRDCuSWZBBQUdAHGZ3UmW4Mm/ksVnAwSyzQ3cIHOiiFZ6kRXnRcxQAPT7IlAdcJWuQE1RQYtXz+cjvbj7xOoGUi/eF4D6jKuJHjbWu9IXU/vxT7s1q4yhfISBoyvohDsIHyu3QpcRZeWzfSYCEFtK+y7bmLN8UVCG9JMuaOJdKtrTOCV3dkBmc+rt4ddhgi/0BZJeLQ9C7StLOGYfUHxZQu1iQGmkfRiw9jpJIVJIBzB/gCDOvhth62jXSsVAAbwl6A9wXFDH+8ZSKo2JiK8Pl5EarLHGF0CM+ZMdHLqBW9DV0i89ULQXCBDbVT0lXBuqw==";
      var encrypted = base64Decode(base64d);
      var privateKey = RSAHelper.parsePrivateKeyFromPem(privateKeyPEM);
      if (privateKey == null) {
        return;
      }
      var text = RSAHelper.decrypt(encrypted, privateKey, () => SHA256Digest());
      print(String.fromCharCodes(text));
    });
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
