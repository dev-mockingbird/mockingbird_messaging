// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'package:json_annotation/json_annotation.dart';
import 'package:mockingbird_messaging/src/storage/sqlite.dart';
part 'message_tag.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class MessageTag extends SqliteModel {
  static const String stableName = "message_tags";
  static const List<String> fields = [
    'id TEXT PRIMARY KEY',
    "client_user_id TEXT",
    'channel_id TEXT',
    'message_id TEXT',
    'creator_user_id TEXT',
    'tag TEXT',
    'updated_at TEXT',
    'created_at TEXT'
  ];

  String id;
  String channelId;
  String messageId;
  String creatorUserId;
  String tag;
  DateTime? createdAt;
  DateTime? updatedAt;
  MessageTag({
    required this.id,
    required this.channelId,
    required this.messageId,
    required this.creatorUserId,
    required this.tag,
    this.createdAt,
    this.updatedAt,
  });

  @override
  String tableName() {
    return stableName;
  }

  // 反序列化
  factory MessageTag.fromJson(Map<String, dynamic> json) =>
      _$MessageTagFromJson(json);

  Map<String, dynamic> toJson() => _$MessageTagToJson(this);

  @override
  Map<String, dynamic> toSqliteMap() {
    return toJson();
  }
}
