// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'init_events.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SyncModel _$SyncModelFromJson(Map<String, dynamic> json) => SyncModel(
      actions: json['actions'] as List<dynamic>,
    );

Map<String, dynamic> _$SyncModelToJson(SyncModel instance) => <String, dynamic>{
      'actions': instance.actions,
    };

SyncModelChannel _$SyncModelChannelFromJson(Map<String, dynamic> json) =>
    SyncModelChannel(
      lastUpdatedAt: json['last_updated_at'] as String,
      ids: (json['ids'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$SyncModelChannelToJson(SyncModelChannel instance) =>
    <String, dynamic>{
      'last_updated_at': instance.lastUpdatedAt,
      'ids': instance.ids,
    };

SyncModelContact _$SyncModelContactFromJson(Map<String, dynamic> json) =>
    SyncModelContact(
      lastUpdatedAt: json['last_updated_at'] as String,
      ids: (json['ids'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$SyncModelContactToJson(SyncModelContact instance) =>
    <String, dynamic>{
      'last_updated_at': instance.lastUpdatedAt,
      'ids': instance.ids,
    };

SyncModelMessage _$SyncModelMessageFromJson(Map<String, dynamic> json) =>
    SyncModelMessage(
      lastUpdatedAt: json['last_updated_at'] as String,
      channelId: json['channel_id'] as String,
    );

Map<String, dynamic> _$SyncModelMessageToJson(SyncModelMessage instance) =>
    <String, dynamic>{
      'last_updated_at': instance.lastUpdatedAt,
      'channel_id': instance.channelId,
    };

SyncModelMessageLike _$SyncModelMessageLikeFromJson(
        Map<String, dynamic> json) =>
    SyncModelMessageLike(
      lastUpdatedAt: json['last_updated_at'] as String,
      channelId: json['channel_id'] as String,
    );

Map<String, dynamic> _$SyncModelMessageLikeToJson(
        SyncModelMessageLike instance) =>
    <String, dynamic>{
      'last_updated_at': instance.lastUpdatedAt,
      'channel_id': instance.channelId,
    };

SyncModelMessageTag _$SyncModelMessageTagFromJson(Map<String, dynamic> json) =>
    SyncModelMessageTag(
      lastUpdatedAt: json['last_updated_at'] as String,
      channelId: json['channel_id'] as String,
    );

Map<String, dynamic> _$SyncModelMessageTagToJson(
        SyncModelMessageTag instance) =>
    <String, dynamic>{
      'last_updated_at': instance.lastUpdatedAt,
      'channel_id': instance.channelId,
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
