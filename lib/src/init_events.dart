// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'package:json_annotation/json_annotation.dart';
import 'event/event.dart';
part 'init_events.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SyncModelRequest extends Payload {
  static const String eventType = 'model.sync.request';
  String model;
  String lastUpdatedAt;
  String userId;

  SyncModelRequest({
    required this.model,
    required this.userId,
    required this.lastUpdatedAt,
  });

  @override
  Map<String, dynamic> toJson() => _$SyncModelRequestToJson(this);

  @override
  String get type => eventType;
}

@JsonSerializable(fieldRename: FieldRename.snake)
class SyncModelDone extends Payload {
  static const String eventType = 'model.sync.done';
  String model;

  SyncModelDone({
    required this.model,
  });

  @override
  Map<String, dynamic> toJson() => _$SyncModelDoneToJson(this);

  factory SyncModelDone.fromJson(Map<String, dynamic> json) =>
      _$SyncModelDoneFromJson(json);
  @override
  String get type => eventType;
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ConfigInfo extends Payload {
  static const String eventType = 'config-info';
  String lang;
  String clientId;
  DateTime time;
  ConfigInfo({
    required this.lang,
    required this.clientId,
    required this.time,
  });

  factory ConfigInfo.fromJson(Map<String, dynamic> json) =>
      _$ConfigInfoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ConfigInfoToJson(this);

  @override
  String get type => eventType;
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ChangeLang extends Payload {
  static const String eventType = 'change-lang';
  String lang;
  ChangeLang({
    required this.lang,
  });

  factory ChangeLang.fromJson(Map<String, dynamic> json) =>
      _$ChangeLangFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ChangeLangToJson(this);

  @override
  String get type => eventType;
}
