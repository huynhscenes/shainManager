import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:the_gorgeous_login/services/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:the_gorgeous_login/ui/choicechat.dart';
import 'package:the_gorgeous_login/ui/receiptphoto.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:the_gorgeous_login/ui/manageEmp.dart';
import 'package:the_gorgeous_login/style/oval-right-clipper.dart';
void main() => runApp(new HomePage());
class HomePage extends StatefulWidget {
  HomePage({ this.auth});
  final BaseAuth auth;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Color primary = Colors.white;
  final Color active = Colors.grey.shade800;
  final Color divider = Colors.grey.shade600;

  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  var userdatabase;

  String nickname = "";
  var useravatar;
  String useremail = "";
  @override
  void initState() {
    // TODO: implement initState
      fetchnickname();
      super.initState();
  }
  fetchnickname() async{
      FirebaseUser usercurrent = await FirebaseAuth.instance.currentUser();
      final databaseReference = FirebaseDatabase.instance.reference();
      databaseReference.child('users').child(usercurrent.uid).once().then((snapshot) {
          setState(() {
              nickname = snapshot.value['name'];
              useravatar = snapshot.value['avatar'];
              useremail = snapshot.value['email'];
          });

      });
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text(' ホーム '),
            leading: IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: (){
//                        openmenu(context);
                        _key.currentState.openDrawer();
            }),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildHeader(),
            Container(
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade200
              ),
              child: Text("今まで、３年間ぐらい経験を持っています。モバイル系、ウェブ系、SEなど経験です。"),
            ),
            _buildTitle("スキル"),
            Container(
              child: Row(
                children: <Widget>[
                  Icon(Icons.web),
                  Text("ウェブ系 : ")
                ],
              ),
            ),
            SizedBox(height: 10.0),
            _buildSkillRow("PHP",0.75),
            SizedBox(height: 5.0),
            _buildSkillRow("HTML-CSS-JS-JQUERY-AJAX",0.5),
            SizedBox(height: 5.0),
            _buildSkillRow("MYSQL-SQLSERVER",0.65),
            SizedBox(height: 5.0),
            _buildSkillRow("PYTHON",0.6),
            Container(
              child: Row(
                children: <Widget>[
                  Icon(Icons.mobile_screen_share),
                  Text("モバイル系 : ")
                ],
              ),
            ),
            SizedBox(height: 10.0),
            _buildSkillRow("ANDROID",0.5),
            SizedBox(height: 5.0),
            _buildSkillRow("IONIC",0.6),
            SizedBox(height: 5.0),
            _buildSkillRow("Flutter",0.5),
            Container(
              child: Row(
                children: <Widget>[
                  Icon(Icons.computer),
                  Text("SE（システムエンジニア） : ")
                ],
              ),
            ),
            SizedBox(height: 10.0),
            _buildSkillRow("基本設計",0.4),
            SizedBox(height: 5.0),
            _buildSkillRow("詳細設計",0.4),
            SizedBox(height: 5.0),
            _buildSkillRow("単体テスト",0.7),
            SizedBox(height: 5.0),
            _buildSkillRow("結合テスト",0.4),
            SizedBox(height: 30.0),
            
            _buildTitle("職歴"),
            _buildExperienceRow(company: "株式会社フォイス", position: "プロジェクトによってモバイル系、ウェブ系、SEなど開発する", duration: "2017年4月 - 2019年1月"),
            _buildExperienceRow(company: "株式会社シーンズ", position: "サーバーエンジニア", duration: "2019年2月 - 現在"),

            SizedBox(height: 20.0),
            _buildTitle("学歴"),
            SizedBox(height: 5.0),
            
            _buildExperienceRow(company: "HO CHI MINH 経済大学", position: "経営", duration: "2009年 - 2011年"),
            _buildExperienceRow(company: "西日本国際教育学院", position: "日本語", duration: "2011年4月 - 2013年3月"),
            _buildExperienceRow(company: "第一工業大学", position: "情報系学部", duration: "2013年4月 - 2017年3月"),

            SizedBox(height: 20.0),
            _buildTitle("連絡先"),
            SizedBox(height: 5.0),
            Row(
              children: <Widget>[
                SizedBox(width: 30.0),
                Icon(Icons.mail, color: Colors.black54,),
                SizedBox(width: 10.0),
                Text("huynhnguyentuan91@gmail.com", style: TextStyle(
                  fontSize: 16.0
                ),),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              children: <Widget>[
                SizedBox(width: 30.0),
                Icon(Icons.phone, color: Colors.black54,),
                SizedBox(width: 10.0),
                Text("+8190-1346-7986", style: TextStyle(
                  fontSize: 16.0
                ),),
              ],
            ),
          ],
        ),
      ),
      drawer: _buildDrawer(),
    );
  }

  _buildDrawer() {
    return   ClipPath(
      clipper: OvalRightBorderClipper(),
      child:Drawer(
        child: Container(
          padding: const EdgeInsets.only(left: 16.0, right: 40),
          decoration: BoxDecoration(
              color: primary, boxShadow: [BoxShadow(color: Colors.black45)]),
          width: 300,
          child: SafeArea(
            child: ListView(
              padding: EdgeInsets.zero,
                children: <Widget>[
                  Container(
                    height: 90,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                            colors: [Colors.orange, Colors.deepOrange])),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage("$useravatar"),
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    "$nickname",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "$useremail",
                    style: TextStyle(color: active, fontSize: 16.0),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30.0),
                  _buildRow(Icons.home, "ホーム",HomePage()),
                  _buildDivider(),
                  _buildRow(Icons.calendar_today, "出勤簿",manageEmp()),
                  _buildDivider(),
                  _buildRow(Icons.message, "社内チャット", choicechat()),
                  _buildDivider(),
                  _buildRow(Icons.scanner, "領収証スキャン",
                      receiptphoto()),
                  _buildDivider()
                ],
            ),
          ),
        ),
      )
    );
  }
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  ListTile _buildExperienceRow({String company, String position, String duration}) {
    return ListTile(
      leading: Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 20.0),
        child: Icon(FontAwesomeIcons.solidCircle, size: 12.0, color: Colors.black54,),
      ),
      title: Text(company, style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold
      ),),
      subtitle: Text("$position ($duration)"),
    );
  }

  Row _buildSkillRow(String skill, double level) {
    return Row(
      children: <Widget>[
        SizedBox(width: 16.0),
        Expanded(
          flex: 2,
          child: Text(skill.toUpperCase(), textAlign: TextAlign.right,)),
        SizedBox(width: 10.0),
        Expanded(
          flex: 5,
          child: LinearProgressIndicator(
            value: level,
          ),
        ),
        SizedBox(width: 16.0),
      ],
    );
  }

  Widget _buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title.toUpperCase(), style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold
          ),),
          Divider(color: Colors.black54,),
        ],
      ),
    );
  }

  Row _buildHeader() {
    return Row(children: <Widget>[
      SizedBox(width: 20.0),
      Container(
        width: 80.0,
        height: 80.0,
        child: CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          child: CircleAvatar(
            radius: 35.0,
            backgroundImage: new AssetImage("assets/img/myavarprofile.jpg")
            )
            )),
      SizedBox(width: 20.0),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("NGUYEN TUAN HUYNH", style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold
          ),),
          Text("グェン  トゥアン　フィン", style: TextStyle(
            fontSize: 12.0,
            color: Colors.grey
          ),),
          SizedBox(height: 10.0),
          Row(
            children: <Widget>[
              Icon(FontAwesomeIcons.empire, size: 12.0, color: Colors.black54,),
              SizedBox(width: 10.0),
              Text("フルスタックエンジニア",),
            ],
          ),
          SizedBox(height: 5.0),
          Row(
            children: <Widget>[
              Icon(FontAwesomeIcons.map, size: 12.0, color: Colors.black54,),
              SizedBox(width: 10.0),
              Text("ベトナム"),
            ],
          ),
        ],
      )
    ],);
  }


  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }

  Divider _buildDivider() {
    return Divider(
      color: divider,
    );
  }

  Widget _buildRow(IconData icon, String title, nextpage) {
    final TextStyle tStyle = TextStyle(color: active, fontSize: 16.0);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(children: [
        Expanded(
          child: ListTile(
            leading: Icon(
              icon,
          color: active,
            ),
            title: Text(
          title,
          style: tStyle,
        ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => nextpage),
              );
            },
          ),
        ),
      ]),
    );
  }
}