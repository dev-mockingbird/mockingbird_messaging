// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:mockingbird_messaging/src/storage/sqlite.dart';

import '../../fileinfo.dart';
import 'message.dart';
part 'channel.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Channel extends SqliteModel {
  static const String typeChannel = "channel";
  static const String typeGroup = "group";
  static const String typeChat = "chat";
  static const String stableName = "channels";
  String id;
  String countryCode;
  String? channelId;
  String name;
  String? nickname;
  String? avatarUrl;
  String? description;
  String? peerUserId;
  String type;
  int writeMaxRole;
  int readMaxRole;
  int messages;
  String? lastMessageSubscriberId;
  String? lastMessageId;
  String? lastMessageText;
  List<FileInfo>? lastMessageMedia;
  List<FileInfo>? lastMessageAudio;
  List<MessageArticle>? lastMessageArticle;
  List<FileInfo>? lastMessageAttachment;
  String? lastMessageAt;
  String? lastMessagePrevId;
  int? subscribers;
  String? creatorId;
  DateTime createdAt;
  DateTime? updatedAt;

  static const List<String> fields = [
    "id TEXT PRIMARY KEY",
    "client_user_id TEXT",
    "type TEXT",
    "channel_id TEXT",
    "country_code TEXT",
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
    'last_message_audio TEXT',
    'last_message_article TEXT',
    'last_message_attachment TEXT',
    'last_message_text TEXT',
    'last_message_media TEXT',
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
    required this.countryCode,
    required this.createdAt,
    required this.readMaxRole,
    required this.writeMaxRole,
    required this.name,
    required this.type,
    this.lastMessageText,
    this.lastMessageMedia,
    this.lastMessageAudio,
    this.lastMessageArticle,
    this.lastMessageAttachment,
    this.channelId,
    this.nickname,
    this.avatarUrl,
    this.peerUserId,
    this.description,
    this.messages = 0,
    this.subscribers = 0,
    this.lastMessageSubscriberId,
    this.lastMessageId,
    this.lastMessageAt,
    this.lastMessagePrevId,
  });

  static List<Channel> fromSqlite(List<Map<String, dynamic>> data) {
    List<Channel> ret = [];
    for (var item in data) {
      var ch = {...item};
      for (var k in [
        'last_message_media',
        'last_message_audio',
        'last_message_article',
        'last_message_attachment'
      ]) {
        if (ch[k] != null && ch[k] != "") {
          ch[k] = jsonDecode(ch[k]);
        }
      }
      ret.add(Channel.fromJson(item));
    }
    return ret;
  }

  @override
  Map<String, dynamic> toSqliteMap() {
    var data = toJson();
    if (lastMessageAttachment != null) {
      data['last_message_attachment'] = jsonEncode(lastMessageAttachment);
    }
    if (lastMessageAudio != null) {
      data['last_message_audio'] = jsonEncode(lastMessageAudio);
    }
    if (lastMessageArticle != null) {
      data['last_message_article'] = jsonEncode(lastMessageArticle);
    }
    if (lastMessageMedia != null) {
      data['last_message_media'] = jsonEncode(lastMessageMedia);
    }
    return data;
  }

  // 反序列化
  factory Channel.fromJson(Map<String, dynamic> json) =>
      _$ChannelFromJson(json);
  // 序列化
  Map<String, dynamic> toJson() => _$ChannelToJson(this);
}
