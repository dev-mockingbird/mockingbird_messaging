// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'dart:collection';
import 'dart:convert';
import 'package:mockingbird_messaging/src/event/event.dart';
import 'package:mockingbird_messaging/src/protocol/protocol.dart';
import 'package:mockingbird_messaging/src/transport/encrypt.dart';
import 'package:mockingbird_messaging/src/transport/rsa_helper.dart';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/asymmetric/api.dart';
import '../transport/transport.dart';
import 'server_options.dart';

enum MiaobaState {
  init,
  acceptCrypto,
  acceptCompress,
  acceptAuth,
  connected,
}

class Miaoba extends Protocol {
  Transport transport;
  final Queue<Event> _stash = Queue<Event>();
  MiaobaState _state = MiaobaState.init;
  late ServerOptions opt;
  late AsymmetricKeyPair<PublicKey, PrivateKey> clientKeyPair;
  final String? cryptoMethod;
  final String? token;
  final String? username;
  final String? password;

  Miaoba({
    required this.transport,
    required super.encoding,
    this.cryptoMethod,
    this.token,
    this.username,
    this.password,
  });

  @override
  listen() {
    transport.addEventHandler(handle);
    transport.listen();
  }

  Future handle(Packet payload, SendCloser sc) async {
    Event e = decode(payload);
    switch (_state) {
      case MiaobaState.init:
        return _init(e);
      case MiaobaState.acceptCrypto:
        return _acceptCrypto(e);
      case MiaobaState.acceptCompress:
        return _acceptCompress(e);
      case MiaobaState.acceptAuth:
        return _acceptAuth(e);
      case MiaobaState.connected:
    }
  }

  @override
  send(Event event) {
    if (_state == MiaobaState.connected) {
      return transport.send(encoding.encode(event));
    }
    _stash.addLast(event);
  }

  _acceptCrypto(Event e) async {
    if (e.type != CryptoAccepted.eventType) {
      throw Exception("[crypto-accepted] event expected");
    }
    var opt = CryptoAccepted.fromJson(e.payload ?? {});
    var cm = cryptoMethod ?? AcceptCrypto.methodPlaintext;
    if (cm == AcceptCrypto.methodPlaintext) {
      return _startAcceptCompress();
    }
    if (cm.contains("AES-")) {
      var encAesKey = base64Decode(opt.aesKey!);
      var encrypter = RSAEncrypter(
        publicKey: clientKeyPair.publicKey as RSAPublicKey,
        privateKey: clientKeyPair.privateKey as RSAPrivateKey,
      );
      var aesKey = await encrypter.decode(encAesKey);
      // TODO: push aes encrypter layer
    }
    var publicKey = RsaKeyHelper().parsePublicKeyFromPem(opt.publicKey!);
    if (publicKey == null) {
      throw Exception("public key from server is invalid");
    }
    transport.pushLayer(RSAEncrypter(
      publicKey: publicKey,
      privateKey: clientKeyPair.privateKey as RSAPrivateKey,
    ));
    return _startAcceptCompress();
  }

  _startAcceptCompress() {}

  _acceptCompress(Event e) {}

  _acceptAuth(Event e) {}

  _init(Event e) async {
    if (e.type != ServerOptions.eventType) {
      throw Exception("not a server option message");
    }
    opt = ServerOptions.fromJson(e.payload!);
    return _startAcceptCrypto();
  }

  _startAcceptCrypto() {
    var cm = cryptoMethod ?? AcceptCrypto.methodPlaintext;
    String? rsaKey;
    if (!opt.acceptCrypto.contains(cm)) {
      throw Exception("unkown crypto method $cm");
    }
    if (cm.contains("RSA")) {
      clientKeyPair = RsaKeyHelper().generateKeyPair();
      rsaKey = RsaKeyHelper()
          .encodePublicKeyToPem(clientKeyPair.publicKey as RSAPublicKey);
    }
    transport.send(encodePayload(AcceptCrypto(
      clientRSAPublicKey: rsaKey,
      cryptoMethod: cm,
    )));
    _state = MiaobaState.acceptCrypto;
  }

  _confirmOptions(Event e) async {
    if (e.type != "server-confirmed-options") {
      throw Exception("not a server-confirmed-options");
    }

    while (_stash.isNotEmpty) {
      send(_stash.removeFirst());
    }
  }
}
