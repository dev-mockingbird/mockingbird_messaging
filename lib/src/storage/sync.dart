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
    switch (event.type) {
      case ModelChanged.deleted:
        return await _delete(event);
      case ModelChanged.updated:
        return await _update(event);
      case ModelChanged.created:
        return await _create(event);
      default:
      // warning here
    }
  }

  _create(ModelChanged event) async {
    if (event.data == null) {
      // warning here
      return;
    }
    await db.insert(event.model, event.data!);
  }

  _update(ModelChanged event) async {
    if (event.data == null) {
      // warning here
      return;
    }
    await db.update(
      event.model,
      event.data!,
      where: "id IN ?",
      whereArgs: [event.ids],
    );
  }

  _delete(ModelChanged event) async {
    if (event.data == null) {
      // warning here
      return;
    }
    List<dynamic> whereArgs = [event.ids];
    await db.delete(
      event.model,
      where: "id IN ?",
      whereArgs: whereArgs,
    );
  }
}
