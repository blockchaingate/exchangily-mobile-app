import 'dart:async';

import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/wallet.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DataBaseService {
  final log = getLogger('DatabaseService');
  static final _databaseName = 'wallet_database1.db';

  static final _databaseVersion = 1;
  static Future<Database> _database;
  String path = '';

  // Future<Database> get database async {
  //   if (_database != null) return _database;
  //   _database = await initDb();
  //   return _database;
  // }

  Future<Database> initDb() async {
    var databasePath = await getDatabasesPath();
    path = join(databasePath, _databaseName);

    log.w(path);
    _database =
        openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
    log.e(_database);
    return _database;
  }

  void _onCreate(Database db, int version) async {
    log.e('in on create $db');
    await db.execute("CREATE TABLE test"
        " ("
        "id INTEGER PRIMARY KEY,"
        "name TEXT,"
        "age INTEGER)");
    // await db.rawInsert('INSERT INTO wallet (name, age) VALUES ("Barry", 10)');
    // await db.rawInsert('INSERT INTO wallet (name, age) VALUES ("Ken", 11)');
    // await db.rawInsert('INSERT INTO wallet (name, age) VALUES ("Paul", 27)');
  }

  Future<List<Test>> getAll() async {
    final Database db = await _database;
    log.w('getall $db');
    // res is giving me the same output in the log whether i map it or just take var res
    final List<Map<String, dynamic>> res = await db.query('test');
    log.w('res1 $res');
    List<Test> list =
        res.isNotEmpty ? res.map((f) => Test.fromMap(f)).toList() : [];

    print('list ${list.length}');
    return list;
  }

  Future deleteDb() async {
    log.w(path);
    await deleteDatabase(path);
    _database = null;
  }

  Future closeDb() async {
    var db = await _database;
    return db.close();
  }

  Future readData() async {
    //  final Database db;
  }

  Future insert(Test test) async {
    final Database db = await _database;
    var res = await db.insert('test', test.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return res;
  }
}
