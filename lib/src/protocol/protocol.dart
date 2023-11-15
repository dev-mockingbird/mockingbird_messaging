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

enum ErrorCode {
  ok,
  unsupportedAuthMethod,
  unsupportedCompressMethod,
  unexpectedEvent,
  unableToDeliveryMessage,
  invalidPublicKey,
  authFailed,
}

abstract class Protocol extends ChangeNotifier {
  Encoding encoding;
  final List<EventHandler> _handlers = [];
  ErrorCode _lastCode = ErrorCode.ok;
  String _lastError = "";
  Protocol({required this.encoding});
  send(Event event);
  Future<bool> listen();
  Future stop();
  addEventListner(EventHandler handler) {
    if (!_handlers.contains(handler)) {
      _handlers.add(handler);
    }
  }

  ErrorCode get lastCode {
    return _lastCode;
  }

  String get lastError {
    return _lastError;
  }

  @protected
  setLastError(ErrorCode code, String error) {
    _lastCode = code;
    _lastError = error;
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
