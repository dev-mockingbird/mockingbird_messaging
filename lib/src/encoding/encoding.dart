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
    return Uint8List.fromList(utf8.encode(jsonEncode(event)));
  }

  @override
  Event decode(Packet payload) {
    var utf8Encoded = utf8.decode(payload);
    var event = Event.fromJson(jsonDecode(utf8Encoded));
    event.unpackPayload();
    return event;
  }
}
