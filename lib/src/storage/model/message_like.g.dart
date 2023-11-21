// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_like.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageLike _$MessageLikeFromJson(Map<String, dynamic> json) => MessageLike(
      id: json['id'] as String,
      channelId: json['channel_id'] as String,
      messageId: json['message_id'] as String,
      creatorUserId: json['creator_user_id'] as String,
      amount: json['amount'] as int,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$MessageLikeToJson(MessageLike instance) =>
    <String, dynamic>{
      'id': instance.id,
      'channel_id': instance.channelId,
      'message_id': instance.messageId,
      'creator_user_id': instance.creatorUserId,
      'amount': instance.amount,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
