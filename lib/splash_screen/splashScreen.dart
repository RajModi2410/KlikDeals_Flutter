import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klik_deals/mywidgets/BackgroundWidget.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    var duration = new Duration(seconds: 3);
    return new Timer(duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/HomeScreen');
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
      BackgroundWidget(),
      logoBuilder(),
      ],
    );
  }

  Center logoBuilder() {
    return new Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: new Image.asset('assets/images/logo.png'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}