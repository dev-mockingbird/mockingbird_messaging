// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'package:json_annotation/json_annotation.dart';
import 'event.dart';
part 'channel.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CreateChannel extends Payload {
  static const String eventType = 'channel.create';
  @override
  String get type {
    return eventType;
  }

  int channelType;
  String? name;
  String? description;
  String? folder;
  String? nickname;
  String? thumbnail;
  int? sendMessageMaxRole;
  int? readMessageMaxRole;
  List<String> subUserIds;

  CreateChannel({
    required this.subUserIds,
    required this.channelType,
    this.name,
    this.description,
    this.folder,
    this.nickname,
    this.thumbnail,
    this.readMessageMaxRole,
    this.sendMessageMaxRole,
  });

  factory CreateChannel.fromJson(Map<String, dynamic> json) =>
      _$CreateChannelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CreateChannelToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class UpdateChannel extends Payload {
  static const String eventType = 'channel.update';
  @override
  String get type {
    return eventType;
  }

  String id;
  String? name;
  String? description;
  String? folder;
  String? nickname;
  String? thumbnail;
  int? sendMessageMaxRole;
  int? readMessageMaxRole;

  UpdateChannel({
    required this.id,
    this.name,
    this.description,
    this.folder,
    this.nickname,
    this.thumbnail,
    this.readMessageMaxRole,
    this.sendMessageMaxRole,
  });

  factory UpdateChannel.fromJson(Map<String, dynamic> json) =>
      _$UpdateChannelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UpdateChannelToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class DeleteChannel extends Payload {
  static const String eventType = 'channel.delete';
  @override
  String get type {
    return eventType;
  }

  String id;
  DeleteChannel({
    required this.id,
  });

  factory DeleteChannel.fromJson(Map<String, dynamic> json) =>
      _$DeleteChannelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DeleteChannelToJson(this);
}
