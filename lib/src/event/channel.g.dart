// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateChannel _$CreateChannelFromJson(Map<String, dynamic> json) =>
    CreateChannel(
      subUserIds: (json['sub_user_ids'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      name: json['name'] as String?,
      description: json['description'] as String?,
      folder: json['folder'] as String?,
      nickname: json['nickname'] as String?,
      thumbnail: json['thumbnail'] as String?,
      readMessageMaxRole: json['read_message_max_role'] as int?,
      sendMessageMaxRole: json['send_message_max_role'] as int?,
    );

Map<String, dynamic> _$CreateChannelToJson(CreateChannel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'folder': instance.folder,
      'nickname': instance.nickname,
      'thumbnail': instance.thumbnail,
      'send_message_max_role': instance.sendMessageMaxRole,
      'read_message_max_role': instance.readMessageMaxRole,
      'sub_user_ids': instance.subUserIds,
    };

UpdateChannel _$UpdateChannelFromJson(Map<String, dynamic> json) =>
    UpdateChannel(
      id: json['id'] as String,
      one2one: json['one2one'] as bool,
      name: json['name'] as String?,
      description: json['description'] as String?,
      folder: json['folder'] as String?,
      nickname: json['nickname'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      writeMaxRole: json['write_max_role'] as int?,
      readMaxRole: json['read_max_role'] as int?,
    );

Map<String, dynamic> _$UpdateChannelToJson(UpdateChannel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'one2one': instance.one2one,
      'description': instance.description,
      'folder': instance.folder,
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
