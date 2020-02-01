import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klik_deals/splash_screen/splashScreen.dart';

import 'ApiBloc/ApiBloc_bloc.dart';
import 'ApiBloc/repositories/ApiBloc_repository.dart';
import 'LoginScreen/LoginScreen.dart';

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
  runApp(BlocProvider<ApiBlocBloc>(
      builder: (context) => ApiBlocBloc(ApiBlocRepository()),
      child: MaterialApp(home: SplashScreen(), routes: <String, WidgetBuilder>{
        '/HomeScreen': (BuildContext context) => new LoginPage(),
      })));
}
