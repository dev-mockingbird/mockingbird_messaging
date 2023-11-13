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

  bool one2one;
  String? name;
  String? description;
  String? parentId;
  String? parentType;
  String? folder;
  String? nickname;
  String? avatarUrl;
  int? sendMessageMaxRole;
  int? readMessageMaxRole;
  List<String>? subscribeUserIds;

  CreateChannel({
    required this.one2one,
    this.subscribeUserIds,
    this.name,
    this.description,
    this.parentId,
    this.parentType,
    this.folder,
    this.nickname,
    this.avatarUrl,
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
  String? nickname;
  String? avatarUrl;
  int? writeMaxRole;
  int? readMaxRole;

  UpdateChannel({
    required this.id,
    this.name,
    this.description,
    this.nickname,
    this.avatarUrl,
    this.writeMaxRole,
    this.readMaxRole,
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

@JsonSerializable(fieldRename: FieldRename.snake)
class UpdateChannelFolder extends Payload {
  static const String eventType = "channel.folder.update";
  List<String> channelIds;
  String folder;
  UpdateChannelFolder({required this.channelIds, required this.folder});
  @override
  Map<String, dynamic> toJson() => _$UpdateChannelFolderToJson(this);

  factory UpdateChannelFolder.fromJson(Map<String, dynamic> json) =>
      _$UpdateChannelFolderFromJson(json);
  @override
  String get type => eventType;
}
