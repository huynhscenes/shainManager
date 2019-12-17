import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

// import 'package:the_gorgeous_login/sqllite/fetchdata.dart';
import 'package:the_gorgeous_login/sqllite/database_helper.dart';
import 'package:the_gorgeous_login/sqllite/model/fetchdata.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class listtaikin extends StatefulWidget {
  @override
  State createState() => _ListtaikinState();
}

class _ListtaikinState extends State<listtaikin> {
  FetchDatafromSQLite fetchDatafromSQLite;
  var db = new DatabaseHelper();
  var nowyear = '';
  var nowmonth = '';
  var nowday = '';
  var datetimenow;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('勤怠一覧'),
          actions: <Widget>[
            RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(100.0),
                  side: BorderSide(color: Colors.red)),
              color: Colors.greenAccent,
              child: Row(
                children: <Widget>[
                  IconButton(
                    iconSize: 5.0,
                    icon: new Image.asset("assets/img/excelicon.png"),
                  ),
                  Text('EXCEL提出')
                ],
              ),
              onPressed: () {
                db.getManager().then((results) {
                  print(results);
                  for (var result in results) {
                    sendtimeworkDatabase(result);
                  }
                });
              },
            )
          ],
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height >= 775.0
              ? MediaQuery.of(context).size.height
              : 775.0,
          child: _ListtimedateState(),
        ));
  }

  Future<List<FetchDatafromSQLite>> sendtimeworkDatabase(data) async {
    final databaseReference = FirebaseDatabase.instance.reference();
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user.uid != null) {
      databaseReference
          .reference()
          .child('users')
          .child(user.uid)
          .child('timework')
          .child(data.ymdWork)
          .update({
        'id': data.id,
        'ymdWork': data.ymdWork,
        'enterbutton': data.enterbutton,
        'outbutton': data.outbutton,
        'imgdirenter': data.imgdirenter,
        'imgdirout': data.imgdirout,
        'nowWorkenter': data.nowWorkenter,
        'nowWorkout': data.nowWorkout
      });
      print("時刻を更新しました");
    }
  }

  @override
  Widget _ListtimedateState() {
    datetimenow = new DateTime.now();
    nowyear = datetimenow.year.toString();
    nowmonth = datetimenow.month.toString();

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.yellow,
            child: Text('$nowyear年$nowmonth月',
                style: new TextStyle(fontSize: 20.0, color: Colors.green)),
          ),
          Container(
            width: MediaQuery.of(context).size.width - 30.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  height: 50.0,
                  padding: EdgeInsets.only(top: 15.0),
                  decoration: BoxDecoration(border: Border.all()),
                  width: MediaQuery.of(context).size.width - 270.0,
                  child: Text(
                    '出勤の時間',
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  height: 50.0,
                  padding: EdgeInsets.only(top: 15.0),
                  decoration: BoxDecoration(border: Border.all()),
                  width: MediaQuery.of(context).size.width - 270.0,
                  child: Text(
                    '退勤の時間',
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 100.0,
            child: FutureBuilder<List<FetchDatafromSQLite>>(
              future: db.getManager(),
              builder: (context, snapshot) {
                var datas = snapshot.data;
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: datas.length,
                      itemBuilder: (BuildContext context, int index) {
                        var datework = datas[index].ymdWork.substring(6);
                        var enterwork = datas[index].nowWorkenter;
                        var outwork = datas[index].nowWorkout;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('$datework日'),
                            // SizedBox(
                            //   width: 30.0,
                            // ),
                            Text('$enterwork'),
                            SizedBox(width: 10.0,),
                            Text('$outwork'),
                            SizedBox(width: 30.0,)
                          ],
                        );
                      });
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListtime(data) {
    ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, int index) {
        var datework = data[index].ymdWork.substring(6);
        var enterwork = data[index].nowWorkenter;
        var outwork = data[index].nowWorkout;
        return Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: 30.0,
                  height: 50.0,
                ),
                Text('$datework日'),
                SizedBox(
                  width: 30.0,
                ),
                Text('$enterwork'),
                SizedBox(
                  width: 50.0,
                ),
                Text('$outwork')
              ],
            ),
          ],
        );
      },
    );
  }
}
