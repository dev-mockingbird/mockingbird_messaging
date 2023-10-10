// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockingbird_messaging/src/compress/gzip.dart';

main() {
  group("test gzip", () {
    test("gzip", () async {
      var text = "hello world";
      var gzip = GZip();
      var out = await gzip.encode(Uint8List.fromList(text.codeUnits));
      print(base64Encode(out));
      var r = await gzip.decode(out);
      expect(String.fromCharCodes(r), text);
    });
  });
}
