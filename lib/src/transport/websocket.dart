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
  WebSocketChannel? _channel;
  String endpoint;
  Function(Transport)? onDone;
  bool _normalStop = false;

  WebsocketConnectState _state;

  WebsocketTransport(
    this.endpoint, {
    this.onDone,
  }) : _state = WebsocketConnectState.unconnected;

  WebsocketConnectState get state {
    return _state;
  }

  @override
  Future listen() async {
    if (_state != WebsocketConnectState.unconnected) {
      return;
    }
    _normalStop = false;
    _connectedChannel.stream.listen(
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
        print(
            "websocket closed: ${_channel?.closeCode}: ${_channel?.closeReason}");
        if (onDone != null) {
          onDone!(this);
        }
      },
    );
  }

  @override
  Future<bool> sendPacket(Packet packet) async {
    if (_state == WebsocketConnectState.connected) {
      _connectedChannel.sink.add(packet);
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

  WebSocketChannel get _connectedChannel {
    if (_state == WebsocketConnectState.connected) {
      return _channel!;
    }
    _state = WebsocketConnectState.connected;
    final wsUrl = Uri.parse(endpoint);
    _channel = WebSocketChannel.connect(wsUrl);
    return _channel!;
  }
}
