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

typedef TransportEventHandler = Future Function(Packet packet, Transport t);

abstract class Transport extends ChangeNotifier {
  List<TransportEventHandler> handlers = [];
  List<Layer> layers = [];
  addEventHandler(TransportEventHandler handler) {
    handlers.add(handler);
  }

  removeEventHandler(TransportEventHandler handler) {
    handlers.remove(handler);
  }

  Future listen();

  Future send(Packet packet) async {
    List<Layer> ls = layers;
    for (var i = ls.length - 1; i >= 0; i--) {
      packet = await ls[i].encode(packet);
    }
    var s = base64Encode(packet);
    print("send: $s");
    return await sendPacket(Uint8List.fromList(s.codeUnits));
  }

  Future sendPacket(Packet packet);

  Future close();

  @protected
  Future handle(Packet packet, Transport sc) async {
    packet = base64Decode(String.fromCharCodes(packet));
    for (var layer in layers) {
      packet = await layer.decode(packet);
    }
    for (var handler in handlers) {
      handler(packet, this);
    }
  }

  pushLayer(Layer l) {
    layers.add(l);
  }
}
