// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'package:sqflite/sqflite.dart';

import '../event/event.dart';

class SyncDB {
  Database db;
  SyncDB({
    required this.db,
  });

  applyEvent(ModelChanged event) async {
    for (var action in event.actions) {
      switch (event.type) {
        case ModelAction.deleted:
          await _delete(event.model, action);
        case ModelAction.updated:
          await _update(event.model, action);
        case ModelAction.created:
          await _create(event.model, action);
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
    await db.insert(model, event.data!);
  }

  _update(String model, ModelAction event) async {
    if (event.data == null) {
      // warning here
      return;
    }
    await db.update(
      model,
      event.data!,
      where: "id IN ?",
      whereArgs: [event.recordIds],
    );
  }

  _delete(String model, ModelAction event) async {
    if (event.data == null) {
      // warning here
      return;
    }
    List<dynamic> whereArgs = [event.recordIds];
    await db.delete(
      model,
      where: "id IN ?",
      whereArgs: whereArgs,
    );
  }
}
