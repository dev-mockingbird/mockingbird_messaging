// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TypeMessage _$TypeMessageFromJson(Map<String, dynamic> json) => TypeMessage(
      channelId: json['channel_id'] as String,
      contentType: json['content_type'] as String,
      content: json['content'] as String,
      userId: json['user_id'] as String,
    );

Map<String, dynamic> _$TypeMessageToJson(TypeMessage instance) =>
    <String, dynamic>{
      'channel_id': instance.channelId,
      'user_id': instance.userId,
      'content_type': instance.contentType,
      'content': instance.content,
    };

CreateMessage _$CreateMessageFromJson(Map<String, dynamic> json) =>
    CreateMessage(
      channelId: json['channel_id'] as String,
      content: json['content'] as String,
      contentType: json['content_type'] as String,
      referMessageId: json['refer_message_id'] as String?,
    );

Map<String, dynamic> _$CreateMessageToJson(CreateMessage instance) =>
    <String, dynamic>{
      'channel_id': instance.channelId,
      'content_type': instance.contentType,
      'content': instance.content,
      'refer_message_id': instance.referMessageId,
    };

UpdateMessage _$UpdateMessageFromJson(Map<String, dynamic> json) =>
    UpdateMessage(
      id: json['id'] as String,
      content: json['content'] as String,
      contentType: json['content_type'] as String,
    );

Map<String, dynamic> _$UpdateMessageToJson(UpdateMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content_type': instance.contentType,
      'content': instance.content,
    };

DeleteMessage _$DeleteMessageFromJson(Map<String, dynamic> json) =>
    DeleteMessage(
      id: json['id'] as String,
    );

Map<String, dynamic> _$DeleteMessageToJson(DeleteMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

ViewMessage _$ViewMessageFromJson(Map<String, dynamic> json) => ViewMessage(
      messageId: json['message_id'] as String,
      userId: json['user_id'] as String,
    );

Map<String, dynamic> _$ViewMessageToJson(ViewMessage instance) =>
    <String, dynamic>{
      'message_id': instance.messageId,
      'user_id': instance.userId,
    };

LikeMessage _$LikeMessageFromJson(Map<String, dynamic> json) => LikeMessage(
      messageId: json['message_id'] as String,
      amount: json['amount'] as int,
    );

Map<String, dynamic> _$LikeMessageToJson(LikeMessage instance) =>
    <String, dynamic>{
      'message_id': instance.messageId,
      'amount': instance.amount,
    };

TagMessage _$TagMessageFromJson(Map<String, dynamic> json) => TagMessage(
      messageId: json['message_id'] as String,
      tag: json['tag'] as String,
      untag: json['untag'] as bool? ?? false,
    );

Map<String, dynamic> _$TagMessageToJson(TagMessage instance) =>
    <String, dynamic>{
      'message_id': instance.messageId,
      'tag': instance.tag,
      'untag': instance.untag,
    };
