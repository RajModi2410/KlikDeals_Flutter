import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klik_deals/CouponCode/CouponBloc.dart';
import 'package:klik_deals/History_bloc.dart';
import 'package:klik_deals/LoginScreen/LoginPage.dart';
import 'package:klik_deals/ProfileScreen/Profile_bloc.dart';
import 'package:klik_deals/commons/Auth/Auth_bloc.dart';
import 'package:klik_deals/commons/Auth/index.dart';
import 'package:klik_deals/commons/AuthUtils.dart';
import 'package:klik_deals/commons/Routes.dart';
import 'package:klik_deals/commons/locator.dart';
import 'package:klik_deals/splash_screen/splashScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ApiBloc/ApiBloc_bloc.dart';
import 'ApiBloc/repositories/ApiBloc_repository.dart';
import 'commons/NavigationService.dart';

// Must be top-level function
_parseAndDecode(String response) {
  return jsonDecode(response);
}

parseJson(String text) {
  return compute(_parseAndDecode, text);
}

AuthBloc authBloc;

void main() {
  setupLocator();
  var dio = Dio();
  (dio.transformer as DefaultTransformer).jsonDecodeCallback = parseJson;
  ApiBlocRepository apiBlocRepo = ApiBlocRepository(onRevoke: () {
    print("we are here 32 ${authBloc == null}");
    clearThings();
    // authBloc?.add(TokenExpiredEvent());
  });

  runApp(MultiBlocProvider(
      providers: [
        BlocProvider<ApiBlocBloc>(
            builder: (context) => ApiBlocBloc(apiBlocRepo)),
        BlocProvider<HistoryBloc>(
            builder: (context) => HistoryBloc(apiBlocRepo)),
        BlocProvider<ProfileBloc>(
            builder: (context) => ProfileBloc(apiBlocRepo)),
        BlocProvider<CouponBloc>(
            builder: (context) => CouponBloc(apiBlocRepo)),
        BlocProvider<AuthBloc>(builder: (context) => AuthBloc())
      ],
      child: MaterialApp(
        //        theme: myTheme,
        navigatorKey: locator<NavigationService>().navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            cursorColor: Colors.black,
            fontFamily: "Montserrat",
            primaryColor: Color(0xffAF201A),
            errorColor: Color(0xffAF201A),
            buttonColor: Color(0xffAF201A),
            textTheme: TextTheme(
                //Theme for Toolbar Text. It is global style. If need to update for single page
                //than please change in that page only.
                title: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                subtitle: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ))),
        home: Stack(
          children: <Widget>[
            AuthPage(simples: (AuthBloc _authBloc) {
              authBloc = _authBloc;
            }),
            SplashScreen()
          ],
        ),

        initialRoute: "/",
        onGenerateRoute: RouteGenerator.generateRoute,
        // routes: <String, WidgetBuilder>{
        //   '/HomeScreen': (BuildContext context) => new LoginPage(),
        // }
      )));
}

void clearThings() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool removed = await prefs.remove(AuthUtils.authTokenKey);
  print("reved the token : $removed");
  locator<NavigationService>().navigateTo(LoginPage.routeName);
}
