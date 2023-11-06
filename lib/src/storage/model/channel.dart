// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'package:json_annotation/json_annotation.dart';
import 'package:mockingbird_messaging/src/storage/sqlite.dart';
part 'channel.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Channel extends SqliteModel {
  static const String stableName = "channels";
  String id;
  String name;
  String? nickname;
  String? avatarUrl;
  String? description;
  String? peerUserId;
  int writeMaxRole;
  int readMaxRole;
  int messages;
  String? lastMessageSubscriberId;
  String? lastMessageId;
  String? lastMessageType;
  String? lastMessage;
  String? lastMessageAt;
  String? lastMessagePrevId;
  int? subscribers;
  String? creatorId;
  DateTime createdAt;
  DateTime? updatedAt;

  static const List<String> fields = [
    "id TEXT PRIMARY KEY",
    "parent_id TEXT",
    "parent_type TEXT",
    "name TEXT",
    "nickname TEXT",
    "avatar_url TEXT",
    "description TEXT",
    "write_max_role INTEGER",
    "read_max_role INTEGER",
    "peer_user_id TEXT",
    "messages INTEGER",
    "last_message_subscriber_id TEXT",
    "last_message_id TEXT",
    "last_message_type TEXT",
    "last_message TEXT",
    "last_message_at TEXT",
    "last_message_prev_id TEXT",
    "subscribers INTEGER",
    "creator_id TEXT",
    "created_at TEXT",
    "updated_at TEXT"
  ];

  @override
  String tableName() {
    return "channels";
  }

  Channel({
    required this.id,
    required this.createdAt,
    required this.readMaxRole,
    required this.writeMaxRole,
    required this.name,
    this.nickname,
    this.avatarUrl,
    this.peerUserId,
    this.lastMessage,
    this.description,
    this.messages = 0,
    this.subscribers = 0,
    this.lastMessageSubscriberId,
    this.lastMessageId,
    this.lastMessageType,
    this.lastMessageAt,
    this.lastMessagePrevId,
  });

  static List<Channel> fromSqlite(List<Map<String, dynamic>> data) {
    List<Channel> ret = [];
    for (var item in data) {
      ret.add(Channel.fromJson(item));
    }
    return ret;
  }

  @override
  Map<String, dynamic> toSqliteMap() {
    return toJson();
  }

  // 反序列化
  factory Channel.fromJson(Map<String, dynamic> json) =>
      _$ChannelFromJson(json);
  // 序列化
  Map<String, dynamic> toJson() => _$ChannelToJson(this);
}
