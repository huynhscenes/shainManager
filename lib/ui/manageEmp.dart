import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:wifi/wifi.dart';

class manageEmp  extends StatefulWidget {
  @override
  State createState() => manageEmpState();
}

class manageEmpState extends State<manageEmp> {

    @override
  Widget build(BuildContext context) {

    return Material(
        child: Center(
            child: IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: (){
//                        openmenu(context);
                        checkWifiSSID();
                    }),
        )
    );
  }

    checkWifiSSID() async{
        String ssid = await Wifi.ssid;

        String ip = await Wifi.ip;

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
