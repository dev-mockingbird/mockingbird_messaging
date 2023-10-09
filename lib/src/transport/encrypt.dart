// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'dart:async';
import 'dart:typed_data';
import 'package:mockingbird_messaging/src/crypto/rsa_helper.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:pointycastle/export.dart';
import '../crypto/aes_helper.dart';
import 'transport.dart';

class RSAEncrypter implements Layer {
  final RSAPublicKey publicKey;
  final RSAPrivateKey privateKey;
  DigestFactory digestFactory;

  static DigestFactory getDigestFactory(String name) {
    switch (name) {
      case "SHA-1":
        return () {
          return SHA1Digest();
        };
      case "SHA-224":
        return () {
          return SHA224Digest();
        };
      case "SHA-256":
        return () {
          return SHA256Digest();
        };
      case "SHA-384":
        return () {
          return SHA384Digest();
        };
      case "SHA-512":
        return () {
          return SHA512Digest();
        };
      case "SHA3-1":
        return () {
          return SHA3Digest();
        };
      case "SHA3-224":
        return () {
          return SHA3Digest(224);
        };
      case "SHA3-256":
        return () {
          return SHA3Digest(256);
        };
      case "SHA3-384":
        return () {
          return SHA3Digest(384);
        };
      case "SHA3-512":
        return () {
          return SHA3Digest(512);
        };
      default:
        throw Exception("unsupported digest [$name]");
    }
  }

  RSAEncrypter({
    required this.publicKey,
    required this.privateKey,
    required this.digestFactory,
  });

  @override
  Future<Packet> encode(Packet payload) async {
    return RSAHelper.encrypt(payload, publicKey, digestFactory);
  }

  @override
  Future<Packet> decode(Packet payload) async {
    return RSAHelper.decrypt(payload, privateKey, digestFactory);
  }
}

class AESEncrypter implements Layer {
  final Uint8List key;

  AESEncrypter({required this.key});

  @override
  Future<Packet> encode(Packet payload) async {
    return AESHelper.encrypt(payload, key);
  }

  @override
  Future<Packet> decode(Packet payload) async {
    return AESHelper.decrypt(payload, key);
  }
}
