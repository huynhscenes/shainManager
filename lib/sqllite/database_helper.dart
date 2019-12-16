import 'dart:async';
import 'dart:io' as io;

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:the_gorgeous_login/sqllite/model/fetchdata.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if(_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async{
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'manager.db');
    var theDb = await openDatabase(path, version:1,onCreate:_onCreate);
    return theDb;

  }

  void _onCreate(Database db, int version) async {
    await db.execute('CREATE TABLE manageremps(id INTEGER PRIMARY KEY, ymdWork TEXT, enterbutton INTEGER, outbutton INTEGER, imgdirenter TEXT, imgdirout TEXT, nowWorkenter TEXT, nowWorkout TEXT)');
  }

  Future<int> insertManager(FetchDatafromSQLite fetchdata) async {
    var dbManager = await db;
    int res = await dbManager.insert("manageremps", fetchdata.toMap());
    var res1 = await _db.query("manageremps");
    return res;
  }

  Future<List<FetchDatafromSQLite>> getManager() async {
    var dbManager = await db;
    List<Map> list = await dbManager.rawQuery("SELECT * FROM manageremps");
    List<FetchDatafromSQLite> employees = new List();
    for(int i = 0; i < list.length; i++){
      var manager = new FetchDatafromSQLite(
        list[i]["ymdWork"],
        list[i]["enterbutton"] == 1 ? true : false,
        list[i]["outbutton"] == 1 ? true : false,
        list[i]["imgdirenter"],
        list[i]["imgdirout"],
        list[i]["nowWorkenter"],
        list[i]["nowWorkout"]
        );
        manager.setManagerId(list[i]["id"]);
        employees.add(manager);
    }
    print(employees.length);
    return employees;
  }

  Future<int> deleteManager(FetchDatafromSQLite fetchdata) async {
    var dbManager = await db;
    int res = await dbManager.rawDelete("DELETE FROM manageremps WHERE id = ?", [fetchdata.id]);
    return res;
  }

  Future<bool> updateManager(FetchDatafromSQLite fetchdata) async {
    var dbManager = await db;
    int res = await dbManager.update("manageremps", fetchdata.toMap(), where: "id = ?", whereArgs:<int> [fetchdata.id]);
    return res > 0 ? true : false;
  }

}
