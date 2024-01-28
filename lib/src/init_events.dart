// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'package:json_annotation/json_annotation.dart';
import 'event/event.dart';
part 'init_events.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SyncModel extends Payload {
  static String eventType = "model.sync";
  List<dynamic> actions;
  SyncModel({required this.actions});

  @override
  String get type => eventType;

  @override
  Map<String, dynamic> toJson() => _$SyncModelToJson(this);

  factory SyncModel.fromJson(Map<String, dynamic> json) =>
      _$SyncModelFromJson(json);
}

abstract class SyncModelRequest extends Payload {
  String lastUpdatedAt;
  List<String>? ids;

  SyncModelRequest({
    required this.lastUpdatedAt,
    this.ids,
  });
}

abstract class SyncModelWithChannel extends Payload {
  String lastUpdatedAt;
  String channelId;
  SyncModelWithChannel({
    required this.lastUpdatedAt,
    required this.channelId,
  });
}

@JsonSerializable(fieldRename: FieldRename.snake)
class SyncModelChannel extends SyncModelRequest {
  static String eventType = "model.sync.channel";

  SyncModelChannel({
    required super.lastUpdatedAt,
    super.ids,
  });

  @override
  String get type => eventType;

  @override
  Map<String, dynamic> toJson() => _$SyncModelChannelToJson(this);

  factory SyncModelChannel.fromJson(Map<String, dynamic> json) =>
      _$SyncModelChannelFromJson(json);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class SyncModelContact extends SyncModelRequest {
  static String eventType = "model.sync.contact";

  SyncModelContact({
    required super.lastUpdatedAt,
    super.ids,
  });

  @override
  String get type => eventType;

  @override
  Map<String, dynamic> toJson() => _$SyncModelContactToJson(this);

  factory SyncModelContact.fromJson(Map<String, dynamic> json) =>
      _$SyncModelContactFromJson(json);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class SyncModelMessage extends SyncModelWithChannel {
  static String eventType = "model.sync.message";

  SyncModelMessage({
    required super.lastUpdatedAt,
    required super.channelId,
  });

  @override
  String get type => eventType;

  @override
  Map<String, dynamic> toJson() => _$SyncModelMessageToJson(this);

  factory SyncModelMessage.fromJson(Map<String, dynamic> json) =>
      _$SyncModelMessageFromJson(json);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class SyncModelMessageLike extends SyncModelWithChannel {
  static String eventType = "model.sync.message.like";

  SyncModelMessageLike({
    required super.lastUpdatedAt,
    required super.channelId,
  });

  @override
  String get type => eventType;

  @override
  Map<String, dynamic> toJson() => _$SyncModelMessageLikeToJson(this);

  factory SyncModelMessageLike.fromJson(Map<String, dynamic> json) =>
      _$SyncModelMessageLikeFromJson(json);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class SyncModelMessageTag extends SyncModelWithChannel {
  static String eventType = "model.sync.message.tag";

  SyncModelMessageTag({
    required super.lastUpdatedAt,
    required super.channelId,
  });

  @override
  String get type => eventType;

  @override
  Map<String, dynamic> toJson() => _$SyncModelMessageTagToJson(this);

  factory SyncModelMessageTag.fromJson(Map<String, dynamic> json) =>
      _$SyncModelMessageTagFromJson(json);
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
