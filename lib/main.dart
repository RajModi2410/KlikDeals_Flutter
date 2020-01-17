import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klik_deals/splash_screen/splashScreen.dart';

import 'ApiBloc/ApiBloc_bloc.dart';
import 'ApiBloc/repositories/ApiBloc_repository.dart';
import 'LoginScreen/LoginScreen.dart';

void main() {
  runApp(BlocProvider<ApiBlocBloc>(
      builder: (context) => ApiBlocBloc(ApiBlocRepository()),
      child: MaterialApp(home: SplashScreen(), routes: <String, WidgetBuilder>{
        '/HomeScreen': (BuildContext context) => new LoginScreen(),
      })));
}
