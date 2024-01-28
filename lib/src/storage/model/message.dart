// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:mockingbird_messaging/src/storage/sqlite.dart';

import '../../../mockingbird_messaging.dart';
part 'message.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class MessageArticle {
  String title;
  String content;
  MessageArticle({
    required this.title,
    required this.content,
  });

  factory MessageArticle.fromJson(Map<String, dynamic> json) =>
      _$MessageArticleFromJson(json);
  Map<String, dynamic> toJson() => _$MessageArticleToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Message extends SqliteModel {
  static const String stableName = "messages";
  static const List<String> fields = [
    'id TEXT PRIMARY KEY',
    'channel_id TEXT',
    "client_user_id TEXT",
    'prev_id TEXT',
    'refer_message_id TEXT',
    'audio TEXT',
    'article TEXT',
    'attachment TEXT',
    'text TEXT',
    'media TEXT',
    'creator_id TEXT',
    'read_count INTEGER',
    'updated_at TEXT',
    'created_at TEXT'
  ];

  String id;
  String channelId;
  String? prevId;
  String? text;
  List<FileInfo>? media;
  List<FileInfo>? attachment;
  FileInfo? audio;
  MessageArticle? article;
  String creatorId;
  String? referMessageId;
  DateTime? createdAt;
  DateTime? updatedAt;
  Message({
    required this.id,
    required this.channelId,
    required this.creatorId,
    this.text,
    this.media,
    this.audio,
    this.attachment,
    this.article,
    this.referMessageId,
    this.prevId,
    this.createdAt,
    this.updatedAt,
  });

  @override
  String tableName() {
    return "messages";
  }

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  @override
  Map<String, dynamic> toSqliteMap() {
    var data = toJson();
    if (media != null) {
      data['media'] = jsonEncode(media);
    }
    if (attachment != null) {
      data['attachment'] = jsonEncode(attachment);
    }
    if (audio != null) {
      data['audio'] = jsonEncode(audio);
    }
    if (article != null) {
      data['article'] = jsonEncode(article);
    }
    return data;
  }

  static List<Message> fromSqlite(List<Map<String, dynamic>> data) {
    List<Message> ret = [];
    for (var item in data) {
      var msg = {...item};
      for (var k in ['media', 'audio', 'article', 'attachment']) {
        if (msg[k] != null && msg[k] != "") {
          msg[k] = jsonDecode(msg[k]);
        }
      }
      ret.add(Message.fromJson(msg));
    }
    return ret;
  }

  // 序列化
  Map<String, dynamic> toJson() => _$MessageToJson(this);
}
