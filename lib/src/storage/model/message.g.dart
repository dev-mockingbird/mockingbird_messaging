// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageFile _$MessageFileFromJson(Map<String, dynamic> json) => MessageFile(
      id: json['id'] as String,
      mimeType: json['mime_type'] as String,
      size: json['size'] as int,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$MessageFileToJson(MessageFile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'mime_type': instance.mimeType,
      'size': instance.size,
    };

MessageAudio _$MessageAudioFromJson(Map<String, dynamic> json) => MessageAudio(
      id: json['id'] as String,
      mimeType: json['mime_type'] as String,
      size: json['size'] as int,
      length: json['length'] as int,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$MessageAudioToJson(MessageAudio instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'mime_type': instance.mimeType,
      'size': instance.size,
      'length': instance.length,
    };

MessageMedia _$MessageMediaFromJson(Map<String, dynamic> json) => MessageMedia(
      id: json['id'] as String,
      mimeType: json['mime_type'] as String,
      size: json['size'] as int,
      name: json['name'] as String?,
      width: json['width'] as int?,
      height: json['height'] as int?,
    );

Map<String, dynamic> _$MessageMediaToJson(MessageMedia instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'mime_type': instance.mimeType,
      'size': instance.size,
      'width': instance.width,
      'height': instance.height,
    };

MessageArticle _$MessageArticleFromJson(Map<String, dynamic> json) =>
    MessageArticle(
      title: json['title'] as String,
      content: json['content'] as String,
    );

Map<String, dynamic> _$MessageArticleToJson(MessageArticle instance) =>
    <String, dynamic>{
      'title': instance.title,
      'content': instance.content,
    };

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      id: json['id'] as String,
      channelId: json['channel_id'] as String,
      creatorId: json['creator_id'] as String,
      text: json['text'] as String?,
      media: (json['media'] as List<dynamic>?)
          ?.map((e) => MessageMedia.fromJson(e as Map<String, dynamic>))
          .toList(),
      audio: json['audio'] == null
          ? null
          : MessageAudio.fromJson(json['audio'] as Map<String, dynamic>),
      attachment: (json['attachment'] as List<dynamic>?)
          ?.map((e) => MessageFile.fromJson(e as Map<String, dynamic>))
          .toList(),
      article: json['article'] == null
          ? null
          : MessageArticle.fromJson(json['article'] as Map<String, dynamic>),
      referMessageId: json['refer_message_id'] as String?,
      prevId: json['prev_id'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'id': instance.id,
      'channel_id': instance.channelId,
      'prev_id': instance.prevId,
      'text': instance.text,
      'media': instance.media,
      'attachment': instance.attachment,
      'audio': instance.audio,
      'article': instance.article,
      'creator_id': instance.creatorId,
      'refer_message_id': instance.referMessageId,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
