// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Channel _$ChannelFromJson(Map<String, dynamic> json) => Channel(
      id: json['id'] as String,
      countryCode: json['country_code'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      readMaxRole: json['read_max_role'] as int,
      writeMaxRole: json['write_max_role'] as int,
      name: json['name'] as String,
      lastMessageText: json['last_message_text'] as String?,
      lastMessageMedia: (json['last_message_media'] as List<dynamic>?)
          ?.map((e) => MessageMedia.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastMessageAudio: (json['last_message_audio'] as List<dynamic>?)
          ?.map((e) => MessageAudio.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastMessageArticle: (json['last_message_article'] as List<dynamic>?)
          ?.map((e) => MessageArticle.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastMessageAttachment: (json['last_message_attachment'] as List<dynamic>?)
          ?.map((e) => MessageFile.fromJson(e as Map<String, dynamic>))
          .toList(),
      channelId: json['channel_id'] as String?,
      nickname: json['nickname'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      peerUserId: json['peer_user_id'] as String?,
      description: json['description'] as String?,
      messages: json['messages'] as int? ?? 0,
      subscribers: json['subscribers'] as int? ?? 0,
      lastMessageSubscriberId: json['last_message_subscriber_id'] as String?,
      lastMessageId: json['last_message_id'] as String?,
      lastMessageAt: json['last_message_at'] as String?,
      lastMessagePrevId: json['last_message_prev_id'] as String?,
    )
      ..creatorId = json['creator_id'] as String?
      ..updatedAt = json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String);

Map<String, dynamic> _$ChannelToJson(Channel instance) => <String, dynamic>{
      'id': instance.id,
      'country_code': instance.countryCode,
      'channel_id': instance.channelId,
      'name': instance.name,
      'nickname': instance.nickname,
      'avatar_url': instance.avatarUrl,
      'description': instance.description,
      'peer_user_id': instance.peerUserId,
      'write_max_role': instance.writeMaxRole,
      'read_max_role': instance.readMaxRole,
      'messages': instance.messages,
      'last_message_subscriber_id': instance.lastMessageSubscriberId,
      'last_message_id': instance.lastMessageId,
      'last_message_text': instance.lastMessageText,
      'last_message_media': instance.lastMessageMedia,
      'last_message_audio': instance.lastMessageAudio,
      'last_message_article': instance.lastMessageArticle,
      'last_message_attachment': instance.lastMessageAttachment,
      'last_message_at': instance.lastMessageAt,
      'last_message_prev_id': instance.lastMessagePrevId,
      'subscribers': instance.subscribers,
      'creator_id': instance.creatorId,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
