// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'package:sqflite/sqflite.dart';

import '../event/event.dart';

class SyncDB {
  static const persistances = [
    "channels",
    "subscribers",
    "messages",
    "users",
    "contacts",
  ];
  Database db;
  SyncDB({
    required this.db,
  });

  applyEvent(ModelChanged event) async {
    for (var action in event.actions) {
      if (!persistances.contains(action.action)) {
        continue;
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
  }

  _create(String model, ModelAction event) async {
    if (event.data == null) {
      // warning here
      return;
    }
    await db.insert(model, _fixData(event.data!),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Map<String, dynamic> _fixNullableColumn(
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

  Map<String, dynamic> _fixBooleanColumn(
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

  Map<String, dynamic> _dropColumn(
    Map<String, dynamic> data,
    String name,
  ) {
    data.remove(name);
    return data;
  }

  Map<String, dynamic> _fixData(Map<String, dynamic> data) {
    for (var col in ['last_read_message_at', 'last_message_at']) {
      data = _fixNullableColumn(data, col);
    }
    for (var col in ['online']) {
      data = _fixBooleanColumn(data, col);
    }
    for (var col in ['deleted_at']) {
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
