// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:mockingbird_messaging/src/storage/model/subscriber.dart';
import 'package:mockingbird_messaging/src/storage/sqlite.dart';
part 'message.g.dart';

const typeText = "text";
const typeMedia = "media";
const typeFile = "file";
const typeCustom = "custom";
const typeInputing = "inputing";

@JsonSerializable(fieldRename: FieldRename.snake)
class Message extends SqliteModel {
  static const String stableName = "messages";
  static const List<String> fields = [
    'id TEXT PRIMARY KEY',
    'channel_id TEXT',
    'type TEXT',
    'prev_id TEXT',
    'content TEXT',
    'creator TEXT',
    'creator_id TEXT',
    'creator_user_id TEXT',
    'read_count INTEGER',
    'updated_at TEXT',
    'created_at TEXT'
  ];
  @JsonKey()
  String id;
  @JsonKey()
  String channelId;
  @JsonKey()
  String type;
  @JsonKey(disallowNullValue: false)
  String? prevId;
  @JsonKey()
  dynamic content;
  @JsonKey()
  Subscriber creator;
  @JsonKey()
  DateTime? createdAt;
  @JsonKey()
  DateTime? updatedAt;
  @JsonKey()
  int? readCount;
  Message({
    required this.id,
    required this.channelId,
    required this.type,
    required this.content,
    required this.creator,
    this.readCount,
    this.prevId,
    this.createdAt,
    this.updatedAt,
  });

  @override
  String tableName() {
    return "messages";
  }

  // 反序列化
  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  @override
  Map<String, dynamic> toSqliteMap() {
    var data = toJson();
    data["creator"] = jsonEncode(data["creator"]);
    data["creator_id"] = creator.id;
    data["creator_user_id"] = creator.user.id;
    data["content"] = jsonEncode(data["content"]);
    return data;
  }

  // 序列化
  Map<String, dynamic> toJson() => _$MessageToJson(this);

  static List<Message> fromSqlite(List<Map<String, Object?>> list) {
    List<Message> ret = [];
    for (var i in list) {
      Map<String, dynamic> data = {};
      i.forEach((key, value) {
        if (key == "creator" && value is String) {
          data["creator"] = jsonDecode(value);
        } else if (key == "content" && value is String) {
          data["content"] = jsonDecode(value);
        } else {
          data[key] = value;
        }
      });
      ret.add(Message.fromJson(data));
    }
    return ret;
  }
}
