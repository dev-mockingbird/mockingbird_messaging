// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
part 'event.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Event {
  String type;
  Map<String, String>? metadata;
  @JsonKey(includeFromJson: false, includeToJson: false)
  Map<String, dynamic>? payload;
  String? data;
  int createTimestamp;
  Event({
    required this.type,
    this.metadata,
    this.createTimestamp = 0,
    this.payload,
    this.data,
  }) {
    if (createTimestamp == 0) {
      createTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    }
  }

  packPayload() {
    metadata = metadata ?? {};
    metadata!['encoding'] = "json";
    data = base64Encode(utf8.encode(jsonEncode(payload)));
  }

  unpackPayload() {
    if (data == null) {
      return;
    }
    var encoding = metadata?['encoding'] ?? 'json';
    switch (encoding) {
      case 'json':
        payload = jsonDecode(
            String.fromCharCodes(base64Decode(utf8.decode(data!.codeUnits))));
      default:
        throw Exception("unexpected encoding $encoding");
    }
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
class ModelAction {
  static const String deleted = 'deleted';
  static const String updated = 'updated';
  static const String created = 'created';

  String action;
  int offset;
  List<String>? recordIds;
  Map<String, dynamic>? data;

  ModelAction({
    required this.action,
    required this.offset,
    this.recordIds,
    this.data,
  });

  factory ModelAction.fromJson(Map<String, dynamic> json) =>
      _$ModelActionFromJson(json);

  Map<String, dynamic> toJson() => _$ModelActionToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ModelChanged extends Payload {
  static const eventType = "model.sync";

  String model;

  List<ModelAction> actions;

  ModelChanged({required this.model, required this.actions});

  @override
  String get type {
    return eventType;
  }

  factory ModelChanged.fromJson(Map<String, dynamic> json) =>
      _$ModelChangedFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ModelChangedToJson(this);
}
