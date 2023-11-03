// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateContact _$CreateContactFromJson(Map<String, dynamic> json) =>
    CreateContact(
      userId: json['user_id'] as String,
      note: json['note'] as String?,
      nickname: json['nickname'] as String?,
      avatarUrl: json['avatar_url'] as String?,
    );

Map<String, dynamic> _$CreateContactToJson(CreateContact instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'note': instance.note,
      'nickname': instance.nickname,
      'avatar_url': instance.avatarUrl,
    };

UpdateContact _$UpdateContactFromJson(Map<String, dynamic> json) =>
    UpdateContact(
      id: json['id'] as String,
      note: json['note'] as String?,
      nickname: json['nickname'] as String?,
      avatarUrl: json['avatar_url'] as String?,
    );

Map<String, dynamic> _$UpdateContactToJson(UpdateContact instance) =>
    <String, dynamic>{
      'id': instance.id,
      'note': instance.note,
      'nickname': instance.nickname,
      'avatar_url': instance.avatarUrl,
    };

DeleteContact _$DeleteContactFromJson(Map<String, dynamic> json) =>
    DeleteContact(
      id: json['id'] as String,
    );

Map<String, dynamic> _$DeleteContactToJson(DeleteContact instance) =>
    <String, dynamic>{
      'id': instance.id,
    };
