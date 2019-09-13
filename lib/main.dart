import 'package:flutter/material.dart';
import 'package:the_gorgeous_login/ui/login_page.dart';
import 'package:the_gorgeous_login/services/authentication.dart';
void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'TheGorgeousLogin',
      theme: new ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: new LoginPage(
              auth: new Auth()
      ),
    );
  }
}