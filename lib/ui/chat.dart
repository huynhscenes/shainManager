import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Chat extends StatefulWidget {
  static const String id = "CHAT";
  final FirebaseUser user;
  final String data;
  final String datanickname;
  final String dataavatar;

  const Chat({Key key, this.user, this.data,this.datanickname,this.dataavatar}) : super(key: key);
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;

  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();
  bool boolme = false;
  var messages = [];

  Future<void> callback() async {
    if (messageController.text.length > 0) {
      await _firestore.collection('messages').add({
        'text': messageController.text,
        'from': widget.user.email,
        'to': widget.user.email.toString() + widget.data,
        'date': FieldValue.serverTimestamp(),
      });
      messageController.clear();
//      scrollController.animateTo(
//        scrollController.position.maxScrollExtent,
//        curve: Curves.easeOut,
//        duration: const Duration(milliseconds: 300),
//      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String userto = widget.user.email.toString() + widget.data;
    String touser = widget.data + widget.user.email.toString();
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
                title: Text(widget.datanickname),
                leading: CircleAvatar(
                  radius: 30.0,
                  backgroundImage: NetworkImage(widget.dataavatar),
                ),
                subtitle: Text("Messenger"),
              ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              _auth.signOut();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('messages')
                    .orderBy('date')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  List<DocumentSnapshot> docs = snapshot.data.documents;
                  messages = [];
                  docs.map((doc) {
                    Mapdata mapdata = new Mapdata();

                    mapdata.to = doc.data['to'];
                    mapdata.from = doc.data['from'];
                    mapdata.text = doc.data['text'];
                    mapdata.boolme =
                        doc.data['from'] == widget.user.email.toString()
                            ? true
                            : false;
                    if (mapdata.to == userto) {
                      messages.add(mapdata);
                    } else if (mapdata.to == touser) {
                      messages.add(mapdata);
                    }
                  }).toList();
                  return ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Message(messages[index].from,
                            messages[index].text, messages[index].boolme);
                      });
                },
              ),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onSubmitted: (value) => callback(),
                      decoration: InputDecoration(
                        hintText: "メッセージを入力...",
                        border: const OutlineInputBorder(),
                      ),
                      controller: messageController,
                    ),
                  ),
                  SendButton(
                    text: "送信",
                    callback: callback,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Message(from, text, me) {
  return Container(
    child: Column(
      crossAxisAlignment:
          me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(5.0),
          child: me ? 
        Material(
          color: Colors.teal,
          borderRadius: BorderRadius.circular(10.0),
          elevation: 6.0,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child: Text(
              text,
            ),
          ),
        )
        :
        Row(
          children: <Widget>[
            CircleAvatar(
              radius: 20.0,
              backgroundImage: NetworkImage(widget.dataavatar),
            ),
            SizedBox(width: 10.0,),
            Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          elevation: 6.0,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
            child: Text(
              text,
            ),
          ),
        )
          ],
        ),
        ),
      ],
    ),
  );
}
}



class Mapdata {
  String to;
  String from;
  String text;
  bool boolme;
  Mapdata({this.to, this.from, this.text, this.boolme});
}

class SendButton extends StatelessWidget {
  final String text;
  final VoidCallback callback;

  const SendButton({Key key, this.text, this.callback}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: Colors.orange,
      onPressed: callback,
      child: Text(text),
    );
  }
}
