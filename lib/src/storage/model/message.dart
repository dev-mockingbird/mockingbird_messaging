// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:mockingbird_messaging/src/storage/sqlite.dart';
part 'message.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class MessageFile {
  String id;
  String? name;
  String mimeType;
  int size;
  MessageFile({
    required this.id,
    required this.mimeType,
    required this.size,
    this.name,
  });

  factory MessageFile.fromJson(Map<String, dynamic> json) =>
      _$MessageFileFromJson(json);
  Map<String, dynamic> toJson() => _$MessageFileToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class MessageAudio extends MessageFile {
  int length;
  MessageAudio({
    required super.id,
    required super.mimeType,
    required super.size,
    required this.length,
    super.name,
  });

  factory MessageAudio.fromJson(Map<String, dynamic> json) =>
      _$MessageAudioFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$MessageAudioToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class MessageMedia extends MessageFile {
  int? width;
  int? height;

  MessageMedia({
    required super.id,
    required super.mimeType,
    required super.size,
    super.name,
    this.width,
    this.height,
  });

  factory MessageMedia.fromJson(Map<String, dynamic> json) =>
      _$MessageMediaFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$MessageMediaToJson(this);
}

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
  List<MessageMedia>? media;
  List<MessageFile>? attachment;
  MessageAudio? audio;
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
