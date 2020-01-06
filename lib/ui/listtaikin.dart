import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import "package:intl/intl.dart";
import 'package:intl/date_symbol_data_local.dart';

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
  var yearwork;
  var monthwork;
  var daywork;
  var dayworklist = [];
  var enterwork;
  var outwork;
  var yearformat;
  var monthformat;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('勤怠一覧'),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: _ListtimedateState(),
        ));
  }

  Future<List<FetchDatafromSQLite>> sendtimeworkDatabase(data, flag) async {
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
      databaseReference
          .reference()
          .child('users')
          .child(user.uid)
          .child('timework').update({
            'flag' : flag
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
        padding: EdgeInsets.all(5.0),
        decoration: new BoxDecoration(
          boxShadow: [
            new BoxShadow(
              color: Colors.grey,
              blurRadius: 10.0,
            ),
          ],
        ),
        child: FutureBuilder<List<FetchDatafromSQLite>>(
          future: db.getManager(),
          builder: (context, snapshot) {
            var datas = snapshot.data;
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: datas.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (datas[index].nowWorkenter != "" &&
                        datas[index].nowWorkout != "") {
                      yearwork = datas[index].ymdWork.substring(0, 4);
                      if (monthwork != datas[index].ymdWork.substring(4, 6)) {
                        monthwork = datas[index].ymdWork.substring(4, 6);
                        return SingleChildScrollView(
                            padding: EdgeInsets.all(10.0),
                            child: Container(
                              child: Card(
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      color: Color(0xff00bfa5),
                                      width: MediaQuery.of(context).size.width,
                                      child: Text(
                                        '$yearwork年$monthwork月',
                                        style: new TextStyle(
                                            fontSize: 27.0,
                                            color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height -
                                              350,
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.all(2.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: <Widget>[
                                                Flexible(
                                                  child: Container(
                                                  height: 50.0,
                                                  padding: EdgeInsets.only(
                                                      top: 15.0),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5.0),
                                                      color: Colors.cyan[100]),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width,
                                                  child: Text(
                                                    '日付',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                  flex: 1,

                                                ),
                                                Flexible(
                                                  child: Container(
                                                  height: 50.0,
                                                  padding: EdgeInsets.only(
                                                      top: 15.0),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(30.0),
                                                      color: Colors.cyan[100]),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width,
                                                  child: Text(
                                                    '出勤の時間',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                flex: 2,
                                                ),
                                                Flexible(
                                                  child: 
                                                  Container(
                                                  height: 50.0,
                                                  padding: EdgeInsets.only(
                                                      top: 15.0),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(30.0),
                                                      color: Colors.cyan[100]),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width,
                                                  child: Text(
                                                    '退勤の時間',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                flex: 2,
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                              padding: EdgeInsets.all(2.0),
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height -
                                                  500.0,
                                              child: ListView.builder(
                                                itemCount: datas.length,
                                                itemBuilder: (context, count) {
                                                  // format datetime to japan timezone
                                                  initializeDateFormatting(
                                                      "ja_JP");
                                                  yearformat = datas[count]
                                                      .ymdWork
                                                      .substring(0, 4);
                                                  monthformat = datas[count].ymdWork.substring(4, 6);
                                                  daywork = datas[count]
                                                      .ymdWork
                                                      .substring(6);
                                                  DateTime credatetime =
                                                      new DateTime(
                                                          int.parse(yearformat),
                                                          int.parse(
                                                              monthformat),
                                                          int.parse(daywork));
                                                  var formatter =
                                                      new DateFormat(
                                                          'yyyy年MM月dd日(E)',
                                                          "ja_JP");
                                                  var datetimeformat = formatter
                                                      .format(credatetime);
                                                  var dateformat =
                                                      datetimeformat.substring(
                                                          8); // format to only date
                                                  print('this is format : ' +
                                                      dateformat);
                                                  enterwork =
                                                      datas[count].nowWorkenter;
                                                  outwork =
                                                      datas[count].nowWorkout;
                                                  return (datas[count]
                                                              .ymdWork
                                                              .substring(4, 6)
                                                              .toString() ==
                                                          monthwork)
                                                      ? 
                                                          Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                            Flexible(
                                                              child: Container(
                                                                width: MediaQuery.of(context).size.width,
                                                                child: Text('$dateformat',
                                                                textAlign: TextAlign.center
                                                                ),
                                                              ),
                                                              flex: 1,
                                                            ),
                                                            Flexible(
                                                              child: Container(
                                                                width: MediaQuery.of(context).size.width,
                                                                child: Text('$enterwork',
                                                                textAlign: TextAlign.center
                                                                ),
                                                              ),
                                                              flex: 2,
                                                            ),
                                                            Flexible(
                                                              child:  Container(
                                                                width: MediaQuery.of(context).size.width,
                                                                child: Text('$outwork',
                                                                textAlign: TextAlign.center,
                                                                ),
                                                              ),
                                                              flex: 2,
                                                            )
                                                          ],
                                                        )
                                                      : SizedBox(
                                                          height: 0.0,
                                                        );
                                                },
                                              )),
                                          Row(
                                            children: <Widget>[
                                              Flexible(
                                                child: Container(
                                                  width: MediaQuery.of(context).size.width,
                                                ),
                                                flex: 1,
                                              ),
                                              Flexible(
                                                child: Container(
                                            child: RaisedButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        100.0),
                                                side: BorderSide(
                                                    color: Colors.red)
                                                    ),
                                            color: Colors.white70,
                                            child: Row(
                                              children: <Widget>[
                                                IconButton(
                                                  iconSize: 5.0,
                                                  icon: new Image.asset(
                                                      "assets/img/excelicon.png"),
                                                ),
                                                Text('EXCEL提出')
                                              ],
                                            ),
                                            onPressed: () {
                                              var sendyear = datas[index].ymdWork.substring(0, 4).toString(); 
                                              var sendmonth = datas[index].ymdWork.substring(4, 6).toString();
                                              var sendyearmonth = sendyear + sendmonth;
                                              db.getManager().then((results) {
                                                for (var result in results) {
                                                  if(result.ymdWork.substring(0,6) == sendyearmonth){
                                                    sendtimeworkDatabase(result,sendyearmonth);
                                                  }
                                                }
                                              });
                                            },
                                          ),
                                          ),
                                                flex: 3,
                                              ),
                                              Flexible(
                                                child: SizedBox(width: 0.0,),
                                                flex: 1,
                                              ),
                                            ],
                                          )
                                          
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ));
                      }
                    }
              return SizedBox(height: 0.0,);
                  });
            } else {
              return CircularProgressIndicator();
            }
          },
        ));
  }
}
