import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendor/ApiBloc/ApiBloc_bloc.dart';
import 'package:vendor/ApiBloc/ApiBloc_event.dart';
import 'package:vendor/LoginScreen/LoginPage.dart';
import 'package:vendor/commons/AuthUtils.dart';
import 'package:vendor/myWidgets/BackgroundWidget.dart';
import 'package:vendor/myWidgets/HomeMainTab.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SharedPreferences sharedPreferences;
  ApiBlocBloc auth;
  bool letMeDecide = false;
  bool threeSecOver = false;
  String authToken;

  startTime() async {
    var duration = new Duration(seconds: 3);
    return new Timer(duration, navigationPage);
  }

  void navigationPage() {
    print("3 sec over and $threeSecOver and $letMeDecide");
    threeSecOver = true;
    if (letMeDecide) {
      if (authToken == null) {
        Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
      } else {
        Navigator.of(context).pushReplacementNamed(HomeMainTab.routeName);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // new FirebaseNotifications().setUpFirebase();
    startTime();
    fetchSessionAndNavigate();
  }

  @override
  Widget build(BuildContext context) {
    auth = BlocProvider.of<ApiBlocBloc>(context);
    return Stack(
      children: <Widget>[
        BackgroundWidget(fromSplash: true,),
        logoBuilder(),
      ],
    );
  }

  Center logoBuilder() {
    return new Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Container(
          color: Colors.transparent,
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: new Image.asset(
                      'assets/images/only_white_borders.png'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void fetchSessionAndNavigate() async {
    sharedPreferences = await SharedPreferences.getInstance();
    authToken = AuthUtils.getToken(sharedPreferences);
    print("we got token $authToken");
    if (authToken != null) {
      auth.add(TokenGenerateEvent(authToken));
    }
    letMeDecide = true;
    print("fetchSessionAndNavigate and $threeSecOver and $letMeDecide");
    if (threeSecOver) {
      if (authToken == null) {
        Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
      } else {
        Navigator.of(context).pushReplacementNamed(HomeMainTab.routeName);
      }
    }
  }
}
