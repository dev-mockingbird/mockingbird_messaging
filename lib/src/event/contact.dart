// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'package:json_annotation/json_annotation.dart';
import 'package:mockingbird_messaging/src/event/event.dart';
part 'contact.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CreateContact extends Payload {
  static const String eventType = "channel.message.create";
  @override
  String get type => eventType;

  String userId;
  String? note;
  String? nickname;
  String? avatarUrl;

  CreateContact({
    required this.userId,
    this.note,
    this.nickname,
    this.avatarUrl,
  });

  factory CreateContact.fromJson(Map<String, dynamic> json) =>
      _$CreateContactFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CreateContactToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class UpdateContact extends Payload {
  static const String eventType = "channel.message.update";
  @override
  String get type => eventType;

  String id;
  String? note;
  String? nickname;
  String? avatarUrl;

  UpdateContact({
    required this.id,
    this.note,
    this.nickname,
    this.avatarUrl,
  });

  factory UpdateContact.fromJson(Map<String, dynamic> json) =>
      _$UpdateContactFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UpdateContactToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class DeleteContact extends Payload {
  static const String eventType = "channel.message.delete";
  @override
  String get type => eventType;

  String id;

  DeleteContact({
    required this.id,
  });

  factory DeleteContact.fromJson(Map<String, dynamic> json) =>
      _$DeleteContactFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DeleteContactToJson(this);
}
