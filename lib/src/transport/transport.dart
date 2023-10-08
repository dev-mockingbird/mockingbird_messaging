// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'package:flutter/foundation.dart';

typedef Packet = Uint8List;

abstract class SendCloser {
  Future send(Packet packet);
  Future close();
}

abstract class Layer {
  Future<Packet> encode(Packet p);
  Future<Packet> decode(Packet p);
}

class LayeredSendCloser extends SendCloser {
  List<Layer>? layers;
  final SendCloser sendCloser;

  LayeredSendCloser({required this.sendCloser, this.layers});

  @override
  Future send(Packet packet) async {
    List<Layer> ls = layers ?? [];
    for (var i = ls.length - 1; i >= 0; i--) {
      packet = await ls[i].encode(packet);
    }
    return await sendCloser.send(packet);
  }

  @override
  Future close() async {
    return await sendCloser.close();
  }
}

typedef TransportEventHandler = Future Function(Packet packet, SendCloser sc);

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
  Future send(Packet packet);
  Future close();

  @protected
  Future handle(Packet packet, SendCloser sc) async {
    for (var layer in layers) {
      packet = await layer.decode(packet);
    }
    for (var handler in handlers) {
      handler(packet, LayeredSendCloser(sendCloser: sc));
    }
  }

  pushLayer(Layer l) {
    layers.add(l);
  }
}
