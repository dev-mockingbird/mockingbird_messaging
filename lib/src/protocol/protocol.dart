// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'package:flutter/foundation.dart';
import 'package:mockingbird_messaging/src/event/event.dart';

import '../encoding/encoding.dart';
import '../transport/transport.dart';

enum ConnectState {
  unconnect,
  connecting,
  connected,
}

abstract class Protocol extends ChangeNotifier {
  Encoding encoding;
  EventHandler? handler;
  Protocol({required this.encoding});
  send(Event event);
  Future listen();
  Future stop();
  set onConnected(Future Function() onConnected);
  ConnectState get state;

  @protected
  Packet encode(Event data) {
    return encoding.encode(data);
  }

  Packet encodePayload(Payload payload) {
    return encoding.encode(buildEvent(payload));
  }

  @protected
  Event decode(Packet data) {
    return encoding.decode(data);
  }
}
