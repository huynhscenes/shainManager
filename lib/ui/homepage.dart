import 'package:flutter/material.dart';
import 'package:the_gorgeous_login/services/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:the_gorgeous_login/ui/choicechat.dart';
import 'package:the_gorgeous_login/ui/receiptphoto.dart';

import 'manageEmp.dart';
void main() => runApp(new HomePage());

class HomePage extends StatefulWidget {
    HomePage({ this.auth});
    final BaseAuth auth;
    @override
    State createState() => new HomePageState();
}


class HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  var userdatabase;

  String nickname = "";
  var useravatar;
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
          });

      });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: '社内管理',
      home: new Scaffold(
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
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                  Text('テキスト'),
                  Text('テキスト'),
                  Text('テキスト'),
                  Text('テキスト'),
                  Text('テキスト'),
              ],
          ),
        ),
        drawer: openmenu(context),

    )
    );
  }
   openmenu(context) {
      return  Drawer(

              child: ListView(

                  padding: EdgeInsets.zero,

                  children: <Widget>[
                      Container(
                          color: Colors.blueAccent,
                          child: DrawerHeader(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                      CircleAvatar(
                                        radius: 50.0,
                                        backgroundImage: NetworkImage("$useravatar"),
                                      ),
                                      Container(
                                          color: Colors.white,
                                          child: Text('$nickname',
                                                  style: new TextStyle(fontSize: 12.0, color: Colors.green)),
                                      ),
                                  ],

                              ),
                          ),
                      ),
                      Container(
                          color: Colors.yellowAccent,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                  SizedBox(height: 30.0),
                                  Container(
                                      child: ListTile(
                                          leading: Icon(Icons.home,size: 50.0,),
                                          title: Text('ホーム'),
                                          onTap: (){
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => HomePage()),
                                              );
                                          },
                                      ),
                                      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey,width: 1.0))),
                                  ),
                                  SizedBox(height: 30.0),
                                  Container(
                                      child: ListTile(
                                          leading: Icon(Icons.calendar_today,size: 50.0,),
                                          title: Text('出勤簿'),
                                          onTap: (){
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => manageEmp()),
                                              );
                                          },
                                      ),
                                      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey,width: 1.0))),
                                  ),
                                  SizedBox(height: 30.0,),
                                  Container(

                                      child: ListTile(
                                          leading: Icon(Icons.chat_bubble,size: 50.0,),
                                          title: Text('社内チャット'),
                                          onTap: (){
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => choicechat()),
                                              );
                                          },
                                      ),
                                      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey,width: 1.0))),
                                  ),
                                  SizedBox(height: 30.0,),
                                  Container(
                                      child:
                                      ListTile(
                                          leading: Icon(Icons.scanner,size: 50.0,),
                                          title: Text('領収証スキャン'),
                                          onTap: (){
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => receiptphoto()),
                                              );
                                          },
                                      ),

                                  ),
                                  SizedBox(height: 30.0),
                              ],
                          ),
                      )

                  ],
              ),

      );
  }

}