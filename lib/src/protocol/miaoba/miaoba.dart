// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:mockingbird_messaging/src/event/event.dart';
import 'package:mockingbird_messaging/src/protocol/protocol.dart';
import 'package:mockingbird_messaging/src/transport/encrypt.dart';
import 'package:mockingbird_messaging/src/crypto/rsa_helper.dart';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:sasl_scram/sasl_scram.dart';
import '../../compress/gzip.dart';
import '../../transport/transport.dart';
import 'server_options.dart';

enum _State {
  init,
  acceptCrypto,
  acceptCompress,
  acceptAuth,
  connected,
}

class Miaoba extends Protocol {
  Transport transport;
  _State _state = _State.init;
  SaslMessageType? _scramState = SaslMessageType.AuthenticationSASL;
  Authenticator? _scramAuth;
  final Completer _handshake;
  late ServerOptions opt;
  late AsymmetricKeyPair<PublicKey, PrivateKey> clientKeyPair;
  bool _listening = false;
  final String? cryptoMethod;
  final String? scramMethod;
  final String? compressMethod;
  final String? token;
  final String? username;
  final String? password;

  Miaoba({
    required this.transport,
    required super.encoding,
    this.cryptoMethod,
    this.compressMethod,
    this.scramMethod,
    this.token,
    this.username,
    this.password,
  }) : _handshake = Completer();

  @override
  Future listen() {
    if (_listening) {
      return _handshake.future;
    }
    _listening = true;
    transport.addEventHandler(handle);
    transport.listen();
    return _handshake.future;
  }

  Future handle(Packet payload, Transport t) async {
    Event e = decode(payload);
    switch (_state) {
      case _State.init:
        return _init(e);
      case _State.acceptCrypto:
        return _acceptCrypto(e);
      case _State.acceptCompress:
        return _acceptCompress(e);
      case _State.acceptAuth:
        _acceptAuth(e);
        _handshake.complete();
      case _State.connected:
        if (handler != null) {
          return handler!.handle(e);
        }
    }
  }

  @override
  send(Event event) {
    return transport.send(encoding.encode(event));
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
    var hashName = cm.replaceAll("AES-", "").replaceAll("RSA-", "");
    if (cm.contains("AES-")) {
      var encAesKey = base64Decode(opt.aesKey!);
      var encrypter = RSAEncrypter(
        publicKey: clientKeyPair.publicKey as RSAPublicKey,
        privateKey: clientKeyPair.privateKey as RSAPrivateKey,
        digestFactory: RSAEncrypter.getDigestFactory(hashName),
      );
      var aesKey = await encrypter.decode(encAesKey);
      transport.pushLayer(AESEncrypter(key: aesKey));
      return _startAcceptCompress();
    }
    var publicKey = RSAHelper.parsePublicKeyFromPem(opt.publicKey!);
    if (publicKey == null) {
      throw Exception("public key from server is invalid");
    }
    transport.pushLayer(RSAEncrypter(
      publicKey: publicKey,
      privateKey: clientKeyPair.privateKey as RSAPrivateKey,
      digestFactory: RSAEncrypter.getDigestFactory(hashName),
    ));
    return _startAcceptCompress();
  }

  _startAcceptCompress() {
    var cm = compressMethod ?? AcceptCompress.gzip;
    if (!opt.acceptCompress.contains(cm)) {
      throw Exception("compress $cm not supported");
    }
    transport.send(encodePayload(AcceptCompress(compressMethod: cm)));

    _state = _State.acceptCompress;
  }

  _acceptCompress(Event e) {
    if (e.type != "compress-accepted") {
      throw Exception("[compress-accepted] event expected");
    }
    var cm = compressMethod ?? AcceptCompress.gzip;
    switch (cm) {
      case AcceptCompress.gzip:
        transport.pushLayer(GZip());
      default:
        throw Exception("client not support compress $cm");
    }
    _startAcceptAuth();
  }

  _startAcceptAuth() {
    if (token != null) {
      transport.send(encodePayload(
          AcceptAuth(authMethod: AcceptAuth.methodToken, token: token)));
      _state = _State.acceptAuth;
      return;
    }
    var sm = scramMethod ?? AcceptAuth.scramSha256;
    _scramAuth = ScramAuthenticator(sm, AcceptAuth.hash(sm),
        UsernamePasswordCredential(username: username, password: password));
    var bs = _scramAuth!.handleMessage(_scramState!, Uint8List.fromList([]));
    if (bs == null) {
      throw Exception("can't get initial bytes");
    }
    transport.send(encodePayload(AcceptAuth(
        authMethod: AcceptAuth.methodScram,
        mechanism: sm,
        info: base64Encode(bs))));
    _scramState = SaslMessageType.AuthenticationSASLContinue;
    _state = _State.acceptAuth;
  }

  _acceptAuth(Event e) {
    if (_scramState == null || token != null) {
      if (e.type != "auth-accepted") {
        throw Exception("auth failed");
      }
      _state = _State.connected;
      return;
    }
    var info = ScramInfo.fromJson(e.payload!);
    var codes = base64Decode(info.info);
    var bs = _scramAuth!.handleMessage(_scramState!, codes);
    if (bs != null) {
      transport.send(encodePayload(ScramInfo(info: base64Encode(bs))));
    }
    if (_scramState == SaslMessageType.AuthenticationSASLContinue) {
      _scramState = SaslMessageType.AuthenticationSASLFinal;
    } else if (_scramState == SaslMessageType.AuthenticationSASLFinal) {
      _scramState = null;
    }
  }

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
      throw Exception("unacceptable crypto method $cm");
    }
    if (cm.contains("RSA")) {
      clientKeyPair = RSAHelper.generateKeyPair();
      rsaKey = RSAHelper.encodePublicKeyToPem(
        clientKeyPair.publicKey as RSAPublicKey,
      );
    }
    transport.send(encodePayload(AcceptCrypto(
      clientRSAPublicKey: rsaKey,
      cryptoMethod: cm,
    )));
    _state = _State.acceptCrypto;
  }
}
