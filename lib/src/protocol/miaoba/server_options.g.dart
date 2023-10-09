// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScramInfo _$ScramInfoFromJson(Map<String, dynamic> json) => ScramInfo(
      info: json['info'] as String,
    );

Map<String, dynamic> _$ScramInfoToJson(ScramInfo instance) => <String, dynamic>{
      'info': instance.info,
    };

AcceptAuth _$AcceptAuthFromJson(Map<String, dynamic> json) => AcceptAuth(
      authMethod: json['auth_method'] as String,
      token: json['token'] as String?,
      info: json['info'] as String?,
    );

Map<String, dynamic> _$AcceptAuthToJson(AcceptAuth instance) =>
    <String, dynamic>{
      'auth_method': instance.authMethod,
      'token': instance.token,
      'info': instance.info,
    };

AcceptCrypto _$AcceptCryptoFromJson(Map<String, dynamic> json) => AcceptCrypto(
      cryptoMethod: json['crypto_method'] as String,
      clientRSAPublicKey: json['client_rsa_public_key'] as String?,
    );

Map<String, dynamic> _$AcceptCryptoToJson(AcceptCrypto instance) =>
    <String, dynamic>{
      'crypto_method': instance.cryptoMethod,
      'client_rsa_public_key': instance.clientRSAPublicKey,
    };

CryptoAccepted _$CryptoAcceptedFromJson(Map<String, dynamic> json) =>
    CryptoAccepted(
      publicKey: json['public_key'] as String?,
      aesKey: json['aes_key'] as String?,
    );

Map<String, dynamic> _$CryptoAcceptedToJson(CryptoAccepted instance) =>
    <String, dynamic>{
      'public_key': instance.publicKey,
      'aes_key': instance.aesKey,
    };

AcceptCompress _$AcceptCompressFromJson(Map<String, dynamic> json) =>
    AcceptCompress(
      compressMethod: json['compress_method'] as String,
      order: json['order'] as String?,
      litWidth: json['lit_width'] as int?,
      level: json['level'] as int?,
    );

Map<String, dynamic> _$AcceptCompressToJson(AcceptCompress instance) =>
    <String, dynamic>{
      'compress_method': instance.compressMethod,
      'order': instance.order,
      'lit_width': instance.litWidth,
      'level': instance.level,
    };

ServerOptions _$ServerOptionsFromJson(Map<String, dynamic> json) =>
    ServerOptions(
      acceptAuth: (json['accept_auth'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      acceptCompress: (json['accept_compress'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      acceptCrypto: (json['accept_crypto'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      time: DateTime.parse(json['time'] as String),
    );

Map<String, dynamic> _$ServerOptionsToJson(ServerOptions instance) =>
    <String, dynamic>{
      'accept_auth': instance.acceptAuth,
      'accept_crypto': instance.acceptCrypto,
      'accept_compress': instance.acceptCompress,
      'time': instance.time.toIso8601String(),
    };
