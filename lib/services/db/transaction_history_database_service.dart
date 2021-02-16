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

class TransactionHistoryDatabaseService {
  final log = getLogger('TransactionHistoryDatabaseService');

  static final _databaseName = 'transaction_history_database.db';
  final String tableName = 'transaction_history';
  // database table and column names
  final String columnId = 'id';
  final String columnTickerName = 'tickerName';
  final String columnAddress = 'address';
  final String columnAmount = 'amount';
  final String columnDate = 'date';
  final String columnKanabanTxId = 'kanbanTxId';
  final String columnTickerChainTxId = 'tickerChainTxId';
  final String columnTickerChainTxStatus = 'tickerChainTxStatus';
  final String columnKanbanTxStatus = 'kanbanTxStatus';
  final String columnQuantity = 'quantity';
  final String columnTag = 'tag';
  final String columnChainName = 'chainName';

  static final _databaseVersion = 6;
  static Future<Database> _database;
  String path = '';

  Future<Database> initDb() async {
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
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnTickerName TEXT,    
        $columnAddress TEXT,
        $columnAmount REAL,
        $columnDate TEXT,
        $columnKanabanTxId TEXT,
        $columnTickerChainTxId TEXT,
        $columnTickerChainTxStatus TEXT,
        $columnKanbanTxStatus TEXT,
        $columnQuantity REAL,
        $columnTag TEXT
        $columnChainName TEXT) ''');
  }

  // Get All Records From The Database

  Future<List<TransactionHistory>> getAll() async {
    await initDb();
    final Database db = await _database;
    // res is giving me the same output in the log whether i map it or just take var res
    final List<Map<String, dynamic>> res = await db.query(tableName);
    log.w('get all res $res');
    List<TransactionHistory> list = res.isNotEmpty
        ? res.map((f) => TransactionHistory.fromJson(f)).toList()
        : [];
    return list;
  }

// Insert Data In The Database
  Future insert(TransactionHistory transactionHistory) async {
    // await deleteDb();
    await initDb();
    final Database db = await _database;
    int id = await db.insert(tableName, transactionHistory.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  // Get Single Wallet By Tag
  Future<List<TransactionHistory>> getByTagName(String tag) async {
    await initDb();
    final Database db = await _database;
    List<Map> res =
        await db.query(tableName, where: 'tag= ?', whereArgs: [tag]);
    log.w('tagName - $tag --- $res');

    List<TransactionHistory> list = res.isNotEmpty
        ? res.map((f) => TransactionHistory.fromJson(f)).toList()
        : [];
    return list;
    // return TransactionHistory.fromJson((res.first));
  }

  // Get Single Wallet By Name
  Future<List<TransactionHistory>> getByName(String name) async {
    await initDb();
    final Database db = await _database;
    List<Map> res =
        await db.query(tableName, where: 'tickerName= ?', whereArgs: [name]);
    log.w('Name - $name --- $res');

    List<TransactionHistory> list = res.isNotEmpty
        ? res.map((f) => TransactionHistory.fromJson(f)).toList()
        : [];
    return list;
    // return TransactionHistory.fromJson((res.first));
  }

  // Get Single Wallet By Name
  Future<List<TransactionHistory>> getByNameOrderByDate(String name) async {
    await initDb();
    final Database db = await _database;
    List<Map> res = await db.query(tableName,
        where: 'tickerName= ?', orderBy: columnDate, whereArgs: [name]);
    log.w('Name - $name --- $res');

    List<TransactionHistory> list = res.isNotEmpty
        ? res.map((f) => TransactionHistory.fromJson(f)).toList()
        : [];
    return list;
    // return TransactionHistory.fromJson((res.first));
  }

  // Get Single Wallet By Id
  Future getById(int id) async {
    final Database db = await _database;
    List<Map> res = await db.query(tableName, where: 'id= ?', whereArgs: [id]);
    log.w('ID - $id --- $res');
    if (res.length > 0) {
      return TransactionHistory.fromJson((res.first));
    }
    return null;
  }

  // Get Single Wallet By txId
  Future<TransactionHistory> getByKanbanTxId(String tickerChainTxId) async {
    final Database db = await _database;
    List<Map> res = await db.query(tableName,
        where: 'tickerChainTxId= ?', whereArgs: [tickerChainTxId]);
    log.w('tickerChainTxId - $tickerChainTxId --- $res');
    if (res.length > 0) {
      return TransactionHistory.fromJson((res.first));
    }
    return null;
  }

  // Update database
  Future<void> update(TransactionHistory transactionHistory) async {
    final Database db = await _database;
    await db.update(
      tableName,
      transactionHistory.toJson(),
      where: "tickerChainTxId = ?",
      whereArgs: [transactionHistory.kanbanTxId],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Update  status
  Future updateStatus(TransactionHistory transactionHistory) async {
    final Database db = await _database;
    await db.rawUpdate(
        'UPDATE TransactionHistory SET status = ${transactionHistory.tickerChainTxStatus} where kanbanTxId = ${transactionHistory.tickerChainTxId}');
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
