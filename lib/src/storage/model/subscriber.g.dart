// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscriber.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Subscriber _$SubscriberFromJson(Map<String, dynamic> json) => Subscriber(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      channelId: json['channel_id'] as String,
      role: json['role'] as int? ?? SubscribeRole.roleAny,
      online: json['online'] as bool? ?? false,
      unreadMessages: json['unread_messages'] as int? ?? 0,
      lastReadMessageAt: json['last_read_message_at'] == null
          ? null
          : DateTime.parse(json['last_read_message_at'] as String),
      lastReadMessageId: json['last_read_message_id'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      nickname: json['nickname'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    )
      ..name = json['name'] as String?
      ..folder = json['folder'] as String?
      ..invitedBy = json['invited_by'] as String?;

Map<String, dynamic> _$SubscriberToJson(Subscriber instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'nickname': instance.nickname,
      'avatar_url': instance.avatarUrl,
      'created_at': instance.createdAt?.toIso8601String(),
      'user_id': instance.userId,
      'folder': instance.folder,
      'channel_id': instance.channelId,
      'invited_by': instance.invitedBy,
      'online': instance.online,
      'role': instance.role,
      'unread_messages': instance.unreadMessages,
      'last_read_message_id': instance.lastReadMessageId,
      'last_read_message_at': instance.lastReadMessageAt?.toIso8601String(),
    };
