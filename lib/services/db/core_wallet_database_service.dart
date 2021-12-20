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
    if (_database != null) {
      log.i('init db -- ${_database.toString()}');

      return _database;
    }
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
    await initDb();
    final Database db = await _database;
    log.w('getall $db');

    // res is giving me the same output in the log whether i map it or just take var res
    final List<Map<String, dynamic>> res = await db.query(tableName);
    log.w('res $res');

    CoreWalletModel walletCore = CoreWalletModel();
    if (res.isNotEmpty) {
      walletCore = CoreWalletModel.fromJson(res.first);
      log.w('get all walletcoremodel ${walletCore.toJson()}');
    }
    return walletCore;
  }

// Insert Data In The Database
  Future insert(CoreWalletModel walletCoreModel) async {
    try {
      await _database.then((res) {
        print('is database open ${res.isOpen}');
        print(res);
      });
    } catch (err) {
      log.e('initDb - corrupted db - deleting ');
      await deleteDb();
      await initDb();
    }
    final Database db = await _database;
    // log.i('wallet core model ${walletCoreModel.toJson()}');
    // if (walletCoreModel.mnemonic == null) {
    //   walletCoreModel = CoreWalletModel(
    //       id: 1,
    //       mnemonic:
    //           "sHHa+qlwgrFO4NsqOwAdnH7hawy5USQ/eC1kQOe/A1v/ywBCCfCr/f+1fXDMjO165GBxGTyWNrznLkdSN+j6QOib1eGfPK26B89sgbcdTK8=",
    //       walletBalancesBody:
    //           '{"btcAddress":"1QCm73M8DS2gzdMvypJDFc9zbtnSCmESZR","ethAddress":"0xe0dc9ba67a0d96f77a3242ef70fc8a51d444764c","fabAddress":"16RWDm7PvEog5j3T8i7eqGDPWZTLqaKuH2","ltcAddress":"LccFvYsqZ1P2Uh5eEXuDDb9zwruhb1vA7c","dogeAddress":"DABE1hjVrBNtwCz4TvdAirbSpPUACErPWs","bchAddress":"bitcoincash:qzv5jpn64yvzfef4w33pshf80tgapnxa9yep3qvvu8","trxAddress":"TW1LXBhCsCfKsqmxxj6qeFoKVMDDWbqcwz","showEXGAssets":"true"}');
    // }
    int id = 0;
    var dataToInsert = walletCoreModel.toJson();
    log.w('dataToInsert $dataToInsert');
    await db
        .insert
        //  'INSERT INTO $tableName($columnId, $columnMnemonic, $columnWalletBalancesBody) VALUES(1, "1234", "456.789")')

        (tableName, dataToInsert, conflictAlgorithm: ConflictAlgorithm.replace)
        .then((resId) {
      id = resId;
      log.w('core wallet inserted Id $id');
    }).catchError((err) async {
      log.e('Insert failed -Catch $err');
      await deleteDb();
      await initDb();
      await insert(walletCoreModel);
    });
    return id;
  }

  // Get encrypted mnemonic
  Future<String> getEncryptedMnemonic() async {
    await initDb();
    final Database db = await _database;
    //  if (db == null) await initDb();
    String encryptedMnemonic = '';
    List<Map> res = await db.query(tableName, columns: [columnMnemonic]);
    if (res.length != 0) if (res[0]['mnemonic'] != null) {
      log.i('Encrypted Mnemonic --- ${res.first}');
      encryptedMnemonic = res.first['mnemonic'];
    }

    return encryptedMnemonic;
  }

  // Get wallet balance body
  Future<Map<dynamic, dynamic>> getWalletBalancesBody() async {
    await initDb();
    final Database db = await _database;
    var finalRes;
    List<Map> res =
        await db.query(tableName, columns: [columnWalletBalancesBody]);
    try {
      log.i('wallet balances body --- ${res.first}');
      finalRes = res.first;
    } catch (err) {
      res = null;
    }

    return finalRes;
  }

  // getWalletAddressByTickerName
  Future<String> getWalletAddressByTickerName(String tickerName) async {
    final Database db = await _database;

    var fabUtils = FabUtils();
    String address = '';
    String passedTicker = '';
    List<Map> res =
        await db.query(tableName, columns: [columnWalletBalancesBody]);
    if (tickerName == 'EXG') {
      passedTicker = tickerName;
      tickerName = 'FAB';
    }
    ;

    address = jsonToMap(
        res.first['walletBalancesBody'], '${tickerName.toLowerCase()}Address');
    String finalRes = '';
    finalRes =
        passedTicker == 'EXG' ? fabUtils.fabToExgAddress(address) : address;
    log.i(
        '${passedTicker.isEmpty ? tickerName : passedTicker} address ---finalRes $finalRes');
    return finalRes;
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
