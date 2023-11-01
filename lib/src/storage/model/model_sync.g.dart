// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_sync.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModelSync _$ModelSyncFromJson(Map<String, dynamic> json) => ModelSync(
      model: json['model'] as String,
      lastUpdatedAt: json['last_updated_at'] as String,
      userId: json['user_id'] as String,
    );

Map<String, dynamic> _$ModelSyncToJson(ModelSync instance) => <String, dynamic>{
      'model': instance.model,
      'last_updated_at': instance.lastUpdatedAt,
      'user_id': instance.userId,
    };
