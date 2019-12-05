import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

var data1 = [
  {
  "id":1,
  "ymdWork":"20191201",
  "enterbutton":false,
  "outbutton":false,
  "imgdirenter":"assets/img/enter.gif",
  "imgdirout":"assets/img/out.gi",
  "nowWorkenter":"19時23分",
  "nowWorkout":"19時30分",
},
{
  "id":2,
  "ymdWork":"20191202",
  "enterbutton":false,
  "outbutton":false,
  "imgdirenter":"assets/img/enter.gif",
  "imgdirout":"assets/img/out.gi",
  "nowWorkenter":"13時23分",
  "nowWorkout":"14時30分",
}
];
class timelineWork {
  final int id;
  final String ymdWork;
  final bool enterbutton;
  final bool outbutton;
  final String imgdirenter;
  final String imgdirout;
  final String nowWorkenter;
  final String nowWorkout;
  timelineWork({this.id,this.ymdWork,this.enterbutton,this.outbutton,this.imgdirenter,this.imgdirout,this.nowWorkenter,this.nowWorkout});
}