import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_gorgeous_login/services/authentication.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:collection/collection.dart';
import 'package:the_gorgeous_login/ui/chat.dart';
import 'package:loading/loading.dart';

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
  var listdataback = [];
  var listdata = [];
  var maxdatechat = [];
  String newmess;
  FirebaseUser user;

  @override
  void initState() {
    final databaseReference = FirebaseDatabase.instance.reference();
    databaseReference.child('users').once().then((snapshot) {
      if (listdata.length == 0) {
        Map<dynamic, dynamic> datas = snapshot.value;
        setState(() {
          for (var data in datas.values) {
            UserList userList = new UserList();
            userList.useremail = data['email'];
            userList.useravatar = data['avatar'];
            userList.username = data['name'];
            listdata.add(userList);
            listdataback.add(userList);
            fetchnewmess();
          }
        });
      }
    });
    super.initState();
  }

  fetchnewmess() async {
    user = await FirebaseAuth.instance.currentUser();
    return user;
  }

  Future<void> choiceperson(data, datanickname, dataavatar) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Chat(
                user: user,
                data: data,
                datanickname: datanickname,
                dataavatar: dataavatar)));
  }

  listviewuser() {
    fetchnewmess();
    return Container(
      padding: EdgeInsets.all(40.0),
      child: ListView.builder(
        itemCount: listdata.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: <Widget>[
              SizedBox(
                height: 30.0,
              ),
              ListTile(
                title: Text(listdata[index].username),
                leading: CircleAvatar(
                  radius: 30.0,
                  backgroundImage: NetworkImage(listdata[index].useravatar),
                ),
                onTap: () {
                  choiceperson(listdata[index].useremail,
                      listdata[index].username, listdata[index].useravatar);
                },
                subtitle: StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('messages')
                      .orderBy('date')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                                          UserList userList = new UserList();
                    String userto =
                        user.email.toString() + listdata[index].useremail;
                    String touser =
                        listdata[index].useremail + user.email.toString();
                      var values = snapshot.data.documents;
                      for (var item in values) {
                        if (item.data['to'] == userto) {
                          newmess = item.data['text'];
                          userList.usermess = newmess;
                          print(newmess);
                        } else if (item.data['to'] == touser) {
                          newmess = item.data['text'];
                          print(newmess);
                          userList.usermess = newmess;
                        } else {
                          newmess = '';
                          new Loading();
                        }
                      }

                      return Text(userList.usermess != null ? 'メッセージ：' + userList.usermess:'' );
                    } else if (snapshot.data == null) {
                      return Loading();
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void fillout(String query) {
    var dummySearchList = [];
    dummySearchList.addAll(listdata);
    if (query != "") {
      var dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.username.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        listdata.clear();
        listdata.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        listdata.clear();
        listdata.addAll(listdataback);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: TextFormField(
          onChanged: (value) {
            fillout(value);
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
        )),
        body: listviewuser());
  }
}

class UserList {
  String username;
  String useremail;
  String useravatar;
  String usermess;
  UserList({this.username, this.useremail, this.useravatar, this.usermess});
}
