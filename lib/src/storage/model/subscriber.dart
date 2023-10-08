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
class Subscriber extends NamedThumbmail {
  String userId;
  int? role;
  Subscriber({
    required super.id,
    required this.userId,
    this.role,
    super.thumbnail,
    super.nickname,
    super.createdAt,
  });

  // 反序列化
  factory Subscriber.fromJson(Map<String, dynamic> json) =>
      _$SubscriberFromJson(json);
  // 序列化
  Map<String, dynamic> toJson() => _$SubscriberToJson(this);
}
