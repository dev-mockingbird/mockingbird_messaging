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

  WebsocketTransport(
    this.endpoint, {
    this.onDone,
  });

  @override
  Future listen() async {
    if (state != TransportConnectState.unconnected) {
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
        setState(TransportConnectState.unconnected);
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
    if (state == TransportConnectState.connected) {
      _connectedChannel.sink.add(packet);
      return true;
    }
    return false;
  }

  @override
  Future close() async {
    if (state == TransportConnectState.connected) {
      setState(TransportConnectState.unconnected);
      _normalStop = true;
      await _channel!.sink.close(status.goingAway);
      _channel = null;
    }
    return;
  }

  WebSocketChannel get _connectedChannel {
    if (state == TransportConnectState.connected) {
      return _channel!;
    }
    setState(TransportConnectState.connected);
    final wsUrl = Uri.parse(endpoint);
    _channel = WebSocketChannel.connect(wsUrl);
    return _channel!;
  }
}
