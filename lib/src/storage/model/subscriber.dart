// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'package:json_annotation/json_annotation.dart';
import 'package:mockingbird_messaging/src/storage/model/user.dart';
part 'subscriber.g.dart';

class SubscribeRole {
  static const int roleOwner = 0;
  static const int roleManager = 1;
  static const int roleSubscriber = 2;
  static const int roleGuest = 3;
  static const int roleAny = 10;
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Subscriber extends NamedAvatar {
  String userId;
  String? folder;
  String channelId;
  String? invitedBy;
  bool online;
  int role;
  int unreadMessages;
  String? lastReadMessageId;
  DateTime? lastReadMessageAt;

  static String stableName = "subscribers";

  static List<String> get fields {
    List<String> fields = NamedAvatar.fields;
    fields.addAll([
      "user_id TEXT",
      "client_user_id TEXT",
      "folder TEXT",
      "channel_id TEXT",
      "invited_by TEXT",
      "online INTEGER",
      "role INTEGER",
      "unread_messages INTEGER",
      "last_read_message_id TEXT",
      "last_read_message_at TEXT",
      "updated_at TEXT",
    ]);
    return fields;
  }

  Subscriber({
    required super.id,
    required this.userId,
    required this.channelId,
    this.role = SubscribeRole.roleAny,
    this.online = false,
    this.unreadMessages = 0,
    this.lastReadMessageAt,
    this.lastReadMessageId,
    super.avatarUrl,
    super.nickname,
    super.createdAt,
  });

  static List<Subscriber> fromSqlite(List<Map<String, dynamic>> data) {
    List<Subscriber> ret = [];
    for (var item in data) {
      ret.add(Subscriber.fromJson(item));
    }
    return ret;
  }

  // 反序列化
  factory Subscriber.fromJson(Map<String, dynamic> json) =>
      _$SubscriberFromJson(json);
  // 序列化
  Map<String, dynamic> toJson() => _$SubscriberToJson(this);
}
