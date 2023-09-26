// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Channel _$ChannelFromJson(Map<String, dynamic> json) => Channel(
      id: json['id'] as String,
      category: json['category'] as String,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      readMaxRole: json['read_max_role'] as int,
      userId: json['user_id'] as String,
      writeMaxRole: json['write_max_role'] as int,
      name: json['name'] as String,
      role: json['role'] as int,
      unreadMessages: json['unread_messages'] as int,
      avatarUrl: json['avatar_url'] as String?,
      peerUserId: json['peer_user_id'] as String?,
      lastMessage: json['last_message'] == null
          ? null
          : Message.fromJson(json['last_message'] as Map<String, dynamic>),
      folder: json['folder'] as String?,
      description: json['description'] as String?,
      messages: json['messages'] as int? ?? 0,
      subscribers: json['subscribers'] as int? ?? 0,
      lastReadMessageAt: json['last_read_message_at'] == null
          ? null
          : DateTime.parse(json['last_read_message_at'] as String),
      lastReadMessageId: json['last_read_message_id'] as String?,
      lastEventId: json['last_event_id'] as String?,
    );

Map<String, dynamic> _$ChannelToJson(Channel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'user_id': instance.userId,
      'avatar_url': instance.avatarUrl,
      'folder': instance.folder,
      'category': instance.category,
      'peer_user_id': instance.peerUserId,
      'last_read_message_id': instance.lastReadMessageId,
      'last_read_message_at': instance.lastReadMessageAt?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'last_message': instance.lastMessage,
      'description': instance.description,
      'unread_messages': instance.unreadMessages,
      'role': instance.role,
      'messages': instance.messages,
      'subscribers': instance.subscribers,
      'read_max_role': instance.readMaxRole,
      'write_max_role': instance.writeMaxRole,
      'last_event_id': instance.lastEventId,
    };
