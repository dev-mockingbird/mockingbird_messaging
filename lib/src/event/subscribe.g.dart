// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscribe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscribeChannel _$SubscribeChannelFromJson(Map<String, dynamic> json) =>
    SubscribeChannel(
      channelId: json['channel_id'] as String,
    );

Map<String, dynamic> _$SubscribeChannelToJson(SubscribeChannel instance) =>
    <String, dynamic>{
      'channel_id': instance.channelId,
    };

UnsubscribeChannel _$UnsubscribeChannelFromJson(Map<String, dynamic> json) =>
    UnsubscribeChannel(
      channelId: json['channel_id'] as String,
    );

Map<String, dynamic> _$UnsubscribeChannelToJson(UnsubscribeChannel instance) =>
    <String, dynamic>{
      'channel_id': instance.channelId,
    };
