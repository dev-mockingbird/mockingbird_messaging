// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'package:json_annotation/json_annotation.dart';
import 'package:mockingbird_messaging/src/storage/model/user.dart';
part 'subscriber.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Subscriber extends NamedThumbmail {
  @JsonKey()
  UserId user;
  Subscriber({
    required super.id,
    super.thumbnail,
    super.nickname,
    super.createdAt,
    required this.user,
  });

  // 反序列化
  factory Subscriber.fromJson(Map<String, dynamic> json) =>
      _$SubscriberFromJson(json);
  // 序列化
  Map<String, dynamic> toJson() => _$SubscriberToJson(this);
}
