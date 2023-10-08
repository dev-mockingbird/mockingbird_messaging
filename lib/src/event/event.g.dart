// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) => Event(
      type: json['type'] as String,
      payload: json['payload'] as Map<String, dynamic>?,
      id: json['id'] as String? ?? '',
    );

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'payload': instance.payload,
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
