// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscriber.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Subscriber _$SubscriberFromJson(Map<String, dynamic> json) => Subscriber(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      role: json['role'] as int?,
      thumbnail: json['thumbnail'] as String?,
      nickname: json['nickname'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    )..name = json['name'] as String?;

Map<String, dynamic> _$SubscriberToJson(Subscriber instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'nickname': instance.nickname,
      'thumbnail': instance.thumbnail,
      'created_at': instance.createdAt?.toIso8601String(),
      'user_id': instance.userId,
      'role': instance.role,
    };
