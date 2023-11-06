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
  List<EventHandler> _handlers = [];
  Protocol({required this.encoding});
  send(Event event);
  Future listen();
  Future stop();
  addEventListner(EventHandler handler) {
    if (!_handlers.contains(handler)) {
      _handlers.add(handler);
    }
  }

  removeEventListner(EventHandler handler) {
    if (_handlers.contains(handler)) {
      _handlers.remove(handler);
    }
  }

  @protected
  callHandler(Event e) {
    for (var handler in _handlers) {
      handler.handle(e);
    }
  }

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
