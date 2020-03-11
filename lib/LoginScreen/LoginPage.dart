import 'package:flutter/material.dart';
import 'package:vendor/LoginScreen/LoginFormV1.dart';
import 'package:vendor/myWidgets/HomeMainTab.dart';

typedef ClickCallback = void Function();

class LoginPage extends StatefulWidget {
  static const String routeName = "/login";
  @override
  State<StatefulWidget> createState() => new _LoginPage();
}

class _LoginPage extends State<LoginPage> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginFormV1(callback: () {
        Navigator.of(context).pushNamed(HomeMainTab.routeName);
      }),
    );
  }
}
