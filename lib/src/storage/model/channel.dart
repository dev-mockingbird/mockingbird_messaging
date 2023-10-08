// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:mockingbird_messaging/src/storage/model/message.dart';
import 'package:mockingbird_messaging/src/storage/sqlite.dart';
part 'channel.g.dart';

class ChannelType {
  static const peer = 0;
  static const group = 1;
  static const channel = 2;
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Channel extends SqliteModel {
  static const String stableName = "channels";
  static const List<String> fields = [
    'id TEXT',
    'name TEXT',
    'nickname TEXT',
    'description TEXT',
    'user_id TEXT',
    'thumbnail TEXT',
    'folder TEXT',
    'type TEXT',
    'role INTEGER',
    'messages INTEGER',
    'subscribers INTEGER',
    'unread_messages INTEGER',
    'peer_user_id TEXT',
    'read_max_role INTEGER',
    'write_max_role INTEGER',
    'current_seen_message_id TEXT',
    'last_read_message_id TEXT',
    'last_read_message_at TEXT',
    'last_message_created_at TEXT',
    'last_message TEXT',
    'created_at TEXT',
    'PRIMARY KEY (id)'
  ];
  String id;
  String name;
  String? nickname;
  String userId;
  int readMaxRole;
  int writeMaxRole;
  String type;
  String? thumbnail;
  String? folder;
  String? peerUserId;
  String? lastReadMessageId;
  DateTime? lastReadMessageAt;
  DateTime? createdAt;
  Message? lastMessage;
  String? description;
  int unreadMessages;
  int role;
  int messages;
  int subscribers;
  @JsonKey(disallowNullValue: false)
  String? lastEventId;

  factory Channel.fromJson(Map<String, dynamic> json) =>
      _$ChannelFromJson(json);

  Map<String, dynamic> toJson() => _$ChannelToJson(this);

  @override
  String tableName() {
    return "channels";
  }

  static List<Channel> fromSqlite(List<Map<String, Object?>> list) {
    List<Channel> ret = [];
    for (var i = 0; i < list.length; i++) {
      Map<String, dynamic> data = {};
      list[i].forEach((key, value) {
        if (key == "last_message" && value is String) {
          data[key] = jsonDecode(value);
          return;
        }
        data[key] = value;
      });
      ret.add(Channel.fromJson(data));
    }
    return ret;
  }

  @override
  Map<String, dynamic> toSqliteMap() {
    var data = toJson();
    if (lastMessage != null) {
      data["last_message_created_at"] =
          lastMessage!.createdAt?.toIso8601String();
      data["last_message"] = jsonEncode(data['last_message']);
    }
    return data;
  }

  Channel({
    required this.id,
    this.createdAt,
    required this.readMaxRole,
    required this.userId,
    required this.writeMaxRole,
    required this.name,
    required this.role,
    required this.unreadMessages,
    required this.type,
    this.nickname,
    this.thumbnail,
    this.peerUserId,
    this.lastMessage,
    this.folder,
    this.description,
    this.messages = 0,
    this.subscribers = 0,
    this.lastReadMessageAt,
    this.lastReadMessageId,
    this.lastEventId,
  });

  Channel.empty({this.id = ""})
      : userId = "",
        type = "",
        readMaxRole = 0,
        writeMaxRole = 0,
        name = "",
        role = 0,
        messages = 0,
        subscribers = 0,
        unreadMessages = 0;
}
