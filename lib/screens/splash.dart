import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:burgernook/database/globle.dart';
import 'package:burgernook/screens/delivery/deliveryScreen.dart';
import 'package:burgernook/screens/employee/employeeScreen.dart';
import 'package:burgernook/screens/owner/ownerScreen.dart';
import 'package:burgernook/screens/user/userScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  StreamSubscription<ConnectivityResult> subscription;

  @override
  void initState() {
    super.initState();
    checkInternet();
    check();
    Timer(Duration(seconds: 4), () async {
      if (isLogin) {
        if (isEmployee) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => EmployeeScreen()));
        } else if (isUser) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => UserScreen()));
        } else if (isDelivery) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => DeliveryScreen()));
        } else if (isOwner) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => OwnerScreen()));
        }
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => UserScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(decoration: BoxDecoration(
        image:DecorationImage(
          image:AssetImage("assets/splash.jpg"),
          fit: BoxFit.fill
        )
      ),),
    );
  }

  checkInternet() async {
    ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      connected = true;
    }
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult connectivityResult) {
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        connected = true;
      } else if (connectivityResult == ConnectivityResult.none) {
        connected = false;
      } else {
        connected = false;
      }
      print('connected $connected');
    });
  }
}
