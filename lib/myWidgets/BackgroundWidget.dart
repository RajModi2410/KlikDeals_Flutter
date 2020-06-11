import 'package:flutter/material.dart';

class BackgroundWidget extends StatelessWidget {
  bool fromSplash = false;

  BackgroundWidget({this.fromSplash, Key key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      color: fromSplash ? Color(0xffE81432) : Colors.white,
      foregroundDecoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/category_background.png'),
              fit: BoxFit.cover)),
    );
  }
}
