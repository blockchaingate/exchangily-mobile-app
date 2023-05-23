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
import 'package:exchangilymobileapp/models/wallet/transaction_history.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CampaignOrderDatabaseService {
  final log = getLogger('TransactionHistoryDatabaseService');

  static const _databaseName = 'campaign_order_database.db';
  final String tableName = 'campaign_order';
  // database table and column names
  final String columnId = 'id';
  final String columnDate = 'date';
  final String columnAmount = 'amount';
  final String columnStatus = 'status';

  static const _databaseVersion = 1;
  static Future<Database>? _database;
  String path = '';

  Future<Database>? initDb() async {
    if (_database != null) return _database!;
    var databasePath = await getDatabasesPath();
    path = join(databasePath, _databaseName);
    log.w(path);
    _database =
        openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
    return _database!;
  }

  void _onCreate(Database db, int version) async {
    log.e('in on create $db');
    await db.execute(''' CREATE TABLE $tableName
        (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnDate TEXT
        $columnAmount REAL,
        $columnStatus REAL,
        ) ''');
  }

  // Get All Records From The Database

  Future<List<TransactionHistory>> getAll() async {
    await initDb();
    final Database db = (await _database)!;
    log.w('getall $db');

    // res is giving me the same output in the log whether i map it or just take var res
    final List<Map<String, dynamic>> res = await db.query(tableName);
    log.w('res $res');
    List<TransactionHistory> list = res.isNotEmpty
        ? res.map((f) => TransactionHistory.fromJson(f)).toList()
        : [];
    return list;
  }

// Insert Data In The Database
  Future insert(TransactionHistory transactionHistory) async {
    await initDb();
    final Database db = (await _database)!;
    int id = await db.insert(tableName, transactionHistory.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  // Get Single transaction By Name
  Future<List<TransactionHistory>> getByName(String name) async {
    await initDb();
    final Database db = (await _database)!;
    List<Map<String, dynamic>> res =
        await db.query(tableName, where: 'tickerName= ?', whereArgs: [name]);
    log.w('Name - $name --- $res');

    List<TransactionHistory> list = res.isNotEmpty
        ? res.map((f) => TransactionHistory.fromJson(f)).toList()
        : [];
    return list;
    // return TransactionHistory.fromJson((res.first));
  }

  // Get Single transaction By Id
  Future getById(int id) async {
    final Database db = (await _database)!;
    List<Map<String, dynamic>> res =
        await db.query(tableName, where: 'id= ?', whereArgs: [id]);
    log.w('ID - $id --- $res');
    if (res.isNotEmpty) {
      return TransactionHistory.fromJson(res.first);
    }
    return null;
  }

  // Delete Single Object From Database By Id
  Future<void> deleteWallet(int id) async {
    final db = (await _database)!;
    await db.delete(tableName, where: "id = ?", whereArgs: [id]);
  }

  // Update database
  Future<void> update(TransactionHistory transactionHistory) async {
    final Database db = (await _database)!;
    await db.update(
      tableName,
      transactionHistory.toJson(),
      where: "id = ?",
      whereArgs: [transactionHistory.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Close Database
  Future closeDb() async {
    var db = (await _database)!;
    return db.close();
  }

  // Delete Database
  Future deleteDb() async {
    log.w(path);
    await deleteDatabase(path);
    _database = null;
  }
}
