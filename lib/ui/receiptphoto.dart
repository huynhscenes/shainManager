import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:the_gorgeous_login/services/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';


class receiptPhoto extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
                primarySwatch: Colors.blue,
            ),
            home: MyHomePage(title: 'Image Picker Demo'),
        );
    }
}

class MyHomePage extends StatefulWidget {
    MyHomePage({Key key, this.title,this.auth}) : super(key: key);
    final BaseAuth auth;

    final String title;

    @override
    _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
    //final ImagePicker _imagePicker = ImagePickerChannel();

    File _imageFile;

    Future<void> captureImage(ImageSource imageSource) async {
        try {
            final imageFile = await ImagePicker.pickImage(source: imageSource);
            setState(() {
                _imageFile = imageFile;
            });
        } catch (e) {
            print(e);
        }
    }

    Future<String> sendimageDatabase(url) async {
        final databaseReference = FirebaseDatabase.instance.reference();
        FirebaseUser user = await FirebaseAuth.instance.currentUser();
        if(user.uid != null){
            databaseReference.child('users').child(user.uid).update({
                'photo': url
            });
        }
    }



    Widget _buildImage() {
        if (_imageFile != null) {
            return Image.file(_imageFile);
        } else {
            return Text('Take an image to start', style: TextStyle(fontSize: 18.0));
        }
    }

    @override
    Widget build(BuildContext context) {
        final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
        Future uploadPic(BuildContext context) async{
            String fileName = basename(_imageFile.path);
            StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
            StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
            StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;

            var imageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
            String url = imageUrl.toString();

            sendimageDatabase(url);

            setState(() {
                print("画像を更新しました");
                Scaffold.of(context).showSnackBar(SnackBar(content: Text('画像を更新しました')));
            });

        }
        return new Scaffold(
            appBar: AppBar(
                title: Text(widget.title),
            ),
            body: Builder(
                builder: (context)=>Container(
        child: Column(

                children: [
                    Expanded(child: Center(child: _buildImage())),
                    RaisedButton(
                        color: Color(0xfffb4747),
                        onPressed: (){
                            uploadPic(context);

                        },
                        child: Text(
                            'Submit',
                            style: TextStyle(color: Colors.white,fontSize: 16.0),
                        ),

                    ),
                    _buildButtons(),
                ],
        )
        )

            ),
        );
    }

    Widget _buildButtons() {
        return ConstrainedBox(
                constraints: BoxConstraints.expand(height: 80.0),
                child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                            _buildActionButton(
                                key: Key('retake'),
                                text: 'Photos',
                                onPressed: () => captureImage(ImageSource.gallery),
                            ),
                            _buildActionButton(
                                key: Key('upload'),
                                text: 'Camera',
                                onPressed: () => captureImage(ImageSource.camera),
                            ),
                        ]));
    }

    Widget _buildActionButton({Key key, String text, Function onPressed}) {
        return Expanded(
            child: FlatButton(
                    key: key,
                    child: Text(text, style: TextStyle(fontSize: 20.0)),
                    shape: RoundedRectangleBorder(),
                    color: Colors.blueAccent,
                    textColor: Colors.white,
                    onPressed: onPressed),
        );
    }
}
