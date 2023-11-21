// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'package:mockingbird_messaging/src/storage/model/model_sync.dart';
import 'package:sqflite/sqflite.dart';

import '../event/event.dart';

class SyncDB {
  static const persistances = [
    "channels",
    "subscribers",
    "messages",
    "message_likes",
    "message_tags",
    "users",
    "contacts",
  ];
  Database db;
  SyncDB({
    required this.db,
  });

  applyEvent(String userId, ModelChanged event) async {
    Map<String, String> lastUpdated = {};
    for (var action in event.actions) {
      if (!persistances.contains(action.model)) {
        continue;
      }
      var updatedAt = action.data?["updated_at"];
      if (updatedAt != null) {
        if (lastUpdated[action.model] == null) {
          lastUpdated[action.model] = updatedAt;
        } else if (lastUpdated[action.model]!.compareTo(updatedAt) < 0) {
          lastUpdated[action.model] = updatedAt;
        }
      }
      switch (action.action) {
        case ModelAction.deleted:
          await _delete(action.model, action);
        case ModelAction.updated:
          await _update(action.model, action);
        case ModelAction.created:
          await _create(action.model, action);
        default:
        // warning here
      }
    }
    for (var m in lastUpdated.keys) {
      db.insert(
          ModelSync.stableName,
          {
            "model": m,
            "user_id": userId,
            "last_updated_at": lastUpdated[m],
          },
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  _create(String model, ModelAction event) async {
    if (event.data == null) {
      // warning here
      return;
    }
    await db.insert(model, _fixData(event.data!),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Map<String, dynamic> _fixNullableColumn(
    Map<String, dynamic> data,
    String name,
  ) {
    if (data[name] == null) {
      return data;
    }
    if (data[name]["Valid"] ?? false) {
      data[name] = data[name]["Time"];
    } else {
      data[name] = null;
    }
    return data;
  }

  static Map<String, dynamic> _fixBooleanColumn(
    Map<String, dynamic> data,
    String name,
  ) {
    if (data[name] == null || data[name] is! bool) {
      return data;
    }
    if (data[name]) {
      data[name] = 1;
    } else {
      data[name] = 0;
    }
    return data;
  }

  static Map<String, dynamic> _dropColumn(
    Map<String, dynamic> data,
    String name,
  ) {
    data.remove(name);
    return data;
  }

  static alignModel(Map<String, dynamic> data) {
    return _fixData(data);
  }

  static Map<String, dynamic> _fixData(Map<String, dynamic> data) {
    for (var col in ['last_read_message_at', 'last_message_at']) {
      data = _fixNullableColumn(data, col);
    }
    for (var col in ['online']) {
      data = _fixBooleanColumn(data, col);
    }
    for (var col in ['deleted_at', 'contact_protected']) {
      data = _dropColumn(data, col);
    }
    return data;
  }

  _update(String model, ModelAction event) async {
    if (event.data == null) {
      // warning here
      return;
    }
    await db.update(
      model,
      _fixData(event.data!),
      where: "id IN (${event.recordIds!.map((v) => '?').join(',')})",
      whereArgs: event.recordIds,
    );
  }

  _delete(String model, ModelAction event) async {
    if (event.data == null) {
      // warning here
      return;
    }
    await db.delete(
      model,
      where: "id IN (${event.recordIds!.map((v) => '?').join(',')})",
      whereArgs: event.recordIds,
    );
  }
}
