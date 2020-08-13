import 'package:flutter/material.dart';

import '../database/globle.dart';
import 'logo.dart';

class SplashBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Positioned(top: 0, bottom: 0, left: 0, right: 0, child: Logo()),
          Positioned(
            bottom: 50,
            right: 0,
            left: 0,
            child: myCircularProgressIndicator(),
          ),
        ],
      ),
    );
  }
}
