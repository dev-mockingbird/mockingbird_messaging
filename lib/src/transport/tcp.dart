// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'dart:io';
import 'dart:typed_data';

import 'transport.dart';

class TcpTransport extends Transport {
  String ip;
  int port;
  Function(Transport)? onDone;
  bool _normalStop = false;

  TransportConnectState _state = TransportConnectState.unconnected;

  TcpTransport({
    required this.ip,
    required this.port,
    this.onDone,
  });

  Socket? _socket;

  @override
  Future close() async {
    if (_state == TransportConnectState.connected) {
      _normalStop = true;
      return await _socket?.close();
    }
  }

  @override
  Future listen() async {
    if (_state != TransportConnectState.unconnected) {
      return;
    }
    Socket sock = await socket();
    sock.listen((m) {
      handle(Uint8List.fromList(m), this);
    }, onDone: () {
      _state = TransportConnectState.unconnected;
      if (_normalStop) {
        return;
      }
      if (onDone != null) {
        onDone!(this);
      }
    });
  }

  @override
  Future<bool> sendPacket(Packet packet) async {
    if (_state == TransportConnectState.connected) {
      Socket sock = await socket();
      sock.write(packet);
      return true;
    }
    return false;
  }

  socket() async {
    _socket ??= await Socket.connect(ip, port);
    _state = TransportConnectState.connected;
    return _socket;
  }
}
