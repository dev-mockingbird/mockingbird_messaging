// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'package:crypto/crypto.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../event/event.dart';
part 'server_options.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ScramInfo extends Payload {
  static const eventType = "scram-info";
  String info;

  ScramInfo({required this.info});

  @override
  Map<String, dynamic> toJson() => _$ScramInfoToJson(this);

  factory ScramInfo.fromJson(Map<String, dynamic> json) =>
      _$ScramInfoFromJson(json);

  @override
  String get type => eventType;
}

@JsonSerializable(fieldRename: FieldRename.snake)
class AcceptAuth extends Payload {
  static const eventType = "accept-auth";
  static const methodToken = "AUTH-TOKEN";
  static const methodScram = "AUTH-SCRAM";

  static const scramSha1 = "SCRAM-SHA-1";
  static const scramSha1PLUS = "SCRAM-SHA-1-PLUS";
  static const scramSha256 = "SCRAM-SHA-256";
  static const scramSha256PLUS = "SCRAM-SHA-256-PLUS";
  static const scramSha512 = "SCRAM-SHA-512";
  static const scramSha512PLUS = "SCRAM-SHA-512-PLUS";
  static const scramSha224 = "SCRAM-SHA-224";
  static const scramSha224PLUS = "SCRAM-SHA-224-PLUS";
  static const scramSha384 = "SCRAM-SHA-384";
  static const scramSha384PLUS = "SCRAM-SHA-384-PLUS";
  static const scramSha3224 = "SCRAM-SHA3-224";
  static const scramSha3224PLUS = "SCRAM-SHA3-224-PLUS";
  static const scramSha3256 = "SCRAM-SHA3-256";
  static const scramSha3256PLUS = "SCRAM-SHA3-256-PLUS";
  static const scramSha3384 = "SCRAM-SHA3-384";
  static const scramSha3384PLUS = "SCRAM-SHA3-384-PLUS";
  static const scramSha3512 = "SCRAM-SHA3-512";
  static const scramSha3512PLUS = "SCRAM-SHA3-512-PLUS";

  static Hash hash(String hashName) {
    switch (hashName) {
      case scramSha1:
      case scramSha1PLUS:
        return sha1;
      case scramSha224:
      case scramSha224PLUS:
        return sha224;
      case scramSha256:
      case scramSha256PLUS:
        return sha256;
      case scramSha384:
      case scramSha384PLUS:
        return sha384;
      case scramSha512:
      case scramSha512PLUS:
        return sha512;
      default:
        throw Exception("hash name not supported");
    }
  }

  String authMethod;
  String? mechanism;
  String? token;
  String? info;

  AcceptAuth({
    required this.authMethod,
    this.token,
    this.info,
    this.mechanism,
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
  @JsonKey(name: 'client_rsa_public_key')
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
  static const no = "NO";
  static const gzip = "GZIP";
  static const flate = "FLATE";
  static const lzw = "LZW";
  static const zlib = "ZLIB";

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
