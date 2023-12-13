// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'package:json_annotation/json_annotation.dart';
import '../storage/model/message.dart';
import 'event.dart';
part 'message.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TypeMessage extends Payload {
  static const String eventType = "channel.typing";
  String channelId;
  String userId;
  String content;

  TypeMessage({
    required this.channelId,
    required this.content,
    required this.userId,
  });
  @override
  String get type {
    return eventType;
  }

  factory TypeMessage.fromJson(Map<String, dynamic> json) =>
      _$TypeMessageFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TypeMessageToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class CreateMessage extends Payload {
  static const String eventType = "channel.message.create";
  @override
  String get type => eventType;

  String channelId;
  String? text;
  List<MessageMedia>? media;
  List<MessageFile>? attachment;
  MessageAudio? audio;
  MessageArticle? article;
  String? referMessageId;

  CreateMessage({
    required this.channelId,
    this.referMessageId,
    this.text,
    this.media,
    this.article,
    this.audio,
    this.attachment,
  });

  factory CreateMessage.fromJson(Map<String, dynamic> json) =>
      _$CreateMessageFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CreateMessageToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class UpdateMessage extends Payload {
  static const String eventType = "channel.message.update";
  @override
  String get type => eventType;

  String id;
  String? text;
  List<MessageMedia>? media;
  List<MessageFile>? attachment;
  MessageAudio? audio;
  MessageArticle? article;

  UpdateMessage({
    required this.id,
    this.text,
    this.media,
    this.article,
    this.audio,
    this.attachment,
  });

  factory UpdateMessage.fromJson(Map<String, dynamic> json) =>
      _$UpdateMessageFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UpdateMessageToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class DeleteMessage extends Payload {
  static const String eventType = "channel.message.delete";
  @override
  String get type => eventType;

  String id;

  DeleteMessage({
    required this.id,
  });

  factory DeleteMessage.fromJson(Map<String, dynamic> json) =>
      _$DeleteMessageFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DeleteMessageToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ViewMessage extends Payload {
  static const String eventType = "channel.message.view";
  String messageId;
  String userId;
  ViewMessage({required this.messageId, required this.userId});
  @override
  Map<String, dynamic> toJson() => _$ViewMessageToJson(this);

  @override
  String get type => eventType;
}

@JsonSerializable(fieldRename: FieldRename.snake)
class LikeMessage extends Payload {
  static const String eventType = "channel.message.like";
  String messageId;
  int amount;
  LikeMessage({
    required this.messageId,
    required this.amount,
  });

  LikeMessage.like({required this.messageId}) : amount = 1;
  LikeMessage.unlike({required this.messageId}) : amount = -1;
  LikeMessage.uncertain({required this.messageId}) : amount = 0;

  @override
  Map<String, dynamic> toJson() => _$LikeMessageToJson(this);

  @override
  String get type => eventType;
}

@JsonSerializable(fieldRename: FieldRename.snake)
class TagMessage extends Payload {
  static const String eventType = "channel.message.tag";
  String messageId;
  String tag;
  bool untag;
  TagMessage({
    required this.messageId,
    required this.tag,
    this.untag = false,
  });

  @override
  Map<String, dynamic> toJson() => _$TagMessageToJson(this);

  @override
  String get type => eventType;
}
