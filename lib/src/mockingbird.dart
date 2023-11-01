library mockingbird_messaging;

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mockingbird_messaging/src/event/event.dart';
import 'package:mockingbird_messaging/src/storage/sync.dart';
import 'package:sqflite/sqflite.dart';
import 'protocol/protocol.dart';
import 'storage/model/channel.dart';
import 'storage/model/contact.dart';
import 'storage/model/message.dart';
import 'storage/model/model_sync.dart';
part 'mockingbird.g.dart';

typedef HandleEvent = Function(Event);

@JsonSerializable(fieldRename: FieldRename.snake)
class SyncModelRequest extends Payload {
  static const String eventType = 'model.sync.request';
  String model;
  String lastUpdatedAt;
  String userId;

  SyncModelRequest({
    required this.model,
    required this.userId,
    required this.lastUpdatedAt,
  });

  @override
  Map<String, dynamic> toJson() => _$SyncModelRequestToJson(this);

  @override
  String get type => eventType;
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ConfigInfo extends Payload {
  static const String eventType = 'config-info';
  String lang;
  String clientId;
  DateTime time;
  ConfigInfo({
    required this.lang,
    required this.clientId,
    required this.time,
  });

  factory ConfigInfo.fromJson(Map<String, dynamic> json) =>
      _$ConfigInfoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ConfigInfoToJson(this);

  @override
  String get type => eventType;
}

class Mockingbird extends ChangeNotifier implements EventHandler {
  static final Mockingbird instance = Mockingbird._();
  late Protocol protocol;
  String _lang = "en";
  final List<HandleEvent> _handlers = [];
  late String userId;
  late Database db;
  static List<String> models = [
    "channels",
    "subscribers",
    "messages",
    "contacts",
    "users",
  ];

  Mockingbird._();

  String get lang {
    return _lang;
  }

  set lang(String lang) {
    _lang = lang;
    _changeLanguage(lang);
    notifyListeners();
  }

  initialize({
    required userId,
    required Protocol proto,
    required clientId,
    required Database db,
  }) async {
    protocol = proto;
    this.db = db;
    this.userId = userId;
    proto.handler = this;
    await protocol.listen();
    protocol.send(buildEvent(ConfigInfo(
      clientId: clientId,
      lang: _lang,
      time: DateTime.now(),
    )));
    Map<String, String> ts = {};
    for (var t in models) {
      ts[t] = "";
    }
    var modelSyncs = await db
        .query(ModelSync.stableName, where: "user_id = ?", whereArgs: [userId]);
    for (var m in modelSyncs) {
      ts[m['model'] as String] = m['last_updated_at'] as String;
    }
    for (var t in ts.keys) {
      protocol.send(buildEvent(SyncModelRequest(
        model: t,
        userId: userId,
        lastUpdatedAt: ts[t]!,
      )));
    }
  }

  _changeLanguage(String lang) {}

  Future<List<Contact>> getContacts({
    String? id,
    String? keyword,
  }) async {
    String where = '1';
    List whereArgs = [];
    if (id != null) {
      where = "$where AND id = ?";
      whereArgs = [id];
    } else if (keyword != null) {
      where = "$where AND (nickname LIKE ? OR user_name LIKE ?)";
      whereArgs.addAll(["%$keyword%", "%$keyword%"]);
    }
    return Contact.fromSqlite(await db.query(
      Contact.stableName,
      where: where,
      whereArgs: whereArgs,
    ));
  }

  Future<List<Channel>> getChannels({
    String? id,
    String? folder,
    String? keyword,
  }) async {
    String where = '1';
    List whereArgs = [];
    if (id != null) {
      where = "$where AND id = ?";
      whereArgs.add(id);
    } else if (folder != null) {
      where = "$where AND folder = ?";
      whereArgs.add(folder);
    }
    if (keyword != null) {
      where = "$where AND (name LIKE ? OR nickname LIKE ?)";
      whereArgs.addAll(["%$keyword%", "%$keyword%"]);
    }
    return Channel.fromSqlite(await db.query(
      Channel.stableName,
      where: where,
      whereArgs: whereArgs,
      orderBy: "last_message_created_at",
    ));
  }

  Future<List<Message>> getMessages({
    String? id,
    String? keyword,
    int limit = 40,
    bool before = false,
  }) async {
    String where = '1';
    List whereArgs = [];
    String orderBy = 'created_at asc';
    if (before) {
      orderBy = 'created_at desc';
      if (id != null) {
        where = "$where AND id < ?";
        whereArgs.add(id);
      }
    } else if (id != null) {
      where = "$where AND id >= ?";
      whereArgs.add(id);
    }
    if (keyword != null) {
      where = "$where AND content LIKE ? AND content_type = ?";
      whereArgs.addAll(["%$keyword%", "text"]);
    }
    List<Message> messages = Message.fromSqlite(await db.query(
      Message.stableName,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: limit,
    ));
    if (!before) {
      return messages;
    }
    List<Message> ret = [];
    for (var msg in messages) {
      ret.add(msg);
    }
    return ret;
  }

  @override
  handle(Event e) async {
    if (e.type == ModelChanged.eventType) {
      var change = ModelChanged.fromJson(e.payload!);
      var syncer = SyncDB(db: db);
      await syncer.applyEvent(userId, change);
    }
    for (var handle in _handlers) {
      handle(e);
    }
  }

  addEventListener(HandleEvent e) {
    _handlers.add(e);
  }

  removeEventListener(HandleEvent e) {
    _handlers.remove(e);
  }
}
