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
    'prev_id TEXT',
    'type TEXT',
    'content TEXT',
    'creator_id TEXT',
    'creator_thumbnail TEXT',
    'creator_name TEXT',
    'creator_user_id TEXT',
    'read_count INTEGER',
    'updated_at TEXT',
    'created_at TEXT'
  ];
  String id;
  String channelId;
  String type;
  String? prevId;
  dynamic content;
  Subscriber creator;
  DateTime? createdAt;
  DateTime? updatedAt;
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
    data["creator_id"] = creator.id;
    data['creator_thumbnail'] = creator.thumbnail;
    data['creator_nickname'] = creator.nickname;
    data["creator_user_id"] = creator.userId;
    data["content"] = jsonEncode(content);
    return data;
  }

  // 序列化
  Map<String, dynamic> toJson() => _$MessageToJson(this);

  static List<Message> fromSqlite(List<Map<String, Object?>> list) {
    List<Message> ret = [];
    for (var item in list) {
      item['creator'] = {
        'id': item['creator_id'],
        'user_id': item['creator_user_id'],
        'thumbnail': item['creator_thumbnail'],
        'nickname': item['creator_nickname'],
      };
      item['content'] = jsonDecode(item['content'] as String);
      ret.add(Message.fromJson(item));
    }
    return ret;
  }
}
