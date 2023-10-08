// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Channel _$ChannelFromJson(Map<String, dynamic> json) => Channel(
      id: json['id'] as String,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      readMaxRole: json['read_max_role'] as int,
      userId: json['user_id'] as String,
      writeMaxRole: json['write_max_role'] as int,
      name: json['name'] as String,
      role: json['role'] as int,
      unreadMessages: json['unread_messages'] as int,
      type: json['type'] as String,
      nickname: json['nickname'] as String?,
      thumbnail: json['thumbnail'] as String?,
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
      'nickname': instance.nickname,
      'user_id': instance.userId,
      'read_max_role': instance.readMaxRole,
      'write_max_role': instance.writeMaxRole,
      'type': instance.type,
      'thumbnail': instance.thumbnail,
      'folder': instance.folder,
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
      'last_event_id': instance.lastEventId,
    };
