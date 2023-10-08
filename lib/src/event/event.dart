// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'package:json_annotation/json_annotation.dart';
part 'event.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Event {
  String id;
  String type;
  Map<String, dynamic>? payload;
  Event({
    required this.type,
    this.payload,
    this.id = '',
  }) {
    if (id == '') {
      id = generateId();
    }
  }

  String generateId() {
    return '';
  }

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

  Map<String, dynamic> toJson() => _$EventToJson(this);
}

abstract class EventHandler {
  handle(Event event);
}

abstract class Payload {
  String get type;
  Map<String, dynamic> toJson();
}

Event buildEvent(Payload payload) {
  return Event(type: payload.type, payload: payload.toJson());
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ModelChanged extends Payload {
  static const eventType = "model.changed";
  static const String deleted = 'model.deleted';
  static const String updated = 'model.updated';
  static const String created = 'model.created';

  @override
  String get type {
    return eventType;
  }

  String model;
  String changeType;
  List<String>? ids;
  Map<String, dynamic>? data;

  ModelChanged({
    required this.model,
    required this.changeType,
    this.ids,
    this.data,
  });

  factory ModelChanged.fromJson(Map<String, dynamic> json) =>
      _$ModelChangedFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ModelChangedToJson(this);
}
