// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'package:json_annotation/json_annotation.dart';

import '../event/event.dart';
part 'server_options.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AcceptAuth extends Payload {
  static const eventType = "accept-auth";
  static const methodToken = "AUTH-TOKEN";
  static const methodScram = "AUTH-SCRAM";

  String authMethod;
  String? token;
  String? username;
  String? password;

  AcceptAuth({
    required this.authMethod,
    this.token,
    this.username,
    this.password,
  });

  @override
  Map<String, dynamic> toJson() => _$AcceptAuthToJson(this);

  factory AcceptAuth.fromJson(Map<String, dynamic> json) =>
      _$AcceptAuthFromJson(json);

  @override
  String get type => eventType;
}

@JsonSerializable(fieldRename: FieldRename.snake)
class AcceptCrypto extends Payload {
  static const eventType = "accept-crypto";
  static const methodRsaSha1 = "RSA-SHA-1";
  static const methodRsaSha224 = "RSA-SHA-224";
  static const methodRsaSha256 = "RSA-SHA-256";
  static const methodRsaSha384 = "RSA-SHA-384";
  static const methodRsaSha512 = "RSA-SHA-512";
  static const methodAesRsaSha1 = "AES-RSA-SHA-1";
  static const methodAesRsaSha224 = "AES-RSA-SHA-224";
  static const methodAesRsaSha256 = "AES-RSA-SHA-256";
  static const methodAesRsaSha384 = "AES-RSA-SHA-384";
  static const methodAesRsaSha512 = "AES-RSA-SHA-512";
  static const methodPlaintext = "PLAINTEXT";

  String cryptoMethod;
  String? clientRSAPublicKey;
  AcceptCrypto({
    required this.cryptoMethod,
    this.clientRSAPublicKey,
  });

  @override
  Map<String, dynamic> toJson() => _$AcceptCryptoToJson(this);

  factory AcceptCrypto.fromJson(Map<String, dynamic> json) =>
      _$AcceptCryptoFromJson(json);

  @override
  String get type => eventType;
}

@JsonSerializable(fieldRename: FieldRename.snake)
class CryptoAccepted extends Payload {
  static const eventType = "crypto-accepted";

  String? publicKey;
  String? aesKey;

  CryptoAccepted({this.publicKey, this.aesKey});

  @override
  Map<String, dynamic> toJson() => _$CryptoAcceptedToJson(this);

  factory CryptoAccepted.fromJson(Map<String, dynamic> json) =>
      _$CryptoAcceptedFromJson(json);
  @override
  String get type => eventType;
}

@JsonSerializable(fieldRename: FieldRename.snake)
class AcceptCompress extends Payload {
  static const eventType = "accept-compress";
  static const compressNo = "NO";
  static const compressGzip = "GZIP";
  static const compressFlate = "FLATE";
  static const compressLzw = "LZW";
  static const compressZlib = "ZLIB";

  String compressMethod;
  String? order;
  int? litWidth;
  int? level;

  AcceptCompress({
    required this.compressMethod,
    this.order,
    this.litWidth,
    this.level,
  });

  @override
  Map<String, dynamic> toJson() => _$AcceptCompressToJson(this);

  factory AcceptCompress.fromJson(Map<String, dynamic> json) =>
      _$AcceptCompressFromJson(json);

  @override
  String get type => eventType;
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ServerOptions extends Payload {
  static const eventType = "server-options";
  List<String> acceptAuth;
  List<String> acceptCrypto;
  List<String> acceptCompress;
  DateTime time;
  ServerOptions({
    required this.acceptAuth,
    required this.acceptCompress,
    required this.acceptCrypto,
    required this.time,
  });

  factory ServerOptions.fromJson(Map<String, dynamic> json) =>
      _$ServerOptionsFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ServerOptionsToJson(this);

  @override
  String get type => eventType;
}
