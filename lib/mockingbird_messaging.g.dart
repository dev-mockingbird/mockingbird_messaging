// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mockingbird_messaging.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SyncModelRequest _$SyncModelRequestFromJson(Map<String, dynamic> json) =>
    SyncModelRequest(
      model: json['model'] as String,
      latestOffset: json['latest_offset'] as int?,
    );

Map<String, dynamic> _$SyncModelRequestToJson(SyncModelRequest instance) =>
    <String, dynamic>{
      'model': instance.model,
      'latest_offset': instance.latestOffset,
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
