// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'dart:convert';
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
    for (var action in event.actions) {
      if (!persistances.contains(action.model)) {
        continue;
      }
      switch (action.action) {
        case ModelAction.deleted:
          await _delete(action.model, action, userId);
        case ModelAction.updated:
          await _update(action.model, action, userId);
        case ModelAction.created:
          await _create(action.model, action, userId);
        default:
        // warning here
      }
    }
  }

  _create(String model, ModelAction event, String userId) async {
    if (event.data == null) {
      // warning here
      return;
    }
    await db.insert(
      model,
      fixData({
        ...event.data!,
        "client_user_id": userId,
      }),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Map<String, dynamic> _fixNullableTimeColumn(
    Map<String, dynamic> data,
    String name,
  ) {
    if (data[name] == null) {
      return data;
    } else if (data[name] is Map) {
      if (data[name]["Valid"] ?? false) {
        data[name] = data[name]["Time"];
      } else {
        data[name] = null;
      }
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
    return fixData(data);
  }

  static Map<String, dynamic> fixData(Map<String, dynamic> data) {
    for (var col in ['last_read_message_at', 'last_message_at']) {
      data = _fixNullableTimeColumn(data, col);
    }
    for (var col in ['online']) {
      data = _fixBooleanColumn(data, col);
    }
    for (var col in ['deleted_at', 'contact_protected']) {
      data = _dropColumn(data, col);
    }
    return _jsonData(data);
  }

  static _jsonData(Map<String, dynamic> data) {
    for (var col in [
      'audio',
      'media',
      'attachment',
      'article',
      'last_message_audio',
      'last_message_media',
      'last_message_attachment',
      'last_message_article'
    ]) {
      if (data[col] != null) {
        data[col] = jsonEncode(data[col]);
      }
    }
    return data;
  }

  _update(String model, ModelAction event, String userId) async {
    if (event.data == null) {
      // warning here
      return;
    }
    await db.update(
      model,
      fixData(event.data!),
      where:
          "id IN (${event.recordIds!.map((v) => '?').join(',')}) AND client_user_id = ?",
      whereArgs: [...event.recordIds!, userId],
    );
  }

  _delete(String model, ModelAction event, String userId) async {
    if (event.data == null) {
      // warning here
      return;
    }
    await db.delete(
      model,
      where:
          "id IN (${event.recordIds!.map((v) => '?').join(',')}) AND client_user_id = ?",
      whereArgs: [...event.recordIds!, userId],
    );
  }
}
