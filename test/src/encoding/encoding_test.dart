// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockingbird_messaging/src/event/event.dart';

void main() async {
  group("miaoba", () {
    test("encoding", () async {
      var e = Event(type: "test");
      e.withMeta("hello", "world");
      var data = jsonEncode(e);
      print(data);
      var r = jsonDecode(data);
      var t = Event.fromJson(r);
      print(t);
    });
  });
}
