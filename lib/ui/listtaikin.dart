import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:the_gorgeous_login/sqllite/fetchdata.dart';

class _Listtaikin extends StatefulWidget {
  @override
   State createState() => _ListtaikinState(new AppModel());
}

class _ListtaikinState extends State<_Listtaikin> {
  AppModel model;
  _ListtaikinState(this.model);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('勤怠一覧'),
      ),
      body: Container(
        child: _Listtimedate(model.itemListing),
      )
      );
  }
  Widget _Listtimedate(List<FetchDatafromSQLite> sqldata){
    for(var data in sqldata){
      _ListtaikinState(model);

    }
  Widget _ListtimedateState(data){
      return Container(
        child: Column(
          children: <Widget>[
            Text('2019年02月'),
            Row(
              children: <Widget>[
                Container(
                  child: Text('出勤の時間'),
                ),
                Container(
                  child: Text('退勤の時間'),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Text('1日'),
                Text('9時00分'),
                Text('19時20分')
              ],
            ),
          ],
        ),
      );

  }
  }
}
