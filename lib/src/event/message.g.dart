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
    );

Map<String, dynamic> _$CreateMessageToJson(CreateMessage instance) =>
    <String, dynamic>{
      'channel_id': instance.channelId,
      'content_type': instance.contentType,
      'content': instance.content,
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
