// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

import 'transport.dart';

class TcpTransport extends Transport {
  static const RT = 10;

  String ip;
  int port;
  final List<int> _stash = [];
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
    _stash.clear();
    sock.listen((m) {
      if (kDebugMode) {
        print("received: ${String.fromCharCodes(m)}");
      }
      for (var c in m) {
        if (c != RT) {
          _stash.add(c);
          continue;
        }
        var p = Uint8List.fromList(_stash);
        handle(p, this);
        _stash.clear();
      }
    }, onError: (e) {
      if (kDebugMode) {
        print(e);
      }
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
    Socket sock = await socket();
    String p = String.fromCharCodes(packet);
    if (kDebugMode) {
      print("send: $p");
    }
    sock.write("$p\n");
    return true;
  }

  socket() async {
    _socket ??= await Socket.connect(ip, port);
    _state = TransportConnectState.connected;
    return _socket;
  }
}
