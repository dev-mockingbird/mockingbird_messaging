library mockingbird_messaging;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mockingbird_messaging/src/event/event.dart';
import 'package:mockingbird_messaging/src/storage/sync.dart';
import 'package:sqflite/sqflite.dart';
import 'init_events.dart';
import 'protocol/protocol.dart';
import 'storage/model/model_sync.dart';

typedef HandleEvent = Function(Event);

class RequestIdEventHandler implements EventHandler {
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

enum MockingbirdState {
  unconnect,
  connecting,
  connected,
  modelSyncing,
  modelSynced,
}

class Mockingbird extends ChangeNotifier implements EventHandler {
  static final Mockingbird instance = Mockingbird._();
  Protocol? _protocol;
  String _lang = "en";
  final List<HandleEvent> _handlers = [];
  late String userId;
  late Database db;
  MockingbirdState _state = MockingbirdState.unconnect;
  final Map<String, bool> _modelSyncState = {};
  static List<String> models = [
    "channels",
    "subscribers",
    "messages",
    "message_likes",
    "message_tags",
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

  MockingbirdState get state {
    return _state;
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
    _state = MockingbirdState.unconnect;
    notifyListeners();
    _modelSyncState.clear();
    proto.addEventListner(this);
    proto.addListener(() {
      switch (proto.state) {
        case ConnectState.unconnect:
          _state = MockingbirdState.unconnect;
          break;
        case ConnectState.connecting:
          _state = MockingbirdState.connecting;
          break;
        case ConnectState.connected:
          _state = MockingbirdState.connected;
          break;
      }
      notifyListeners();
    });
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
      _state = MockingbirdState.modelSyncing;
      notifyListeners();
    };
    return await _protocol!.listen();
  }

  stop() async {
    if (valid()) {
      await _protocol!.stop();
    }
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
    } else if (event.type == SyncModelDone.eventType) {
      var payload = SyncModelDone.fromJson(event.payload!);
      _modelSyncState[payload.model] = true;
      bool done = true;
      for (var model in models) {
        if (!(_modelSyncState[model] ?? false)) {
          done = false;
          break;
        }
      }
      if (done) {
        _state = MockingbirdState.modelSynced;
        notifyListeners();
      }
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
