// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:mockingbird_messaging/src/storage/model/message.dart';
import 'package:mockingbird_messaging/src/storage/sqlite.dart';
part 'channel.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Channel extends SqliteModel {
  static const int roleOwner = 0;
  static const int roleManager = 1;
  static const int roleSubscriber = 2;
  static const int roleGuest = 3;
  static const int roleAny = 10;
  static const String stableName = "channels";
  static const List<String> fields = [
    'id TEXT',
    'user_id TEXT',
    'name TEXT',
    'avatar_url TEXT',
    'folder TEXT',
    'category TEXT',
    'peer_user_id TEXT',
    'last_read_message_id TEXT',
    'current_seen_message_id TEXT',
    'last_read_message_at TEXT',
    'last_message_created_at TEXT',
    'last_message TEXT',
    'description TEXT',
    'unread_messages INTEGER',
    'role INTEGER',
    'messages INTEGER',
    'subscribers INTEGER',
    'read_max_role INTEGER',
    'write_max_role INTEGER',
    'last_event_id TEXT',
    'created_at TEXT',
    'PRIMARY KEY (id, user_id)'
  ];
  String id;
  String name;
  String userId;
  @JsonKey(disallowNullValue: false)
  String? avatarUrl;
  @JsonKey(disallowNullValue: false)
  String? folder;
  String category;
  @JsonKey(disallowNullValue: false)
  String? peerUserId;
  @JsonKey(disallowNullValue: false)
  String? lastReadMessageId;
  @JsonKey(disallowNullValue: false)
  DateTime? lastReadMessageAt;
  @JsonKey(disallowNullValue: false)
  DateTime? createdAt;
  @JsonKey(disallowNullValue: false)
  Message? lastMessage;
  @JsonKey(disallowNullValue: false)
  String? description;
  int unreadMessages;
  int role;
  int messages;
  int subscribers;
  int readMaxRole;
  int writeMaxRole;
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
    required this.category,
    this.createdAt,
    required this.readMaxRole,
    required this.userId,
    required this.writeMaxRole,
    required this.name,
    required this.role,
    required this.unreadMessages,
    this.avatarUrl,
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
      : category = "chat",
        userId = "",
        readMaxRole = 0,
        writeMaxRole = 0,
        name = "",
        role = 0,
        messages = 0,
        subscribers = 0,
        unreadMessages = 0;
}
