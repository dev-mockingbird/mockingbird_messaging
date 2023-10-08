// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'dart:async';
import 'package:mockingbird_messaging/src/transport/rsa_helper.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'transport.dart';

class RSAEncrypter implements Layer {
  final RSAPublicKey publicKey;
  final RSAPrivateKey privateKey;

  RSAEncrypter({
    required this.publicKey,
    required this.privateKey,
  });

  @override
  Future<Packet> encode(Packet payload) async {
    return RsaKeyHelper().encrypt(payload, publicKey);
  }

  @override
  Future<Packet> decode(Packet payload) async {
    return RsaKeyHelper().decrypt(payload, privateKey);
  }
}
