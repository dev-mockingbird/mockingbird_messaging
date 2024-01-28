library mockingbird_messaging;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mockingbird_messaging/src/event/event.dart';
import 'package:mockingbird_messaging/src/storage/model/channel.dart';
import 'package:mockingbird_messaging/src/storage/model/contact.dart';
import 'package:mockingbird_messaging/src/storage/sync.dart';
import 'package:sqflite/sqflite.dart';
import 'init_events.dart';
import 'protocol/protocol.dart';
import 'storage/model/message.dart';

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
    return await send(buildEvent(ChangeLang(lang: lang)), waitResult: true) !=
        null;
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
    state = MockingbirdState.unconnect;
    _modelSyncState.clear();
    proto.addEventListner(this);
    proto.addListener(() {
      switch (proto.state) {
        case ConnectState.unconnect:
          state = MockingbirdState.unconnect;
          break;
        case ConnectState.connecting:
          state = MockingbirdState.connecting;
          break;
        case ConnectState.connected:
          state = MockingbirdState.connected;
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
      await syncModels();
      notifyListeners();
    };
    return await _protocol!.listen();
  }

  Future<bool> syncModels() async {
    state = MockingbirdState.modelSyncing;
    await syncContact();
    await syncChannel();
    var channels = await db.query(
      Channel.stableName,
      columns: ["id"],
      where: "client_user_id = ?",
      whereArgs: [userId],
    );
    for (var ch in channels) {
      await syncMessage(ch["id"] as String);
      await syncMessageLike(ch["id"] as String);
      await syncMessageTag(ch["id"] as String);
    }
    state = MockingbirdState.modelSynced;
    return true;
  }

  set state(MockingbirdState state) {
    _state = state;
    notifyListeners();
  }

  Future<String> getLastActiveAt(String model, {String? channelId}) async {
    String where = "client_user_id = ?";
    var whereArgs = [userId];
    if (channelId != null) {
      where += " AND channel_id = ?";
      whereArgs.add(channelId);
    }
    var modelSyncs = await db.query(
      model,
      columns: ["MAX(updated_at) as updated_at"],
      where: where,
      whereArgs: whereArgs,
      limit: 1,
    );
    if (modelSyncs.isEmpty) {
      return "";
    }
    return (modelSyncs[0]["updated_at"] as String?) ?? "";
  }

  syncContact() async {
    Event? res = await send(
      buildEvent(
        SyncModelContact(
          lastUpdatedAt: await getLastActiveAt(Contact.stableName),
        ),
      ),
      waitResult: true,
    );
    if (res == null) {
      return false;
    }
    if (!await _handle(res)) {
      return false;
    }
    return true;
  }

  syncChannel() async {
    Event? res = await send(
      buildEvent(
        SyncModelChannel(
          lastUpdatedAt: await getLastActiveAt(Channel.stableName),
        ),
      ),
      waitResult: true,
    );
    if (res == null) {
      return false;
    }
    if (!await _handle(res)) {
      return false;
    }
    return true;
  }

  syncMessage(String channelId) async {
    var lastActiveAt = await getLastActiveAt(
      Message.stableName,
      channelId: channelId,
    );
    Event? res = await send(buildEvent(SyncModelMessage(
      lastUpdatedAt: lastActiveAt,
      channelId: channelId,
    )));
    if (res == null) {
      return;
    }
    return _handle(res);
  }

  syncMessageLike(String channelId) async {
    var lastActiveAt = await getLastActiveAt(
      Channel.stableName,
      channelId: channelId,
    );
    Event? res = await send(buildEvent(SyncModelMessageLike(
      lastUpdatedAt: lastActiveAt,
      channelId: channelId,
    )));
    if (res == null) {
      return;
    }
    return _handle(res);
  }

  syncMessageTag(String channelId) async {
    var lastActiveAt = await getLastActiveAt(
      Channel.stableName,
      channelId: channelId,
    );
    Event? res = await send(buildEvent(SyncModelMessageTag(
      lastUpdatedAt: lastActiveAt,
      channelId: channelId,
    )));
    if (res == null) {
      return;
    }
    return _handle(res);
  }

  stop() async {
    if (valid()) {
      await _protocol!.stop();
    }
  }

  valid({bool syncing = false}) {
    if (syncing) {
      return _protocol != null;
    }
    return _protocol != null && _protocol!.state == ConnectState.connected;
  }

  Future<Event?> send(
    Event event, {
    bool? waitResult,
    Duration? timeout,
    bool syncing = true,
  }) async {
    if (!valid(syncing: syncing)) {
      return null;
    }
    if (!(waitResult ?? false)) {
      await _protocol!.send(event);
      return null;
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
      return null;
    }
    await completer.future;
    _protocol!.removeEventListner(handler);
    return result;
  }

  @override
  handle(Event event) async {
    await _handle(event);
  }

  Future<bool> _handle(Event event) async {
    if (event.type == ModelChanged.eventType) {
      var change = ModelChanged.fromJson(event.payload!);
      var syncer = SyncDB(db: db);
      await syncer.applyEvent(userId, change);
    }
    for (var handle in _handlers) {
      handle(event);
    }
    return true;
  }

  addEventListener(HandleEvent e) {
    _handlers.add(e);
  }

  removeEventListener(HandleEvent e) {
    _handlers.remove(e);
  }
}
