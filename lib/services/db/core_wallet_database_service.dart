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
import 'dart:convert';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/wallet/core_wallet_model.dart';
import 'package:exchangilymobileapp/utils/fab_util.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CoreWalletDatabaseService {
  final log = getLogger('WalletCoreService');

  static final _databaseName = 'wallet_core.db';
  final String tableName = 'wallet_core';
  // database table and column names
  final String columnId = 'id';

  final String columnMnemonic = "mnemonic";
  final String columnWalletBalancesBody = "walletBalancesBody";

  static final _databaseVersion = 1;
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
        $columnMnemonic TEXT,
        $columnWalletBalancesBody TEXT) ''');
  }

  // Get All Records From The Database

  Future<CoreWalletModel> getAll() async {
    //await deleteDb();
    await initDb();
    final Database db = await _database;
    log.w('getall $db');

    // res is giving me the same output in the log whether i map it or just take var res
    final List<Map<String, dynamic>> res = await db.query(tableName);
    log.w('res $res');

    CoreWalletModel walletCore = CoreWalletModel();
    if (res.isNotEmpty) {
      var zero = res[0];

      walletCore = CoreWalletModel.fromJson(zero);
      log.w('get all walletcoremodel ${walletCore.toJson()}');
    }
    return walletCore;
  }

// Insert Data In The Database
  Future insert(CoreWalletModel walletCoreModel) async {
    await initDb();
    final Database db = await _database;

    int id = await db.insert(tableName, walletCoreModel.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    return id;
  }

  // Get encrypted mnemonic
  Future<String> getEncryptedMnemonic() async {
    final Database db = await _database;
    List<Map> res = await db.query(tableName, columns: [columnMnemonic]);
    log.i('Encrypted Mnemonic --- ${res.first}');

    return res.first['mnemonic'];
  }

  // Get wallet balance body
  Future<Map<dynamic, dynamic>> getWalletBalancesBody() async {
    final Database db = await _database;
    List<Map> res =
        await db.query(tableName, columns: [columnWalletBalancesBody]);
    log.i('wallet balances body --- ${res.first}');

    return res.first;
  }

  // Get FAB address
  Future<String> getFabAddress() async {
    final Database db = await _database;
    List<Map> res =
        await db.query(tableName, columns: [columnWalletBalancesBody]);

    log.i(
        'Fab address --- ${jsonToMap(res.first['walletBalancesBody'], 'fabAddress')}');
    return jsonToMap(res.first['walletBalancesBody'], 'fabAddress');
  }

  // Get EXG address
  Future<String> getExgAddress() async {
    var fabUtils = FabUtils();
    final Database db = await _database;
    List<Map> res =
        await db.query(tableName, columns: [columnWalletBalancesBody]);

    log.i(
        'exg address --- ${jsonToMap(res.first['walletBalancesBody'], 'exgAddress')}');
    var fabAddress = jsonToMap(res.first['walletBalancesBody'], 'fabAddress');
    return fabUtils.fabToExgAddress(fabAddress);
  }

  // Get ETH address
  Future<String> getEthAddress() async {
    final Database db = await _database;
    List<Map> res =
        await db.query(tableName, columns: [columnWalletBalancesBody]);

    log.i(
        'ETH address --- ${jsonToMap(res.first['walletBalancesBody'], 'ethAddress')}');
    return jsonToMap(res.first['walletBalancesBody'], 'ethAddress');
  }

  // Get TRX address
  Future<String> getTrxAddress() async {
    final Database db = await _database;
    List<Map> res =
        await db.query(tableName, columns: [columnWalletBalancesBody]);
    log.i(
        'trx address --- ${jsonToMap(res.first['walletBalancesBody'], 'trxAddress')}');
    return jsonToMap(res.first['walletBalancesBody'], 'trxAddress');
  }

  jsonToMap(String json, String chainName) {
    return jsonDecode(json)[chainName];
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
