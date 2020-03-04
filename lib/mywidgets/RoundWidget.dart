import 'package:flutter/material.dart';

class RoundWidget extends StatefulWidget {
  @override
  _RoundWidgetState createState() => _RoundWidgetState();
}

class _RoundWidgetState extends State<RoundWidget> {
  @override
  Widget build(BuildContext context) {
       return Center(
        child: CircularProgressIndicator()//Loading(indicator: BallSpinFadeLoaderIndicator(), size: 100.0, color: Colors.black),
      );
  }
}