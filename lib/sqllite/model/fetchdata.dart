class FetchDatafromSQLite {
  int id;
  String ymdWork;
  bool enterbutton;
  bool outbutton;
  String imgdirenter;
  String imgdirout;
  String nowWorkenter;
  String nowWorkout;
  FetchDatafromSQLite(
     this.id,
      this.ymdWork,
      this.enterbutton,
      this.outbutton,
      this.imgdirenter,
      this.imgdirout,
      this.nowWorkenter,
      this.nowWorkout);
  int get _id => id;
  String get _ymdWork => ymdWork;
  bool get _enterbutton => enterbutton;
  bool get _outbutton => outbutton;
  String get _imgdirenter => imgdirenter;
  String get _imgdirout =>  imgdirout;
  String get _nowWorkenter => nowWorkenter;
  String get _nowWorkout => nowWorkout;

  Map<String, dynamic> toMap(){
    var map = new Map<String,dynamic>();
    map["id"] = _id;
    map["ymdWork"] = _ymdWork;
    map["enterbutton"] = _enterbutton;
    map["outbutton"] = _outbutton;
    map["imgdirenter"] = _imgdirenter;
    map["imgdirout"] = _imgdirout;
    map["nowWorkenter"] = _nowWorkenter;
    map["nowWorkout"] = _nowWorkout;
    
    return map;
  }

  void setManagerId(int id){
    this.id = id;
  }

}