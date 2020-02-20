import 'package:flutter/material.dart';
import 'package:klik_deals/LoginScreen/LoginFormV1.dart';
import 'package:klik_deals/mywidgets/HomeMainTab.dart';

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
