// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_tag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageTag _$MessageTagFromJson(Map<String, dynamic> json) => MessageTag(
      id: json['id'] as String,
      channelId: json['channel_id'] as String,
      messageId: json['message_id'] as String,
      creatorUserId: json['creator_user_id'] as String,
      tag: json['tag'] as String,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$MessageTagToJson(MessageTag instance) =>
    <String, dynamic>{
      'id': instance.id,
      'channel_id': instance.channelId,
      'message_id': instance.messageId,
      'creator_user_id': instance.creatorUserId,
      'tag': instance.tag,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
