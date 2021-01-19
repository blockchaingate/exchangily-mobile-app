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
import 'package:exchangilymobileapp/models/wallet/token.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TokenListDatabaseService {
  final log = getLogger('TokenListDatabaseService');

  static final _databaseName = 'token_list_database.db';
  final String tableName = 'token_list';
  // database table and column names
  final String columnId = 'id';
  final String columnDecimal = 'decimal';
  final String columnCoinName = 'coinName';
  final String columnChainName = 'chainName';
  final String columnTickerName = 'tickerName';
  final String columnTokenType = 'type';
  final String columnContract = 'contract';
  final String columnMinWithdraw = 'minWithdraw';
  final String columnFeeWithdraw = 'feeWithdraw';

  static final _databaseVersion = 5;
  static Future<Database> _database;
  String path = '';

  Future<Database> initDb() async {
    //  deleteDb();
    if (_database != null) return _database;
    var databasePath = await getDatabasesPath();
    path = join(databasePath, _databaseName);
    log.w('init db $path');
    _database =
        openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
    return _database;
  }

  void _onCreate(Database db, int version) async {
    log.e('in on create $db');
    await db.execute(''' CREATE TABLE $tableName
        (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnDecimal INTEGER,
        $columnCoinName TEXT,
        $columnChainName TEXT,
        $columnTickerName TEXT,
        $columnTokenType INTEGER,
        $columnContract TEXT,
        $columnMinWithdraw TEXT,
        $columnFeeWithdraw TEXT) ''');
  }

  // Get All Records From The Database

  Future<List<Token>> getAll() async {
    await initDb();
    final Database db = await _database;
    log.w('getall $db');

    // res is giving me the same output in the log whether i map it or just take var res
    final List<Map<String, dynamic>> res = await db.query(tableName);
    log.w('res $res');
    List<Token> list =
        res.isNotEmpty ? res.map((f) => Token.fromJson(f)).toList() : [];
    return list;
  }

// Insert Data In The Database
  Future insert(Token passedToken) async {
    await initDb();
    int id;
    // bool isDuplicate = false;
    // await getAll().then((tokenList) {
    //   print(tokenList.length);
    //   tokenList.forEach((token) {
    //     if (token.tickerName == passedToken.tickerName) {
    //       isDuplicate = true;
    //       log.e(
    //           '${token.tickerName} == ${passedToken.tickerName} coin already present in the token db');
    //       return;
    //     }
    //   });
    // });
    // if (!isDuplicate) {
    final Database db = await _database;
    id = await db
        .insert(tableName, passedToken.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace)
        .whenComplete(
            () => log.w('${passedToken.tickerName} new entry in the token db'));
    // }
    return id;
  }

  // Get Single transaction By Name
  Future<Token> getByTickerName(String tickerName) async {
    await initDb();
    final Database db = await _database;
    List<Map> res = await db
        .query(tableName, where: 'tickerName= ?', whereArgs: [tickerName]);
    log.i('Name - $tickerName - res-- $res');

    if (res.isNotEmpty) return Token.fromJson(res.first);
    return null;
    // return TransactionHistory.fromJson((res.first));
  }

  // Get Single transaction By Name
  Future<String> getContractAddressByTickerName(String tickerName) async {
    await initDb();
    final Database db = await _database;
    List<Map> res = await db
        .query(tableName, where: 'tickerName= ?', whereArgs: [tickerName]);
    log.w('Name - $tickerName - res-- $res');

    if (res.isNotEmpty) return Token.fromJson(res.first).contract;
    return null;
    // return TransactionHistory.fromJson((res.first));
  }

  // Get Single transaction By Name
  getCoinTypeByTickerName(String tickerName) async {
    await initDb();
    final Database db = await _database;
    List<Map> res = await db.query(tableName,
        distinct: true,
        where: 'tickerName= ?',
        whereArgs: [tickerName],
        limit: 1);
    log.w('Name - $tickerName - res-- $res');
    int tt = Token.fromJson(res.first).tokenType;
    log.i('token type $tt');

    if (res.isNotEmpty) return Token.fromJson(res.first).tokenType;

    return null;
    // return TransactionHistory.fromJson((res.first));
  }

  // Get Single transaction By Name
  getTickerNameByCoinType(int coinType) async {
    await initDb();
    final Database db = await _database;
    List<Map> res = await db.query(tableName,
        distinct: true, where: 'type= ?', whereArgs: [coinType], limit: 1);
    log.w('Name - $coinType - res-- $res');
    String ticker = Token.fromJson(res.first).tickerName;
    log.i('ticker $ticker');

    if (res.isNotEmpty) return Token.fromJson(res.first).tickerName;

    return null;
    // return TransactionHistory.fromJson((res.first));
  }

  // Get Single transaction By Id
  Future getById(int id) async {
    final Database db = await _database;
    List<Map> res = await db.query(tableName, where: 'id= ?', whereArgs: [id]);
    log.w('ID - $id --- $res');
    if (res.length > 0) {
      return Token.fromJson((res.first));
    }
    return null;
  }

  // Update database
  Future<void> update(Token token) async {
    final Database db = await _database;
    await db.update(
      tableName,
      token.toJson(),
      where: "id = ?",
      whereArgs: [token.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // delete single token
  Future<void> deleteByTickerName(String tickerName) async {
    final db = await _database;
    await db
        .delete(tableName, where: "tickerName = ?", whereArgs: [tickerName]);
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
    log.e('$_databaseName deleted');
    _database = null;
  }
}
