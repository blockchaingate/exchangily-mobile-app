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
import 'package:exchangilymobileapp/models/campaign/user_data.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CampaignUserDatabaseService {
  final log = getLogger('CampaignUserDatabaseService');

  static const _databaseName = 'campaign_user_database.db';
  final String tableName = 'campaign_user_data';
  // database table and column names
  final String columnId = 'id';
  final String columnEmail = 'email';
  final String columnToken = 'token';
  final String columnReferralCode = 'referralCode';

  static const _databaseVersion = 6;
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
        $columnId TEXT PRIMARY KEY,
        $columnEmail TEXT,
        $columnToken TEXT,
        $columnReferralCode INT
        )    
        ''');
  }

  // Get All Records From The Database

  Future<List<CampaignUserData>> getAll() async {
    await initDb();
    final Database db = (await _database)!;
    log.w('getall $db');

    // res is giving me the same output in the log whether i map it or just take var res
    final List<Map<String, dynamic>> res = await db.query(tableName);
    log.w('res $res');
    List<CampaignUserData> list = res.isNotEmpty
        ? res.map((f) => CampaignUserData.fromJson(f)).toList()
        : [];
    return list;
  }

// Insert Data In The Database
  Future insert(CampaignUserData campaignUserData) async {
    await initDb();
    final Database db = (await _database)!;
    int id = await db.insert(tableName, campaignUserData.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  // Get User By Id
  Future getByMemberId(String id) async {
    final Database db = (await _database)!;
    List<Map<String, dynamic>> res =
        await db.query(tableName, where: 'email= ?', whereArgs: [id]);
    log.w('ID - $id --- $res');
    if (res.isNotEmpty) {
      return CampaignUserData.fromJson(res.first);
    }
    return null;
  }

// Get User By Email
  Future getByEmail(String email) async {
    final Database db = (await _database)!;
    List<Map<String, dynamic>> res =
        await db.query(tableName, where: 'email= ?', whereArgs: [email]);
    log.w('ID - $email --- $res');
    if (res.isNotEmpty) {
      return CampaignUserData.fromJson(res.first);
    }
    return null;
  }

  // Get User By Token
  Future<CampaignUserData?> getUserDataByToken(String? token) async {
    await initDb();
    final Database db = (await _database)!;
    log.w('db $db');
    List<Map<String, dynamic>> res =
        await db.query(tableName, where: 'token= ?', whereArgs: [token]);
    log.w('Login token - $token --- $res');
    if (res.isNotEmpty) {
      return CampaignUserData.fromJson(res.first);
    }
    return null;
  }

  // Delete Single Object From Database By email
  Future<void> deleteUserData(String? email) async {
    final db = (await _database)!;
    await db.delete(tableName, where: "email = ?", whereArgs: [email]);
  }

  // Update database
  Future<void> update(CampaignUserData campaignUserData) async {
    final Database db = (await _database)!;
    await db.update(
      tableName,
      campaignUserData.toJson(),
      where: "email = ?",
      whereArgs: [campaignUserData.email],
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
