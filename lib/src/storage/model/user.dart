// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class NamedAvatar {
  String id;
  String? name;
  String? nickname;
  String? avatarUrl;
  DateTime? createdAt;
  NamedAvatar({
    required this.id,
    this.name,
    this.nickname,
    this.avatarUrl,
    this.createdAt,
  });

  static List<String> get fields {
    return [
      "id TEXT PRIMARY KEY",
      "name TEXT",
      "nickname TEXT",
      "avatar_url TEXT",
      "created_at TEXT",
    ];
  }

  String get displayName {
    if (nickname != null && nickname != "") {
      return nickname!;
    } else if (name != null && nickname != "") {
      return name!;
    } else {
      return id;
    }
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class User extends NamedAvatar {
  String? emailAddr;
  String? phoneNumber;

  static String stableName = "users";

  static List<String> get fields {
    List<String> fields = NamedAvatar.fields;
    fields.addAll([
      "email_addr TEXT",
      "phone_number TEXT",
    ]);
    return fields;
  }

  User({
    required super.id,
    required super.name,
    super.createdAt,
    super.avatarUrl,
    super.nickname,
    this.emailAddr,
    this.phoneNumber,
  });

  @override
  String get name {
    return super.name ?? "";
  }

  // 反序列化
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  // 序列化
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
