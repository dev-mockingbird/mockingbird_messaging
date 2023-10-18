library mockingbird_messaging;

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mockingbird_messaging/src/event/event.dart';
import 'package:mockingbird_messaging/src/storage/sync.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import 'src/protocol/protocol.dart';
import 'src/storage/kv.dart';
import 'src/storage/model/channel.dart';
import 'src/storage/model/contact.dart';
import 'src/storage/model/message.dart';
part 'mockingbird_messaging.g.dart';

typedef ModelChangedHandler = Function(ModelChanged);

@JsonSerializable(fieldRename: FieldRename.snake)
class SyncModelRequest extends Payload {
  static const String eventType = 'model.sync';
  String model;
  int latestOffset;

  SyncModelRequest({required this.model, required this.latestOffset});

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
  late String id;
  final List<ModelChangedHandler> _handlers = [];
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

  initialize({required Protocol proto, required Database db}) async {
    id = await KV.get<String>("client-id");
    if (id == '') {
      id = const Uuid().v1();
      await KV.save("client-id", id);
    }
    protocol = proto;
    this.db = db;
    proto.handler = this;
    protocol.listen();
    protocol.send(buildEvent(ConfigInfo(
      clientId: id,
      lang: _lang,
      time: DateTime.now(),
    )));
    for (var table in models) {
      protocol.send(buildEvent(SyncModelRequest(
        model: table,
        latestOffset: await KV.get<int>(table),
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
    if (e.type != ModelChanged.eventType) {
      return;
    }
    var change = ModelChanged.fromJson(e.payload!);
    var syncer = SyncDB(db: db);
    await syncer.applyEvent(change);
    for (var handle in _handlers) {
      handle(change);
    }
  }

  addModelChangedListener(ModelChangedHandler change) {
    _handlers.add(change);
  }

  removeModelChangedListener(ModelChangedHandler change) {
    _handlers.remove(change);
  }
}
