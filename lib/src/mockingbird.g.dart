// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mockingbird.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SyncModelRequest _$SyncModelRequestFromJson(Map<String, dynamic> json) =>
    SyncModelRequest(
      model: json['model'] as String,
      userId: json['user_id'] as String,
      lastUpdatedAt: json['last_updated_at'] as String,
    );

Map<String, dynamic> _$SyncModelRequestToJson(SyncModelRequest instance) =>
    <String, dynamic>{
      'model': instance.model,
      'last_updated_at': instance.lastUpdatedAt,
      'user_id': instance.userId,
    };

ConfigInfo _$ConfigInfoFromJson(Map<String, dynamic> json) => ConfigInfo(
      lang: json['lang'] as String,
      clientId: json['client_id'] as String,
      time: DateTime.parse(json['time'] as String),
    );

Map<String, dynamic> _$ConfigInfoToJson(ConfigInfo instance) =>
    <String, dynamic>{
      'lang': instance.lang,
      'client_id': instance.clientId,
      'time': instance.time.toIso8601String(),
    };

ChangeLang _$ChangeLangFromJson(Map<String, dynamic> json) => ChangeLang(
      lang: json['lang'] as String,
    );

Map<String, dynamic> _$ChangeLangToJson(ChangeLang instance) =>
    <String, dynamic>{
      'lang': instance.lang,
    };
