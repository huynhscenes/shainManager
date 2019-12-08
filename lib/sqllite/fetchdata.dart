import 'dart:io';
import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:the_gorgeous_login/ui/manageEmp.dart';

var data1 = [
  {
    "id": 1,
    "ymdWork": "20191201",
    "enterbutton": false,
    "outbutton": false,
    "imgdirenter": "assets/img/enter.gif",
    "imgdirout": "assets/img/out.gi",
    "nowWorkenter": "19時23分",
    "nowWorkout": "19時30分",
  },
  {
    "id": 2,
    "ymdWork": "20191202",
    "enterbutton": false,
    "outbutton": false,
    "imgdirenter": "assets/img/enter.gif",
    "imgdirout": "assets/img/out.gi",
    "nowWorkenter": "13時23分",
    "nowWorkout": "14時30分",
  }
];

class timelineWork {
  final int id;
  final String ymdWork;
  final String enterbutton;
  final String outbutton;
  final String imgdirenter;
  final String imgdirout;
  final String nowWorkenter;
  final String nowWorkout;
  timelineWork(
      {this.id,
      this.ymdWork,
      this.enterbutton,
      this.outbutton,
      this.imgdirenter,
      this.imgdirout,
      this.nowWorkenter,
      this.nowWorkout});
}

// abstract class FetchData {
//   insertManager(data);
//   manageremp();
//   Future<void> selectManager();
// }

// fetchData() async {
//   var dbDir = await getDatabasesPath();
//   final database = openDatabase(
//     join(dbDir, 'manageremployees3.db'),
//     onCreate: (db, version) {
//       return db.execute(
//         "CREATE TABLE IF NOT EXISTS manageremps(id INTEGER PRIMARY KEY, ymdWork TEXT, enterbutton INTEGER, outbutton INTEGER, imgdirenter TEXT, imgdirout TEXT, nowWorkenter TEXT, nowWorkout TEXT);",
//       );
//     },
//     version: 1,
//   );

//   selectTableManager(database);

//   Future<void> selectManager(data) async {
//     final Database db = await database;
//     return db.query("manageremps");
//   }

//   Future<void> insertManager(FetchDatafromSQLite manager) async {
//     final Database db = await database;

//     await db.insert(
//       'manageremps',
//       manager.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );

//     var res = await db.query("manageremps");
//     print('test 2 : ' + res.toString());
//   }

//   Future<List<FetchDatafromSQLite>> manageremps() async {
//     final Database db = await database;
//     final List<Map<String, dynamic>> maps = await db.query('manageremps');
//     return List.generate(maps.length, (i) {
//       return FetchDatafromSQLite(
//         id: maps[i]['id'],
//         ymdWork: maps[i]['ymdWork'],
//         enterbutton: maps[i]['enterbutton'],
//         outbutton: maps[i]['outbutton'],
//         imgdirenter: maps[i]['imgdirenter'],
//         imgdirout: maps[i]['imgdirout'],
//         nowWorkenter: maps[i]['nowWorkenter'],
//         nowWorkout: maps[i]['nowWorkout'],
//       );
//     });
//   }

//   var fido = FetchDatafromSQLite(
//     id: 1,
//     ymdWork: '',
//     enterbutton: 0,
//     outbutton: 0,
//     imgdirenter: '',
//     imgdirout: '',
//     nowWorkenter: '',
//     nowWorkout: '',
//   );
//   await insertManager(fido);

//   print('test 1 : ' + manageremps().toString());
// }

// selectTableManager(database) async {
//   final db = await database;
//   print(db);
// }

class AppModel {
  Database _db;
  List<FetchDatafromSQLite> _data = [];
  createDB() async {
    try {
      var dbDir = await getDatabasesPath();
      var dbPath = join(dbDir, 'managerDB122113232242.db');
      _db = await openDatabase(dbPath, version: 1,
          onOpen: (Database db){
        this._db = db;
        print("OPEN DBV");
        this.createTable();
      },
          onCreate: (Database db,int version)async{
            this._db = db;
            print("DB Crated");
          });
      fetchDataManager(_db);
      return _db;
    } catch (e) {
      print('this is error database ' + e.toString());
    }
  }

  createTable() async {
    try {
      var qry =
          "CREATE TABLE manageremps(id INTEGER PRIMARY KEY, ymdWork TEXT, enterbutton INTEGER, outbutton INTEGER, imgdirenter TEXT, imgdirout TEXT, nowWorkenter TEXT, nowWorkout TEXT)";
      await this._db.execute(qry);
       var fido = FetchDatafromSQLite(
         id: 1,
         ymdWork: '',
         enterbutton: 0,
         outbutton: 0,
         imgdirenter: '',
         imgdirout: '',
         nowWorkenter: '',
         nowWorkout: '',
       );
       insertManager(fido);
      var res = await _db.query("manageremps");
      print('this is test 222222 ' + res.toString());
    } catch (e) {
      print(' this is create table ' + e.toString());
    }
  }

  insertManager(FetchDatafromSQLite fetchDatafromSQLite) async {
    try {
      await _db.insert('manageremps', fetchDatafromSQLite.toMap());
      var res = await _db.query("manageremps");
      print('this is test 111111 ' + res.toString());

    } catch (e) {
      print('this is insert ' + e.toString());
    }
  }



  fetchDataManager(_db) async {
    try {
      List<Map> listdata = await this._db.rawQuery("SELECT * FROM manageremps");
        listdata.map((data) {
          FetchDatafromSQLite fetchData = new FetchDatafromSQLite();
            fetchData.id = data['id'];
            fetchData.ymdWork = data['ymdWork'];
            fetchData.enterbutton = data['enterbutton'] == 1 ? true : false;
            fetchData.outbutton = data['outbutton'] == 1 ? true : false;
            fetchData.imgdirenter = data['imgdirenter'];
            fetchData.imgdirout = data['imgdirout'];
            fetchData.nowWorkenter = data['nowWorkenter'];
            fetchData.nowWorkout = data['nowWorkout'];
            _data.add(fetchData);
        }).toList();
    } catch (e) {
      print('this is select ' + e.toString());
    }
  }

  List<FetchDatafromSQLite> get itemListing => _data;


  updatedataManger(FetchDatafromSQLite fetchDatafromSQLite) async {
    try {
      await _db.update("manageremps", fetchDatafromSQLite.toMap());
    } catch (e) {
      print('this is update ' + e.toString());
    }

  }
}

class FetchDatafromSQLite {
  int id;
  String ymdWork;
  var enterbutton;
  var outbutton;
  String imgdirenter;
  String imgdirout;
  String nowWorkenter;
  String nowWorkout;
  FetchDatafromSQLite(
      {this.id,
      this.ymdWork,
      this.enterbutton,
      this.outbutton,
      this.imgdirenter,
      this.imgdirout,
      this.nowWorkenter,
      this.nowWorkout});

  Map<String, dynamic> toMap() => {
        "id": id,
        "ymdWork": ymdWork,
        "enterbutton": enterbutton,
        "outbutton": outbutton,
        "imgdirenter": imgdirenter,
        "imgdirout": imgdirout,
        "nowWorkenter": nowWorkenter,
        "nowWorkout": nowWorkout
      };
}
