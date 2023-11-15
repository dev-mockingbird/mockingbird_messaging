// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
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
  final Completer<bool> _handshake;
  late ServerOptions opt;
  late AsymmetricKeyPair<PublicKey, PrivateKey> clientKeyPair;
  bool _listening = false;
  bool _connected = false;
  Future Function()? onConnected;
  final String? cryptoMethod;
  final String? scramMethod;
  final String? compressMethod;
  final String? token;
  final String? username;
  final String? password;

  Miaoba({
    required this.transport,
    required super.encoding,
    this.onConnected,
    this.cryptoMethod,
    this.compressMethod,
    this.scramMethod,
    this.token,
    this.username,
    this.password,
  }) : _handshake = Completer<bool>();

  @override
  ConnectState get state {
    if (_connected) {
      return ConnectState.connected;
    } else if (_listening && !_connected) {
      return ConnectState.connecting;
    }
    return ConnectState.unconnect;
  }

  @override
  Future<bool> listen() {
    if (_listening) {
      return _handshake.future;
    }
    _listening = true;
    notifyListeners();
    transport.onDone = (trans) {
      _state = _State.init;
      _connected = false;
      _listening = false;
      notifyListeners();
      trans.layers.clear();
      Future.delayed(const Duration(seconds: 1))
          .then((value) => trans.listen());
    };
    transport.addEventHandler(handle);
    transport.listen();
    return _handshake.future;
  }

  Future handle(Packet payload, Transport t) async {
    Event e = decode(payload);
    switch (_state) {
      case _State.init:
        if (!await _init(e)) {
          _handshake.complete(false);
          await transport.close();
        }
        break;
      case _State.acceptCrypto:
        if (!await _acceptCrypto(e)) {
          _handshake.complete(false);
          await transport.close();
        }
        break;
      case _State.acceptCompress:
        if (!await _acceptCompress(e)) {
          _handshake.complete(false);
          await transport.close();
        }
        break;
      case _State.acceptAuth:
        if (!await _acceptAuth(e)) {
          _handshake.complete(false);
          await transport.close();
          return;
        }
        _connected = true;
        notifyListeners();
        if (onConnected != null) {
          await onConnected!();
        }
        if (!_handshake.isCompleted) {
          _handshake.complete(true);
        }
        break;
      case _State.connected:
        await callHandler(e);
    }
  }

  @override
  Future<bool> send(Event event) async {
    if (_connected) {
      await transport.send(encoding.encode(event));
      return true;
    }
    return false;
  }

  Future<bool> _acceptCrypto(Event e) async {
    if (e.type != CryptoAccepted.eventType) {
      setLastError(
          ErrorCode.unexpectedEvent, "[crypto-accepted] event expected");
      return false;
    }
    var opt = CryptoAccepted.fromJson(e.payload ?? {});
    var cm = cryptoMethod ?? AcceptCrypto.methodPlaintext;
    if (cm == AcceptCrypto.methodPlaintext) {
      return await _startAcceptCompress();
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
      return await _startAcceptCompress();
    }
    var publicKey = RSAHelper.parsePublicKeyFromPem(opt.publicKey!);
    if (publicKey == null) {
      setLastError(
          ErrorCode.invalidPublicKey, "public key from server is invalid");
      return false;
    }
    transport.pushLayer(RSAEncrypter(
      publicKey: publicKey,
      privateKey: clientKeyPair.privateKey as RSAPrivateKey,
      digestFactory: RSAEncrypter.getDigestFactory(hashName),
    ));
    return await _startAcceptCompress();
  }

  Future<bool> _startAcceptCompress() async {
    var cm = compressMethod ?? AcceptCompress.gzip;
    if (!opt.acceptCompress.contains(cm)) {
      setLastError(
        ErrorCode.unsupportedCompressMethod,
        "compress $cm not supported",
      );
      return false;
    }
    var p = encodePayload(AcceptCompress(compressMethod: cm));
    if (!await _send(p)) {
      return false;
    }
    _state = _State.acceptCompress;
    return true;
  }

  Future<bool> _acceptCompress(Event e) async {
    if (e.type != "compress-accepted") {
      setLastError(
        ErrorCode.unexpectedEvent,
        "[compress-accepted] event expected",
      );
      return false;
    }
    var cm = compressMethod ?? AcceptCompress.gzip;
    switch (cm) {
      case AcceptCompress.gzip:
        transport.pushLayer(GZip());
      default:
        setLastError(
          ErrorCode.unsupportedCompressMethod,
          "client not support compress $cm",
        );
        return false;
    }
    return await _startAcceptAuth();
  }

  Future<bool> _send(Packet e) async {
    if (!await transport.send(e)) {
      setLastError(
          ErrorCode.unableToDeliveryMessage, "can't send message to server");
      return false;
    }
    return true;
  }

  Future<bool> _startAcceptAuth() async {
    if (token != null) {
      var p = encodePayload(AcceptAuth(
        authMethod: AcceptAuth.methodToken,
        token: token,
      ));
      if (!await _send(p)) {
        return false;
      }
      _state = _State.acceptAuth;
      return true;
    }
    var sm = scramMethod ?? AcceptAuth.scramSha256;
    _scramAuth = ScramAuthenticator(
      sm,
      AcceptAuth.hash(sm),
      UsernamePasswordCredential(username: username, password: password),
    );
    var bs = _scramAuth!.handleMessage(_scramState!, Uint8List.fromList([]));
    if (bs == null) {
      setLastError(ErrorCode.authFailed, "can't get initial bytes");
      return false;
    }
    var p = encodePayload(AcceptAuth(
        authMethod: AcceptAuth.methodScram,
        mechanism: sm,
        info: base64Encode(bs)));
    if (!await _send(p)) {
      return false;
    }
    _scramState = SaslMessageType.AuthenticationSASLContinue;
    _state = _State.acceptAuth;
    return true;
  }

  Future<bool> _acceptAuth(Event e) async {
    if (_scramState == null || token != null) {
      if (e.type != "auth-accepted") {
        setLastError(ErrorCode.authFailed, "auth failed");
        return false;
      }
      _state = _State.connected;
      return true;
    }
    var info = ScramInfo.fromJson(e.payload!);
    var codes = base64Decode(info.info);
    var bs = _scramAuth!.handleMessage(_scramState!, codes);
    if (bs != null) {
      var p = encodePayload(ScramInfo(info: base64Encode(bs)));
      if (!await _send(p)) {
        return false;
      }
    }
    if (_scramState == SaslMessageType.AuthenticationSASLContinue) {
      _scramState = SaslMessageType.AuthenticationSASLFinal;
    } else if (_scramState == SaslMessageType.AuthenticationSASLFinal) {
      _scramState = null;
    }
    return true;
  }

  Future<bool> _init(Event e) async {
    if (e.type != ServerOptions.eventType) {
      setLastError(ErrorCode.unexpectedEvent, "not a server option message");
      return false;
    }
    opt = ServerOptions.fromJson(e.payload!);
    return await _startAcceptCrypto();
  }

  Future<bool> _startAcceptCrypto() async {
    var cm = cryptoMethod ?? AcceptCrypto.methodPlaintext;
    String? rsaKey;
    if (!opt.acceptCrypto.contains(cm)) {
      setLastError(
          ErrorCode.unsupportedAuthMethod, "unacceptable crypto method $cm");
      return false;
    }
    if (cm.contains("RSA")) {
      clientKeyPair = RSAHelper.generateKeyPair();
      rsaKey = RSAHelper.encodePublicKeyToPem(
        clientKeyPair.publicKey as RSAPublicKey,
      );
    }
    var p = encodePayload(AcceptCrypto(
      clientRSAPublicKey: rsaKey,
      cryptoMethod: cm,
    ));
    if (!await _send(p)) {
      return false;
    }
    _state = _State.acceptCrypto;
    return true;
  }

  @override
  Future stop() async {
    await transport.close();
    _state = _State.init;
    _connected = false;
    _listening = false;
    notifyListeners();
    transport.layers.clear();
  }
}
