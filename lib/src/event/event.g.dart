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

ModelAction _$ModelActionFromJson(Map<String, dynamic> json) => ModelAction(
      action: json['action'] as String,
      offset: json['offset'] as int,
      recordIds: (json['record_ids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      data: json['data'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$ModelActionToJson(ModelAction instance) =>
    <String, dynamic>{
      'action': instance.action,
      'offset': instance.offset,
      'record_ids': instance.recordIds,
      'data': instance.data,
    };

ModelChanged _$ModelChangedFromJson(Map<String, dynamic> json) => ModelChanged(
      model: json['model'] as String,
      actions: (json['actions'] as List<dynamic>)
          .map((e) => ModelAction.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ModelChangedToJson(ModelChanged instance) =>
    <String, dynamic>{
      'model': instance.model,
      'actions': instance.actions,
    };
