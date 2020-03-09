import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klik_deals/ApiBloc/ApiBloc_bloc.dart';
import 'package:klik_deals/ApiBloc/ApiBloc_event.dart';
import 'package:klik_deals/LoginScreen/LoginPage.dart';
import 'package:klik_deals/commons/AuthUtils.dart';
import 'package:klik_deals/myWidgets/BackgroundWidget.dart';
import 'package:klik_deals/myWidgets/HomeMainTab.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    startTime();
    fetchSessionAndNavigate();
  }

  @override
  Widget build(BuildContext context) {
    auth = BlocProvider.of<ApiBlocBloc>(context);
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
