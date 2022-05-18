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
import 'package:exchangilymobileapp/models/wallet/app_wallet_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class WalletDatabaseService {
  final log = getLogger('WalletDatabaseService');

  static const _databaseName = 'wallet_database.db';
  final String tableName = 'wallet';
  // database table and column names
  final String columnId = 'id';
  final String columnName = 'name';
  final String columnTickerName = 'tickerName';
  final String columnTokenType = 'tokenType';
  final String columnAddress = 'address';
  final String columnLockedBalance = 'lockedBalance';
  final String columnAvailableBalance = 'availableBalance';
  final String columnUsdValue = 'usdValue';
  final String columnInExchange = 'inExchange';

  static const _databaseVersion = 3;
  static Future<Database> _database;
  String path = '';

  Future<Database> initDb() async {
    if (_database != null) return _database;
    var databasePath = await getDatabasesPath();
    path = join(databasePath, _databaseName);
    log.w('initDB $path');
    _database =
        openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
    return _database;
  }

  openDB() {
    openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  void _onCreate(Database db, int version) async {
    log.i('in on create $db');
    await db.execute(''' CREATE TABLE $tableName
        (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnName TEXT,
        $columnTickerName TEXT,
        $columnTokenType TEXT,
        $columnAddress TEXT,
        $columnLockedBalance REAL,
        $columnAvailableBalance REAL,
        $columnUsdValue REAL,
        $columnInExchange REAL) ''');
  }

  // Get All Records From The Database

  Future<List<AppWallet>> getAll() async {
    //await deleteDb();
    // await initDb();
    final Database db = await _database;
    log.w('getall $db');

    // res is giving me the same output in the log whether i map it or just take var res
    final List<Map<String, dynamic>> res = await db.query(tableName);
    log.w('res $res');

    List<AppWallet> list =
        res.isNotEmpty ? res.map((f) => AppWallet.fromJson(f)).toList() : [];
    return list;
  }

// Insert Data In The Database
  Future insert(AppWallet AppWallet) async {
    await initDb();
    final Database db = await _database;

    int id = await db.insert(tableName, AppWallet.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    return id;
  }

  // Get Single Wallet By Name
  Future<AppWallet> getByName(String name) async {
    final Database db = await _database;
    List<Map> res =
        await db.query(tableName, where: 'name= ?', whereArgs: [name]);
    log.w('ID - $name --- $res');
    if (res.isNotEmpty) {
      return AppWallet.fromJson((res.first));
    }
    return null;
  }

  // Get Single Wallet By tickerName
  Future<AppWallet> getWalletBytickerName(String tickerName) async {
    final Database db = await _database;
    List<Map> res = await db
        .query(tableName, where: 'tickerName= ?', whereArgs: [tickerName]);
    log.w('tickerName - $tickerName --res - $res');
    if (res.isNotEmpty) {
      return AppWallet.fromJson((res.first));
    }
    return null;
  }

  // Get Single Wallet By Id
  Future getById(int id) async {
    final Database db = await _database;
    List<Map> res = await db.query(tableName, where: 'id= ?', whereArgs: [id]);
    // log.w('ID - $id --- $res');
    if (res.isNotEmpty) {
      return AppWallet.fromJson((res.first));
    }
    return null;
  }

  // Delete Single Object From Database By Id
  Future<void> deleteWallet(int id) async {
    final db = await _database;
    await db.delete(tableName, where: "id = ?", whereArgs: [id]);
  }

  // Delete Single Object From Database By tickerName
  Future<void> deleteWalletByTickerName(String tickerName) async {
    final db = await _database;
    await db
        .delete(tableName, where: "tickerName = ?", whereArgs: [tickerName]);
  }

  // Update database
  Future<void> update(AppWallet AppWallet) async {
    final Database db = await _database;

    await db
        .update(
      tableName,
      AppWallet.toJson(),
      where: "id = ?",
      whereArgs: [AppWallet.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    )
        .catchError((err) {
      log.e('update catch $err');
    });
  }

  // Close Database
  Future closeDb() async {
    var db = await _database;
    return db.close();
  }

  // Delete Database
  Future deleteDb() async {
    log.i('database path $path');
    try {
      await deleteDatabase(path);
      var databasePath = await getDatabasesPath();
      var p = join(databasePath, _databaseName);

      log.w('database path after delete: $p');
      _database = null;
    } catch (err) {
      log.e('deleteDb CATCH $err');
    }
  }
}
