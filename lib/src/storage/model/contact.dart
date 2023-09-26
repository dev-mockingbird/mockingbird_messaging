// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'package:json_annotation/json_annotation.dart';
import 'package:mockingbird_messaging/src/storage/model/user.dart';
import 'package:mockingbird_messaging/src/storage/sqlite.dart';
part 'contact.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Contact extends NamedThumbmail implements SqliteModel {
  static String stableName = 'contacts';

  @JsonKey(disallowNullValue: false)
  String? note;
  @JsonKey()
  User user;
  @JsonKey()
  String ownerUserId;
  Contact({
    required super.id,
    required this.user,
    required this.ownerUserId,
    super.thumbnail,
    super.createdAt,
    super.nickname,
    this.note,
  });

  @override
  String get displayName {
    if (super.displayName != "") {
      return super.displayName;
    }
    return user.displayName;
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
    var data = {
      'id': id,
      'owner_user_id': ownerUserId,
      'contact_nickname': nickname,
      'contact_thumbnail': thumbnail,
      'contact_note': note,
      'user_id': user.id,
      'user_name': user.name,
      'user_nickname': user.nickname,
      'user_thumbnail': user.thumbnail,
      'user_email_addr': user.emailAddr,
      'user_created_at': user.createdAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
    };
    return data;
  }

  static List<Contact> fromSqlite(List<Map<String, Object?>> list) {
    List<Contact> ret = [];
    for (var data in list) {
      ret.add(Contact(
          id: data['id'] as String,
          note: data['contact_note'] as String?,
          ownerUserId: data['ownerUserId'] as String,
          nickname: data['contact_nickname'] as String?,
          thumbnail: data['contact_thumbnail'] as String?,
          createdAt: data['contact_created_at'] == null
              ? null
              : DateTime.parse(data['contact_created_at'] as String),
          user: User(
              id: data['user_id'] as String,
              name: data['user_name'] as String,
              // avatarUrl: data['user_avatar_url'] as String?,
              emailAddr: data['user_email_addr'] as String?,
              // nickname: data['user_nickname'] as String?,
              // phoneNumber: data['user_phone_number'] as String?,
              // emailAddrVerified:
              // (data['email_addr_verified'] as int) == 1 ? true : false,
              // phoneNumberVerified:
              // (data['phone_number_verified'] as int) == 1 ? true : false,
              createdAt: data['user_created_at'] == null
                  ? null
                  : DateTime.parse(data['user_created_at'] as String))));
    }
    return ret;
  }

  // 反序列化
  factory Contact.fromJson(Map<String, dynamic> json) =>
      _$ContactFromJson(json);
  // 序列化
  Map<String, dynamic> toJson() => _$ContactToJson(this);
}
