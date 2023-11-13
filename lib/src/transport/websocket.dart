// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/foundation.dart';
import 'package:mockingbird_messaging/src/transport/transport.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class WebsocketTransport extends Transport {
  WebSocketChannel? _channel;
  String endpoint;
  Function(Transport)? onDone;
  bool _normalStop = false;

  TransportConnectState _state;

  WebsocketTransport(
    this.endpoint, {
    this.onDone,
  }) : _state = TransportConnectState.unconnected;

  TransportConnectState get state {
    return _state;
  }

  @override
  Future listen() async {
    if (_state != TransportConnectState.unconnected) {
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
        _state = TransportConnectState.unconnected;
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
    if (_state == TransportConnectState.connected) {
      _connectedChannel.sink.add(packet);
      return true;
    }
    return false;
  }

  @override
  Future close() async {
    if (_state == TransportConnectState.connected) {
      _state = TransportConnectState.unconnected;
      _normalStop = true;
      await _channel!.sink.close(status.goingAway);
      _channel = null;
    }
    return;
  }

  WebSocketChannel get _connectedChannel {
    if (_state == TransportConnectState.connected) {
      return _channel!;
    }
    _state = TransportConnectState.connected;
    final wsUrl = Uri.parse(endpoint);
    _channel = WebSocketChannel.connect(wsUrl);
    return _channel!;
  }
}
