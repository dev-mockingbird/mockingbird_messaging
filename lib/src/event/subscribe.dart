// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'package:json_annotation/json_annotation.dart';
import 'event.dart';
part 'subscribe.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SubscribeChannel extends Payload {
  static const String eventType = "channel.subscribe";
  @override
  String get type => eventType;

  String channelId;

  SubscribeChannel({
    required this.channelId,
  });

  factory SubscribeChannel.fromJson(Map<String, dynamic> json) =>
      _$SubscribeChannelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SubscribeChannelToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class UnsubscribeChannel extends Payload {
  static const String eventType = "channel.unsubscribe";
  @override
  String get type => eventType;

  String channelId;

  UnsubscribeChannel({
    required this.channelId,
  });

  factory UnsubscribeChannel.fromJson(Map<String, dynamic> json) =>
      _$UnsubscribeChannelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UnsubscribeChannelToJson(this);
}
