import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_gorgeous_login/services/authentication.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:collection/collection.dart';
import 'package:the_gorgeous_login/ui/chat.dart';

class choicechat extends StatefulWidget {
  final BaseAuth auth;
  choicechat({Key key, this.auth}) : super(key: key);

  @override
  _choicechatState createState() => _choicechatState();
}

class _choicechatState extends State<choicechat> {
  TextEditingController editingController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;
  // var listusers = [];
  var userschat = [];
  var useravatar = [];
  List<String> usernickname = [];
  var listdata = [];

  @override
  void initState() {
    final databaseReference = FirebaseDatabase.instance.reference();
    databaseReference.child('users').once().then((snapshot) {
      if (userschat.length == 0) {
        List<Map> values  = snapshot.value;
        setState(() {
          values.map((data){
            UserList userList = new UserList();
            userList.useremail = data['email'];
            userList.useravatar = data['avatar'];
            userList.username = data['name'];
            listdata.add(userList);

          });
          // values.forEach((key, values) {
          //   userschat.add(values['email']);
          //   useravatar.add(values['avatar']);
          //   usernickname.add(values['name']);
          //   listdata.add(snapshot.value[key]);
          // });
        });
      }
    });
    super.initState();
  }

  Future<void> choiceperson(data, datanickname,dataavatar) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return Navigator.push(context,
        MaterialPageRoute(builder: (context) => Chat(user: user, data: data,datanickname:datanickname,dataavatar:dataavatar)));
  }

  listviewuser() {
    return Container(
      padding: EdgeInsets.all(40.0),
      child: ListView.builder(
        itemCount: usernickname.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: <Widget>[
              SizedBox(
                height: 30.0,
              ),
              ListTile(
                title: Text(usernickname[index]),
                leading: CircleAvatar(
                  radius: 30.0,
                  backgroundImage: NetworkImage(useravatar[index]),
                ),
                onTap: () {
                  choiceperson(userschat[index], usernickname[index],useravatar[index]);
                },
              ),
            ],
          );
        },
      ),
    );
  }

void filterSearchResults(String query) {
    List<String> dummySearchList = List<String>();
    dummySearchList.addAll(usernickname);
    if(query.isNotEmpty) {
      List<String> dummyListData = List<String>();
      dummySearchList.forEach((item) {
        if(item.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        usernickname.clear();
        usernickname.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        usernickname.clear();
        usernickname.addAll(listdata);
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: TextFormField(
                onChanged: (value) {
                  filterSearchResults(value);
                },
                controller: editingController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                    labelText: "Search",
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50.0))),
                    focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(color: Colors.blue)),
          filled: true,
          contentPadding:
              EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                        ),
            )
        ),
        
        body:  listviewuser());
  }
}

class UserList {
  String username;
  String useremail;
  String useravatar;
  UserList({this.username,this.useremail,this.useravatar});
}
