// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NamedThumbmail _$NamedThumbmailFromJson(Map<String, dynamic> json) =>
    NamedThumbmail(
      id: json['id'] as String,
      name: json['name'] as String?,
      nickname: json['nickname'] as String?,
      thumbnail: json['thumbnail'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$NamedThumbmailToJson(NamedThumbmail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'nickname': instance.nickname,
      'thumbnail': instance.thumbnail,
      'created_at': instance.createdAt?.toIso8601String(),
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      name: json['name'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      thumbnail: json['thumbnail'] as String?,
      nickname: json['nickname'] as String?,
      emailAddr: json['email_addr'] as String?,
      phoneNumber: json['phone_number'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'nickname': instance.nickname,
      'thumbnail': instance.thumbnail,
      'created_at': instance.createdAt?.toIso8601String(),
      'email_addr': instance.emailAddr,
      'phone_number': instance.phoneNumber,
      'name': instance.name,
    };
