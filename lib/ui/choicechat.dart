import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_gorgeous_login/services/authentication.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:collection/collection.dart';
import 'package:loading/loading.dart';
import 'package:the_gorgeous_login/ui/chat.dart';

class choicechat extends StatefulWidget {
  final BaseAuth auth;
  choicechat({Key key, this.auth}) : super(key: key);

  @override
  _choicechatState createState() => _choicechatState();
}

class _choicechatState extends State<choicechat> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;
  // var listusers = [];
  var userschat = [];

  @override
  void initState() {
    final databaseReference = FirebaseDatabase.instance.reference();
    databaseReference.child('users').once().then((snapshot) {
      if (userschat.length == 0) {
        Map<dynamic, dynamic> values = snapshot.value;
        setState(() {
          values.forEach((key, values) {
            userschat.add(values['email']);
          });
        });
      }
    });
    super.initState();
  }

  Future<void> choiceperson(data) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    await _firestore.collection('messages').document(data+user.toString()).collection('content');
    return Navigator.push(context, MaterialPageRoute(builder: (context) => Chat(user:user, data:data)));
  }

  //  listusers()  {
  //   final databaseReference = FirebaseDatabase.instance.reference();

  //    databaseReference.child('users').once().then((snapshot) {
  //     if (userschat.length == 0) {
  //       Map<dynamic, dynamic> values = snapshot.value;
  //       values.forEach((key, values) {
  //         userschat.add(values['email']);
  //       });
  //     }
  //   });

  // }

  listviewuser() {
    return ListView.builder(
      itemCount: userschat.length,
      itemBuilder: (BuildContext context, int index) {
        return Row(
          children: <Widget>[
            RaisedButton(
              child: Text(userschat[index]),
              onPressed: () {
                choiceperson(userschat[index]);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Choice User'),
        ),
        body: listviewuser());
  }
}
