// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateChannel _$CreateChannelFromJson(Map<String, dynamic> json) =>
    CreateChannel(
      one2one: json['one2one'] as bool,
      subscribeUserIds: (json['subscribe_user_ids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      name: json['name'] as String?,
      description: json['description'] as String?,
      parentId: json['parent_id'] as String?,
      parentType: json['parent_type'] as String?,
      folder: json['folder'] as String?,
      nickname: json['nickname'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      readMessageMaxRole: json['read_message_max_role'] as int?,
      sendMessageMaxRole: json['send_message_max_role'] as int?,
    );

Map<String, dynamic> _$CreateChannelToJson(CreateChannel instance) =>
    <String, dynamic>{
      'one2one': instance.one2one,
      'name': instance.name,
      'description': instance.description,
      'parent_id': instance.parentId,
      'parent_type': instance.parentType,
      'folder': instance.folder,
      'nickname': instance.nickname,
      'avatar_url': instance.avatarUrl,
      'send_message_max_role': instance.sendMessageMaxRole,
      'read_message_max_role': instance.readMessageMaxRole,
      'subscribe_user_ids': instance.subscribeUserIds,
    };

UpdateChannel _$UpdateChannelFromJson(Map<String, dynamic> json) =>
    UpdateChannel(
      id: json['id'] as String,
      name: json['name'] as String?,
      description: json['description'] as String?,
      nickname: json['nickname'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      writeMaxRole: json['write_max_role'] as int?,
      readMaxRole: json['read_max_role'] as int?,
    );

Map<String, dynamic> _$UpdateChannelToJson(UpdateChannel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'nickname': instance.nickname,
      'avatar_url': instance.avatarUrl,
      'write_max_role': instance.writeMaxRole,
      'read_max_role': instance.readMaxRole,
    };

DeleteChannel _$DeleteChannelFromJson(Map<String, dynamic> json) =>
    DeleteChannel(
      id: json['id'] as String,
    );

Map<String, dynamic> _$DeleteChannelToJson(DeleteChannel instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

UpdateChannelFolder _$UpdateChannelFolderFromJson(Map<String, dynamic> json) =>
    UpdateChannelFolder(
      channelIds: (json['channel_ids'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      folder: json['folder'] as String,
    );

Map<String, dynamic> _$UpdateChannelFolderToJson(
        UpdateChannelFolder instance) =>
    <String, dynamic>{
      'channel_ids': instance.channelIds,
      'folder': instance.folder,
    };
