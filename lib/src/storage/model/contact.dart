// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'package:json_annotation/json_annotation.dart';
import 'package:mockingbird_messaging/src/storage/model/user.dart';
import 'package:mockingbird_messaging/src/storage/sqlite.dart';
part 'contact.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Contact extends NamedAvatar implements SqliteModel {
  static String stableName = 'contacts';

  @JsonKey(disallowNullValue: false)
  String? note;
  String ownerUserId;
  Contact({
    required super.id,
    required this.ownerUserId,
    super.avatarUrl,
    super.createdAt,
    super.nickname,
    this.note,
  });

  static List<String> get fields {
    List<String> fields = NamedAvatar.fields;
    fields.addAll([
      "client_user_id TEXT",
      "over_user_id TEXT",
      "updated_at TEXT",
      "note TEXT",
    ]);
    return fields;
  }

  @override
  String get idKey {
    return "id";
  }

  @override
  String tableName() {
    return 'contacts';
  }

  @override
  Map<String, dynamic> toSqliteMap() {
    return toJson();
  }

  static List<Contact> fromSqlite(List<Map<String, Object?>> list) {
    List<Contact> ret = [];
    for (var data in list) {
      ret.add(Contact.fromJson(data));
    }
    return ret;
  }

  // 反序列化
  factory Contact.fromJson(Map<String, dynamic> json) =>
      _$ContactFromJson(json);
  // 序列化
  Map<String, dynamic> toJson() => _$ContactToJson(this);
}
