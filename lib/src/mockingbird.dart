library mockingbird_messaging;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mockingbird_messaging/src/event/event.dart';
import 'package:mockingbird_messaging/src/storage/sync.dart';
import 'package:sqflite/sqflite.dart';
import 'protocol/protocol.dart';
import 'storage/model/model_sync.dart';
part 'mockingbird.g.dart';

typedef HandleEvent = Function(Event);

class RequestIdEventHandler extends EventHandler {
  Function(Event e) handleFunc;
  String requestId;
  RequestIdEventHandler(
    this.handleFunc, {
    required this.requestId,
  });

  @override
  handle(Event e) {
    return handleFunc(e);
  }
}

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
  Protocol? _protocol;
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

  ErrorCode get lastCode {
    return _protocol!.lastCode;
  }

  String get lastError {
    return _protocol!.lastError;
  }

  Future<bool> setLanguage(String lang) async {
    _lang = lang;
    return await send(buildEvent(ChangeLang(lang: lang)));
  }

  Future<bool> initialize({
    required userId,
    required Protocol proto,
    required clientId,
    required Database db,
  }) async {
    _protocol = proto;
    this.db = db;
    this.userId = userId;
    proto.addEventListner(this);
    proto.onConnected = () async {
      await _protocol!.send(buildEvent(ConfigInfo(
        clientId: clientId,
        lang: _lang,
        time: DateTime.now(),
      )));
      Map<String, String> ts = {};
      for (var t in models) {
        ts[t] = "";
      }
      var modelSyncs = await db.query(ModelSync.stableName,
          where: "user_id = ?", whereArgs: [userId]);
      for (var m in modelSyncs) {
        ts[m['model'] as String] = m['last_updated_at'] as String;
      }
      for (var t in ts.keys) {
        _protocol!.send(buildEvent(SyncModelRequest(
          model: t,
          userId: userId,
          lastUpdatedAt: ts[t]!,
        )));
      }
    };
    return await _protocol!.listen();
  }

  bool addConnectStateListener(VoidCallback callback) {
    if (_protocol != null) {
      _protocol!.addListener(callback);
      return true;
    }
    return false;
  }

  bool removeConnectStateListener(VoidCallback callback) {
    if (_protocol != null) {
      _protocol!.removeListener(callback);
      return true;
    }
    return false;
  }

  stop() async {
    if (valid()) {
      await _protocol!.stop();
    }
  }

  ConnectState get connectState {
    if (_protocol == null) {
      return ConnectState.unconnect;
    }
    return _protocol!.state;
  }

  valid() {
    return _protocol != null && _protocol!.state == ConnectState.connected;
  }

  Future<dynamic> send(
    Event event, {
    bool? waitResult,
    Duration? timeout,
  }) async {
    if (!valid()) {
      return false;
    }
    if (!(waitResult ?? false)) {
      return await _protocol!.send(event);
    }
    var completer = Completer();
    var requestId = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
    event.withMeta("request-id", requestId);
    Event? result;
    Timer? timer;
    if (timeout != null) {
      timer = Timer(timeout, () {
        completer.complete();
      });
    }
    var handler = RequestIdEventHandler((e) {
      if (e.hasMeta("request-id", requestId)) {
        result = e;
        if (timer != null) {
          timer.cancel();
        }
        completer.complete();
      }
    }, requestId: requestId);
    _protocol!.addEventListner(handler);
    if (!await _protocol!.send(event)) {
      return false;
    }
    await completer.future;
    _protocol!.removeEventListner(handler);
    return result;
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
