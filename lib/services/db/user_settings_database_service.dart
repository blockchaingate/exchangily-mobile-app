/*
* Copyright (c) 2020 Exchangily LLC
*
* Licensed under Apache License v2.0
* You may obtain a copy of the License at
*
*      https://www.apache.org/licenses/LICENSE-2.0
*
*----------------------------------------------------------------------
* Author: barry-ruprai@exchangily.com
*----------------------------------------------------------------------
*/

import 'dart:async';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/wallet/user_settings_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class UserSettingsDatabaseService {
  final log = getLogger('UserSettingsDatabaseService');

  static const _databaseName = 'user_settings_database.db';
  final String tableName = 'user_settings';
  // database table and column names
  final String columnId = 'id';
  final String columnLanguage = 'language';
  final String columnTheme = 'theme';

  static const _databaseVersion = 4;
  static Future<Database> _database;
  String path = '';

  Future<Database> initDb() async {
    // try {
    //   await _database.then((res) {
    //     print(res.isOpen);
    //     print(res);
    //   });
    //   return _database;
    // } catch (err) {
    //   log.e('initDb - corrupted db - deleting ');
    //   await deleteDb();
    // }

    if (_database != null) return _database;
    var databasePath = await getDatabasesPath();
    path = join(databasePath, _databaseName);
    log.w(path);
    _database =
        openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
    return _database;
  }

  void _onCreate(Database db, int version) async {
    log.e('in on create $db');
    await db.execute(''' CREATE TABLE $tableName
        (
        $columnId INTEGER PRIMARY KEY,
        $columnLanguage TEXT,    
        $columnTheme TEXT) ''');
  }

  // Get All Records From The Database

  Future<List<UserSettings>> getAll() async {
    await initDb();
    final Database db = await _database;
    log.w('getall $db');

    // res is giving me the same output in the log whether i map it or just take var res
    final List<Map<String, dynamic>> res = await db.query(tableName);
    log.w('res $res');
    List<UserSettings> list =
        res.isNotEmpty ? res.map((f) => UserSettings.fromJson(f)).toList() : [];
    return list;
  }

// Insert Data In The Database
  Future insert(UserSettings userSettings) async {
    await initDb();
    int id = 0;
    try {
      final Database db = await _database;
      id = await db.insert(tableName, userSettings.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (err) {
      await deleteDb();
      await initDb();
      await insert(userSettings);
    }
    return id;
  }

  // Get Single Wallet By Id
  Future<UserSettings> getById(int id) async {
    final Database db = await _database;
    List<Map> res = await db.query(tableName, where: 'id= ?', whereArgs: [id]);
    log.w('ID - $id --- $res');
    if (res.isNotEmpty) {
      return UserSettings.fromJson((res.first));
    }
    return null;
  }

  // Get Single Wallet By Id
  Future<String> getLanguage() async {
    final Database db = await _database;
    if (db == null) return "en";
    List<Map> res = await db.query(tableName);
    log.w('res --- $res');
    if (res.isNotEmpty) {
      return UserSettings.fromJson((res.first)).language;
    }
    return null;
  }

  // Delete Single Object From Database By Id
  Future<void> delete(int id) async {
    final db = await _database;
    await db.delete(tableName, where: "id = ?", whereArgs: [id]);
  }

  // Update database
  Future<void> update(UserSettings userSettings) async {
    final Database db = await _database;
    await db.update(
      tableName,
      userSettings.toJson(),
      where: "id = ?",
      whereArgs: [userSettings.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Close Database
  Future closeDb() async {
    var db = await _database;
    return db.close();
  }

  // Delete Database
  Future deleteDb() async {
    log.w(path);
    await deleteDatabase(path);
    _database = null;
  }
}
