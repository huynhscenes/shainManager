import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:wifi/wifi.dart';

class manageEmp  extends StatefulWidget {
  @override
  State createState() => manageEmpState();
}

class manageEmpState extends State<manageEmp> {
  String ssid;

  String ip;

  @override
  void initState() {
    super.initState();
    checkWifiSSID();
  }
  @override
  Widget build(BuildContext context) {

    return Material(
        child: Column(
          children: <Widget>[
            Text('SSID is : ' + ssid),
            Text('IPaddress is : ' + ip),
          ],

        ),
    );
  }

    checkWifiSSID() async{
        ssid = await Wifi.ssid;

        ip = await Wifi.ip;

        var result = await Wifi.connection('ssid', 'password');
        print('this is ssid : ' + ssid);
        print('this is ip : ' + ip);
        print('this is result : ' + result.toString());

       var connectivityResult = await (Connectivity().checkConnectivity());
       if (connectivityResult == ConnectivityResult.mobile) {
           print('aaaa');

           // I am connected to a mobile network.
       } else if (connectivityResult == ConnectivityResult.wifi) {
           print('bbbb');
           // I am connected to a wifi network.
       }


  }
}
