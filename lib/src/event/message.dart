// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'package:json_annotation/json_annotation.dart';
import 'event.dart';
part 'message.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CreateMessage extends Payload {
  static const String eventType = "message.create";
  @override
  String get type => eventType;

  String channelId;
  String contentType;
  String content;

  CreateMessage({
    required this.channelId,
    required this.content,
    required this.contentType,
  });

  factory CreateMessage.fromJson(Map<String, dynamic> json) =>
      _$CreateMessageFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CreateMessageToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class UpdateMessage extends Payload {
  static const String eventType = "message.update";
  @override
  String get type => eventType;

  String id;
  String contentType;
  String content;

  UpdateMessage({
    required this.id,
    required this.content,
    required this.contentType,
  });

  factory UpdateMessage.fromJson(Map<String, dynamic> json) =>
      _$UpdateMessageFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UpdateMessageToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class DeleteMessage extends Payload {
  static const String eventType = "message.delete";
  @override
  String get type => eventType;

  String id;

  DeleteMessage({
    required this.id,
  });

  factory DeleteMessage.fromJson(Map<String, dynamic> json) =>
      _$DeleteMessageFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DeleteMessageToJson(this);
}
