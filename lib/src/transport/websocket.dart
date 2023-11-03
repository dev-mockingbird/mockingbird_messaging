// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/foundation.dart';
import 'package:mockingbird_messaging/src/transport/transport.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

enum WebsocketConnectState {
  unconnected,
  connecting,
  connected,
}

class WebsocketTransport extends Transport {
  static final Map<String, WebsocketTransport> _internal = {};

  WebSocketChannel? _channel;
  String endpoint;
  VoidCallback? onDone;
  bool _normalStop = false;

  WebsocketConnectState _state = WebsocketConnectState.unconnected;

  factory WebsocketTransport(String ep) {
    if (_internal.containsKey(ep)) {
      return _internal[ep]!;
    }
    _internal[ep] = WebsocketTransport._(endpoint: ep);
    return _internal[ep]!;
  }

  WebsocketTransport._({required this.endpoint});

  WebsocketConnectState get state {
    return _state;
  }

  @override
  Future listen() async {
    if (_state != WebsocketConnectState.unconnected) {
      return;
    }
    _normalStop = false;
    channel.stream.listen(
      (m) {
        handle(Uint8List.fromList(m.codeUnits), this);
      },
      onError: (error) {
        if (kDebugMode) {
          print(error);
        }
      },
      onDone: () async {
        _state = WebsocketConnectState.unconnected;
        if (_normalStop) {
          return;
        }
        if (onDone != null) {
          onDone!();
        }
      },
    );
  }

  @override
  Future<bool> sendPacket(Packet packet) async {
    if (_state == WebsocketConnectState.connected) {
      channel.sink.add(packet);
      return true;
    }
    return false;
  }

  @override
  Future close() async {
    if (_state == WebsocketConnectState.connected) {
      _state = WebsocketConnectState.unconnected;
      _normalStop = true;
      await _channel!.sink.close(status.goingAway);
      _channel = null;
    }
    return;
  }

  WebSocketChannel get channel {
    if (_state == WebsocketConnectState.connected) {
      return _channel!;
    }
    _state = WebsocketConnectState.connected;
    final wsUrl = Uri.parse(endpoint);
    _channel = WebSocketChannel.connect(wsUrl);
    return _channel!;
  }
}
