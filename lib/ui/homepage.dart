import 'package:flutter/material.dart';
import 'package:the_gorgeous_login/services/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:the_gorgeous_login/ui/chat.dart';
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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase.instance.reference();
  FirebaseUser user;
  var userdatabase;
  String nicknameDB;

//  @override
//  void initState() {
//    super.initState();
//    initUser();
//  }
//
//  initUser() async {
//    user = await _auth.currentUser();
//    userdatabase = await databaseReference.child('users').once().then((snapshot){
//              var values = snapshot.value;
//          print('test 1' + snapshot.value.toString());
//          values.forEach((key,value){
//            if(user.uid == value['userUID']){
//              print(value['name']);
//                nicknameDB = value['name'];
//            }
//    });
//
//    });
//    print('test 2' + nicknameDB);
//    print('test 3 ' + user.uid.toString());
//    setState(() {});
//  }

  String nickname;

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'TheGorgeousLogin',
      home: new Scaffold(
        key: _key,
        appBar: AppBar(
            title: Text(' HOME '),
            leading: IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: (){
//                        openmenu(context);
                        _key.currentState.openDrawer();
            }),
        ),
        body: Center(
          child: Text('hello world !!!'),
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
                      DrawerHeader(
                          child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                  Container(
                                      height: 120.0,
                                      width: 120.0,
                                      margin: EdgeInsets.only(left: 50.0,right: 50.0),
                                      decoration:  BoxDecoration(
                                              shape: BoxShape.circle,
                                              image:  DecorationImage(image: new ExactAssetImage('assets/img/avatar.jpg'),
                                                      fit: BoxFit.cover)
                                      ),
                                  ),
                                  Container(
//                                      height: .0,
//                                      child:Text(nicknameDB),
                                            
                                  ),
                              ],

                          ),
                      ),
                      ListTile(
                          title: Text('Item 1'),
                          onTap: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => manageEmp()),
                              );
                          },
                      ),
                      ListTile(
                          title: Text('Item 2'),
                          onTap: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => Chat()),
                              );
                          },
                      ),
                      ListTile(
                          title: Text('Item 3'),
                          onTap: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => receiptPhoto()),
                              );
                          },
                      )
                  ],
              ),

      );
  }

}