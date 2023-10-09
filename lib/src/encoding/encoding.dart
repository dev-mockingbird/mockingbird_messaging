// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mockingbird_messaging/src/event/event.dart';
import 'package:mockingbird_messaging/src/transport/transport.dart';

abstract class Encoding {
  Packet encode(Event event);
  Event decode(Packet payload);
}

class JsonEncoding extends Encoding {
  @override
  Packet encode(Event event) {
    event.packPayload();
    return Uint8List.fromList(jsonEncode(event).codeUnits);
  }

  @override
  Event decode(Packet payload) {
    var event = Event.fromJson(jsonDecode(String.fromCharCodes(payload)));
    event.unpackPayload();
    return event;
  }
}
