import 'dart:async';

import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/wallet.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DataBaseService {
  final log = getLogger('DatabaseService');
  static final _databaseName = 'wallet_database.db';

  static final _databaseVersion = 1;
  static Database _database;
  var databasePath;
  String path;

  get database async {
    if (_database != null) return _database;
    _database = await initDb();
    return _database;
  }

  Future<Database> initDb() async {
    databasePath = await getDatabasesPath();
    path = join(databasePath, _databaseName);
    log.w(path);
    var theDatabase = await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
    log.e(theDatabase);
    return theDatabase;
  }

  void _onCreate(Database db, int version) async {
    log.e('in on create $db');
    await db.execute("CREATE TABLE wallet_database"
        " ("
        "id INTEGER PRIMARY KEY,"
        "name TEXT,"
        "age INTEGER)");
    await db.rawInsert(
        'INSERT INTO wallet_database (name, age) VALUES ("Barry", 10)');
    await db.rawInsert(
        'INSERT INTO wallet_database (name, age) VALUES ("Ken", 11)');
    await db.rawInsert(
        'INSERT INTO wallet_database (name, age) VALUES ("Paul", 27)');
  }

  Future<List<Test>> getAll() async {
    final Database db = DataBaseService._database;
    log.w('1 $db');
    //var res = await db.rawQuery('wallet_database');
    var res = await db.rawQuery('wallet_database').then((res) {
      log.w('res $res');
    });
    log.w('2 res');
    List<Test> list =
        res.isNotEmpty ? res.map((f) => Test.fromMap(f)).toList() : [];
    print('3 res');
    print('4 list');
    return list;
  }

  deleteDb() async {
    log.w(path);
    await deleteDatabase(path).then((res) {
      return res;
    }).catchError((error) {
      log.e(error);
    });
  }

  Future closeDb() async {
    var db = await database;
  }

  Future readData() async {
    //  final Database db;
  }

  Future insertTest(Test test) async {
    // var res = await db.insert(_databaseName, test.toMap(),
    //     conflictAlgorithm: ConflictAlgorithm.replace);
    // return res;
  }
}
