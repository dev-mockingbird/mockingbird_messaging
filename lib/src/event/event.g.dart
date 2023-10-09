// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) => Event(
      type: json['type'] as String,
      metadata: (json['metadata'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      createTimestamp: json['create_timestamp'] as int? ?? 0,
      data: json['data'] as String?,
    );

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'type': instance.type,
      'metadata': instance.metadata,
      'data': instance.data,
      'create_timestamp': instance.createTimestamp,
    };

ModelChanged _$ModelChangedFromJson(Map<String, dynamic> json) => ModelChanged(
      model: json['model'] as String,
      changeType: json['change_type'] as String,
      ids: (json['ids'] as List<dynamic>?)?.map((e) => e as String).toList(),
      data: json['data'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$ModelChangedToJson(ModelChanged instance) =>
    <String, dynamic>{
      'model': instance.model,
      'change_type': instance.changeType,
      'ids': instance.ids,
      'data': instance.data,
    };
