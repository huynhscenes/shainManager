import 'package:flutter/material.dart';
import 'package:the_gorgeous_login/services/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

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
                        print(nickname == null ? 'this null' : nickname);
//                        openmenu(context);
                        _key.currentState.openDrawer();
            }),
        ),
        body: Center(
          child: Text('heloo world '),
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
                                      child:Text(Accauthcurrrent().toString()),
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
                              Navigator.pop(context);
                          },
                      )
                  ],
              ),

      );
  }
  Accauthcurrrent() {
      final databaseReference = FirebaseDatabase.instance.reference();

      Future<FirebaseUser> user =  FirebaseAuth.instance.currentUser();
      var testuser;

      var currentUser = user.then((value){value.uid.toString();});

      return databaseReference.child('users').once().then((DataSnapshot snapshot){
          var values = snapshot.value;
          print('test 1' + snapshot.value.toString());
          values.forEach((key,value){

          });
      });
  }


}