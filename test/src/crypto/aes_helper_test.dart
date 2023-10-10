// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockingbird_messaging/src/crypto/aes_helper.dart';

main() {
  group("test aes", () {
    test("aes decrypt with client", () {
      var key = "MRZfmKCpToMGXCAdRWMSaZpwfawqeKHa";
      var encrypted = "1VI3pSFV5YmJc/2Jk3zLkFEhJvFA3WHHfEGuk8379BY=";
      var text = "hello world";
      var out = AESHelper.decrypt(
          base64Decode(encrypted), Uint8List.fromList(key.codeUnits));
      expect(String.fromCharCodes(out), text);
    });
    test("aes decrypt", () {
      var key = "MRZfmKCpToMGXCAdRWMSaZpwfawqeKHa";
      var text = "hello world";
      var out = AESHelper.encrypt(Uint8List.fromList(text.codeUnits),
          Uint8List.fromList(key.codeUnits));
      print("crypted: ${base64Encode(out)}");
      var r = AESHelper.decrypt(out, Uint8List.fromList(key.codeUnits));
      expect(String.fromCharCodes(r), text);
    });
  });
}
