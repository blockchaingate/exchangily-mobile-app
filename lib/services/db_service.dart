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

  initDb() async {
    databasePath = await getDatabasesPath();
    path = join(databasePath, _databaseName);
    log.w(path);
    _database = await openDatabase(path,
        version: _databaseVersion,
        onCreate: onCreate(_database, _databaseVersion));
    log.e(_database);
    return _database;
  }

  FutureOr<void> onCreate(Database db, int version) async {
    log.e('in on create $db');
    await db.execute(
        "CREATE TABLE $_databaseName(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, age INTEGER)");
    // await db.rawInsert('INSERT INTO testDB (name, age) VALUES ("Barry", 10)');
    // await db.rawInsert('INSERT INTO testDB (name, age) VALUES ("Ken", 11)');
    // await db.rawInsert('INSERT INTO testDB (name, age) VALUES ("Paul", 27)');
  }

  Future<List<Test>> getAll() async {
    final Database db = DataBaseService._database;
    log.w(db);
    var res = await db.rawQuery(_databaseName);
    log.w(res);
    List<Test> list =
        res.isNotEmpty ? res.map((f) => Test.fromMap(f)).toList() : [];
    print(res);
    print(list);
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

  closeDb() async {}

  Future readData() async {
    //  final Database db;
  }

  Future insertTest(Test test) async {
    // var res = await db.insert(_databaseName, test.toMap(),
    //     conflictAlgorithm: ConflictAlgorithm.replace);
    // return res;
  }
}
