// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'dart:async';
import 'package:mockingbird_messaging/src/storage/model/channel.dart';
import 'package:mockingbird_messaging/src/storage/model/message.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'model/contact.dart';
import 'model/subscriber.dart';
import 'model/user.dart';

abstract class SqliteModel {
  String tableName();
  Map<String, dynamic> toSqliteMap();
  String get idKey {
    return "id";
  }
}

class Sqlite {
  Database? _db;

  Future<int> insert<T extends SqliteModel>(List<T> models) async {
    Database db = await getdb();
    List<Future> ins = [];
    for (var i = 0; i < models.length; i++) {
      var data = models[i].toSqliteMap();
      ins.add(db.insert(
        models[i].tableName(),
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      ));
    }
    Future.wait(ins);
    return models.length;
  }

  Future<void> update(SqliteModel model) async {
    Database db = await getdb();
    Map<String, dynamic> data = model.toSqliteMap();
    List<Object?> args = [];
    args.add(data[model.idKey]);
    await db.update(
      model.tableName(),
      data,
      where: "${model.idKey} = ?",
      whereArgs: args,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> delete(SqliteModel model) async {
    Database db = await getdb();
    Map<String, dynamic> data = model.toSqliteMap();
    List<Object?> args = [];
    args.add(data[model.idKey]);
    await db.delete(
      model.tableName(),
      where: "${model.idKey} = ?",
      whereArgs: args,
    );
  }

  // reference https://pub.dev/packages/sqflite_common_ffi_web for how to setup sqlite for web
  // dart run sqflite_common_ffi_web:setup
  Future<Database> getdb() async {
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
    } else {
      databaseFactory = databaseFactoryFfi;
    }
    if (_db != null) {
      return _db!;
    }
    var path = await getDatabasesPath();
    print("database db path: $path");
    _db = await openDatabase(join(path, 'mockingbird_database.db'),
        version: 8, onCreate: _initDatabase, onUpgrade: _upgrade);
    return _db!;
  }

  _upgrade(Database db, old, n) async {
    _initDatabase(db, n);
  }

  _initDatabase(Database db, version) async {
    var sqls = [
      "CREATE TABLE ${Channel.stableName}(${Channel.fields.join(",")})",
      "CREATE TABLE ${Message.stableName}(${Message.fields.join(",")})",
      "CREATE TABLE ${User.stableName}(${User.fields.join(",")})",
      "CREATE TABLE ${Contact.stableName}(${Contact.fields.join(",")})",
      "CREATE TABLE ${Subscriber.stableName}(${Subscriber.fields.join(",")})",
    ];
    for (var sql in sqls) {
      print(sql);
      await db.execute(sql);
    }
  }
}
