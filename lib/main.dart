import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klik_deals/History_bloc.dart';
import 'package:klik_deals/ProfileScreen/Profile_bloc.dart';
import 'package:klik_deals/splash_screen/splashScreen.dart';
import 'package:klik_deals/commons/Routes.dart';

import 'ApiBloc/ApiBloc_bloc.dart';
import 'ApiBloc/repositories/ApiBloc_repository.dart';

// Must be top-level function
_parseAndDecode(String response) {
  return jsonDecode(response);
}

parseJson(String text) {
  return compute(_parseAndDecode, text);
}

void main() {
  var dio = Dio();
  (dio.transformer as DefaultTransformer).jsonDecodeCallback = parseJson;
  runApp(MultiBlocProvider(
      providers: [
        BlocProvider<ApiBlocBloc>(
            builder: (context) => ApiBlocBloc(ApiBlocRepository())),
        BlocProvider<HistoryBloc>(
            builder: (context) => HistoryBloc(ApiBlocRepository())),
        BlocProvider<ProfileBloc>(
            builder: (context) => ProfileBloc(ApiBlocRepository())),
      ],
      child: MaterialApp(
//        theme: myTheme,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: "Montserrat",
          primaryColor: Color(0xffAF201A),
          errorColor: Color(0xffAF201A),
          buttonColor: Color(0xffAF201A),
        ),
        home: SplashScreen(),
        initialRoute: "/",
        onGenerateRoute: RouteGenerator.generateRoute,
        // routes: <String, WidgetBuilder>{
        //   '/HomeScreen': (BuildContext context) => new LoginPage(),
        // }
      )));
}
