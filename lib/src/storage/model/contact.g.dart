// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Contact _$ContactFromJson(Map<String, dynamic> json) => Contact(
      id: json['id'] as String,
      ownerUserId: json['owner_user_id'] as String,
      avatarUrl: json['avatar_url'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      nickname: json['nickname'] as String?,
      note: json['note'] as String?,
    )..name = json['name'] as String?;

Map<String, dynamic> _$ContactToJson(Contact instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'nickname': instance.nickname,
      'avatar_url': instance.avatarUrl,
      'created_at': instance.createdAt?.toIso8601String(),
      'note': instance.note,
      'owner_user_id': instance.ownerUserId,
    };
