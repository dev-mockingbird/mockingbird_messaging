library mockingbird_messaging;

import 'package:json_annotation/json_annotation.dart';
import 'package:mockingbird_messaging/src/event/event.dart';
import 'package:mockingbird_messaging/src/storage/sync.dart';
import 'package:sqflite/sqflite.dart';
import 'protocol/protocol.dart';
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

@JsonSerializable(fieldRename: FieldRename.snake)
class ChangeLang extends Payload {
  static const String eventType = 'change-lang';
  String lang;
  ChangeLang({
    required this.lang,
  });

  factory ChangeLang.fromJson(Map<String, dynamic> json) =>
      _$ChangeLangFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ChangeLangToJson(this);

  @override
  String get type => eventType;
}

class Mockingbird extends EventHandler {
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
    protocol.send(buildEvent(ChangeLang(lang: lang)));
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
    proto.onConnected = () async {
      await protocol.send(buildEvent(ConfigInfo(
        clientId: clientId,
        lang: _lang,
        time: DateTime.now(),
      )));
    };
    await protocol.listen();
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

  @override
  handle(Event event) async {
    if (event.type == ModelChanged.eventType) {
      var change = ModelChanged.fromJson(event.payload!);
      var syncer = SyncDB(db: db);
      await syncer.applyEvent(userId, change);
    }

    for (var handle in _handlers) {
      handle(event);
    }
  }

  addEventListener(HandleEvent e) {
    _handlers.add(e);
  }

  removeEventListener(HandleEvent e) {
    _handlers.remove(e);
  }
}
