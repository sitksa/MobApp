import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/logopng.png',
        width: MediaQuery.of(context).size.width / 1.5,
      ),
    );
  }
}
