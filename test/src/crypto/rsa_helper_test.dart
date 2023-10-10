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

const privateKeyPEM = """-----BEGIN PRIVATE KEY-----
MIIEqAIBAAKCAQEAws7jjVDnqzd7QDFYQRsO/keEKAJIq4oAilqU686xF2PuOAVDS3cHx4ZjEgcbbcgXLrprlKuyl2PlaVFiAjAqpRAgtEnxoFFFtSznRnHvmnbT8qQhgus2Z6q2u/GQ4HoSu8O4zTIyNcqQRFEAOhbDg4G8pA+r0wKqA7DmHMSHJG1hl2w9MEwwZw53lxUbQb/KICKXPK4zwm68BZCZFH1bYvE9wZFSzwxNMhYbvvIs4Y35BBLhKnqWjJkek+6X5Yz4iQzJlfJNyyJTz7Cc5bgokjkx9MoIUIkyopD7YapEvfhJ8FwLitdl86yo9fovdMSqbwP/zyMllhO8IR0efhqWLwIIf/////////8CggEADiASP9zt72xGc5EgZRghLi7hVkVUH5wSDfYjdjW2gYutakJ3brFizwTfih8ZzgwEIk9CHbWVbYTAzbIo+R+k9/MDbA8whf9enpRy8JiyVvDmzWE5TNThTQMD3PzXFG/Fi/fVHovVODFH5Kw65/tekdqGYx7/xn0a9smM5ekaI3nqfPNQXE/xy5dhg9LlokuJITPoC1yk1DkB2t0x4l31lOJxuvua5YyJMppcwen7X2k7EjGigTuPBeoLJiAKxobbA4tVVGSdbMsx6h2WiWBuQcFf7heWQoHDol9/ZuHLzATFOjJkTXlDW3RlnhNDKwasA2vn5c4I2IvYNt4PoOdMgQKBgQDqjtnsuHZuh4puB2URNxpEwH2CbPY0ji0mov5FD+0YBz3AGrPDzbuvBG9kWfNIKCeS1SREkreTYX6px+B4vk50jAu85sMN9xO6BewzujSEhWjYKBiazrmnXVoCkSqavT1FG5SRvUpvjl6ZxWZBrx9GVeZ8GLbB+uMcdIbjBeupIwKBgQDUnc7Lv1xS6/NimcscuY9bUEoT/SZRCv+/aYS2TdaD2fnQibPePhz33ijn3U5W26FPKDbDOenJVpMShn79Lun2EVlaRlo/wKEzyqfuZcBtoRbwq4iueMJIrVehadycVE81J/ppbt3w+Ef3yKpFyJBTLWAjFOsrOYldKF63pX5dhQKBgEQk/GsprD6wYidVPqehup/+zHf38A+Uvsla0UR/PAKfF/GX0GIygzR1tWcSOvvbrqOaCM9jULIgwQvSZgSuRVzW0xIueLy166U/0z+z+U4G9E7YV02igY1+MYhNZHNQR1yshp1QwS9nzVQfZXXvysZEbpHfHDl/CjxaHlYWgkDBAoGAfT8Q6LkrW7WexACww5UTu8jKOogvoCIIketIwFOOAFHRdWUIzextCB6Yni2hzkzG82hPCiX9cBtNu+X6vI58R/XkWueClneU/nts/WR3PJ1edBu4An8kg8eJDY7c5EJN/pQ0URN8Lk0zp+VPWJhTXIwoS8Iw3l+gaX40fZ5BmDkCgYEAnhLH+EBWNrL+4ODzjDhF9aePPi1iHe2pq6Phebuh8/vVgfKPrXQd1pMtJfgOzVjMWrkgNov8LyyFSIdWhlq7HBNWiGRd38HDe8utaqi1CuS9iTpazlb6rnh9Ka+WGN/zsPO8MS18fHPSvpyRKpopXLVYLggoDrqjw8bAM7ru3Xk=
-----END PRIVATE KEY-----""";

const publicKeyPEM = """-----BEGIN PUBLIC KEY-----
MIIBCgKCAQEAws7jjVDnqzd7QDFYQRsO/keEKAJIq4oAilqU686xF2PuOAVDS3cHx4ZjEgcbbcgXLrprlKuyl2PlaVFiAjAqpRAgtEnxoFFFtSznRnHvmnbT8qQhgus2Z6q2u/GQ4HoSu8O4zTIyNcqQRFEAOhbDg4G8pA+r0wKqA7DmHMSHJG1hl2w9MEwwZw53lxUbQb/KICKXPK4zwm68BZCZFH1bYvE9wZFSzwxNMhYbvvIs4Y35BBLhKnqWjJkek+6X5Yz4iQzJlfJNyyJTz7Cc5bgokjkx9MoIUIkyopD7YapEvfhJ8FwLitdl86yo9fovdMSqbwP/zyMllhO8IR0efhqWLwIDAQAB
-----END PUBLIC KEY-----""";

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
