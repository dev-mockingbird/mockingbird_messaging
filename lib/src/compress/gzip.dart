// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'dart:typed_data';

import '../transport/transport.dart';
import 'package:archive/archive.dart';

class GZip extends Layer {
  @override
  Future<Packet> encode(Packet p) async {
    final r = GZipEncoder().encode(p);
    if (r == null) {
      return Uint8List.fromList([]);
    }
    return r as Uint8List;
  }

  @override
  Future<Packet> decode(Packet p) async {
    return GZipDecoder().decodeBytes(p) as Packet;
  }
}
