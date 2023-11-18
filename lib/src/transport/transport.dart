// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'dart:convert';

import 'package:flutter/foundation.dart';

typedef Packet = Uint8List;

abstract class Layer {
  Future<Packet> encode(Packet p);
  Future<Packet> decode(Packet p);
}

enum TransportConnectState {
  unconnected,
  connecting,
  connected,
}

typedef TransportEventHandler = Future Function(Packet packet, Transport t);

abstract class Transport extends ChangeNotifier {
  List<TransportEventHandler> handlers = [];
  List<Layer> layers = [];
  set onDone(Function(Transport)? onDone);
  TransportConnectState _state = TransportConnectState.unconnected;
  addEventHandler(TransportEventHandler handler) {
    handlers.add(handler);
  }

  removeEventHandler(TransportEventHandler handler) {
    handlers.remove(handler);
  }

  Future listen();

  @protected
  setState(TransportConnectState state) {
    _state = state;
    notifyListeners();
  }

  TransportConnectState get state {
    return _state;
  }

  Future send(Packet packet) async {
    List<Layer> ls = layers;
    for (var i = 0; i < ls.length; i++) {
      packet = await ls[i].encode(packet);
    }
    var s = base64Encode(packet);
    return await sendPacket(Uint8List.fromList(s.codeUnits));
  }

  Future<bool> sendPacket(Packet packet);

  Future close();

  @protected
  Future handle(Packet packet, Transport sc) async {
    try {
      packet = base64Decode(String.fromCharCodes(packet));
      for (var i = layers.length - 1; i >= 0; i--) {
        packet = await layers[i].decode(packet);
      }
      for (var handler in handlers) {
        handler(packet, this);
      }
    } catch (e) {
      print("handle event: $e");
    }
  }

  pushLayer(Layer l) {
    layers.add(l);
  }
}
