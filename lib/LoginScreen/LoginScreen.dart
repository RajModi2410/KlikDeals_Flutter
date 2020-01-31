import 'package:flutter/material.dart';

import 'LoginForm.dart';
import 'Login_page.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPage();
}

class _LoginPage extends State<LoginPage> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginFormV1(),
    );
  }
}

