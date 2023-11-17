// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
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
    'prev_id TEXT',
    'refer_message_id TEXT',
    'type TEXT',
    'content TEXT',
    'creator_id TEXT',
    'read_count INTEGER',
    'updated_at TEXT',
    'created_at TEXT'
  ];

  String id;
  String channelId;
  String type;
  String? prevId;
  dynamic content;
  String creatorId;
  DateTime? createdAt;
  DateTime? updatedAt;
  Message({
    required this.id,
    required this.channelId,
    required this.type,
    required this.content,
    required this.creatorId,
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
    data["content"] = jsonEncode(content);
    return data;
  }

  static List<Message> fromSqlite(List<Map<String, dynamic>> data) {
    List<Message> ret = [];
    for (var item in data) {
      ret.add(Message.fromJson(item));
    }
    return ret;
  }

  // 序列化
  Map<String, dynamic> toJson() => _$MessageToJson(this);
}
