// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class NamedThumbmail {
  String id;
  String? name;
  String? nickname;
  String? thumbnail;
  DateTime? createdAt;
  NamedThumbmail({
    required this.id,
    this.name,
    this.nickname,
    this.thumbnail,
    this.createdAt,
  });

  String get displayName {
    if (nickname != null) {
      return nickname!;
    } else if (name != null) {
      return name!;
    } else {
      return id;
    }
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class User extends NamedThumbmail {
  String? emailAddr;
  String? phoneNumber;

  User({
    required super.id,
    required super.name,
    super.createdAt,
    super.thumbnail,
    super.nickname,
    this.emailAddr,
    this.phoneNumber,
  });

  @override
  String get name {
    return name!;
  }

  // 反序列化
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  // 序列化
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class UserId {
  @JsonKey()
  String id;
  UserId({required this.id});
  // 反序列化
  factory UserId.fromJson(Map<String, dynamic> json) => _$UserIdFromJson(json);
  // 序列化
  Map<String, dynamic> toJson() => _$UserIdToJson(this);
}
