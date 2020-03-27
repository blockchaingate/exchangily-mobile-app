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

  static final _databaseName = 'campaign_user_database.db';
  final String tableName = 'campaign_user';
  // database table and column names
  final String columnId = 'id';
  final String columnEmail = 'email';
  final String columnToken = 'token';
  final String columnReferralCode = 'referralCode';
  final String columnDateCreated = 'dateCreated';
  final String columnParentDiscount = 'parentDiscount';
  final String columnTotalUSDMadeByChildren = 'totalUSDMadeByChildren';
  final String columnTotalTokensPurchased = 'totalTokensPurchased';
  final String columnPointsEarned = 'pointsEarned';

  static final _databaseVersion = 1;
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
        $columnEmail TEXT,
        $columnToken TEXT,
        $columnReferralCode TEXT,      
        $columnDateCreated TEXT,
        $columnParentDiscount REAL,  
        $columnTotalUSDMadeByChildren REAL,  
        $columnTotalTokensPurchased REAL,  
        $columnPointsEarned REAL)    
        ''');
  }

  // Get All Records From The Database

  Future<List<CampaignUserData>> getAll() async {
    await initDb();
    final Database db = await _database;
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
    final Database db = await _database;
    int id = await db.insert(tableName, campaignUserData.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

// Get User By Email
  Future getByEmail(String email) async {
    final Database db = await _database;
    List<Map> res =
        await db.query(tableName, where: 'email= ?', whereArgs: [email]);
    log.w('ID - $email --- $res');
    if (res.length > 0) {
      return CampaignUserData.fromJson((res.first));
    }
    return null;
  }

  // Get User By Token
  Future getUserDataByToken(String token) async {
    await initDb();
    final Database db = await _database;
    log.w('db $db');
    List<Map> res =
        await db.query(tableName, where: 'token= ?', whereArgs: [token]);
    log.w('Login token - $token --- $res');
    if (res.length > 0) {
      return CampaignUserData.fromJson((res.first));
    }
    return null;
  }

  // Delete Single Object From Database By email
  Future<void> deleteUserData(String email) async {
    final db = await _database;
    await db.delete(tableName, where: "email = ?", whereArgs: [email]);
  }

  // Update database
  Future<void> update(CampaignUserData campaignUserData) async {
    final Database db = await _database;
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
