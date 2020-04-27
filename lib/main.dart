import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:vendor/CouponCode/CouponBloc.dart';
import 'package:vendor/History_bloc.dart';
import 'package:vendor/LoginScreen/LoginPage.dart';
import 'package:vendor/ProfileScreen/Profile_bloc.dart';
import 'package:vendor/commons/Auth/Auth_bloc.dart';
import 'package:vendor/commons/Auth/index.dart';
import 'package:vendor/commons/AuthUtils.dart';
import 'package:vendor/commons/Routes.dart';
import 'package:vendor/commons/locator.dart';
import 'package:vendor/splash_screen/splashScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ApiBloc/ApiBloc_bloc.dart';
import 'ApiBloc/repositories/ApiBloc_repository.dart';
import 'AppLocalizations.dart';
import 'commons/NavigationService.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
    Fluttertoast.showToast(
        msg: "Your session is expired. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
    clearThings();
    // authBloc?.add(TokenExpiredEvent());
  });

  // var GlobalMaterialLocalizations;
  // var GlobalWidgetsLocalizations;
  runApp(MultiBlocProvider(
      providers: [
        BlocProvider<ApiBlocBloc>(
            create: (context) => ApiBlocBloc(apiBlocRepo)),
        BlocProvider<HistoryBloc>(
            create: (context) => HistoryBloc(apiBlocRepo)),
        BlocProvider<ProfileBloc>(
            create: (context) => ProfileBloc(apiBlocRepo)),
        BlocProvider<CouponBloc>(create: (context) => CouponBloc(apiBlocRepo)),
        BlocProvider<AuthBloc>(create: (context) => AuthBloc())
      ],
      child: MaterialApp(
        //        theme: myTheme,
        navigatorKey: locator<NavigationService>().navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          cupertinoOverrideTheme: CupertinoThemeData(
            primaryColor: Color(0xffAF201A)
          ),
            cursorColor: Colors.black,
            textSelectionHandleColor: Colors.transparent,
            fontFamily: "Montserrat",
            primaryColor: Color(0xffAF201A),
            hintColor: Colors.grey,
            errorColor: Color(0xffAF201A),
            buttonColor: Color(0xffAF201A),
            dividerColor: Colors.transparent,
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
        supportedLocales: [
          Locale('en', 'US'),
        ],
        localizationsDelegates: [
          // THIS CLASS WILL BE ADDED LATER
          // A class which loads the translations from JSON files
          AppLocalizations.delegate,
          // Built-in localization of basic text for Material widgets
          GlobalMaterialLocalizations.delegate,
          // Built-in localization for text direction LTR/RTL
          GlobalWidgetsLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          // Check if the current device locale is supported
          if (locale == null) {
            print("*language locale is null!!!");
            return  Locale('en', 'US');//supportedLocales.first;
          }
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode &&
                supportedLocale.countryCode == locale.countryCode) {
              return supportedLocale;
            }
          }
          // If the locale of the device is not supported, use the first one
          // from the list (English, in this case).
          return supportedLocales.first;
        },
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
  SharedPreferences pref = await SharedPreferences.getInstance();
  bool removed = await pref.remove(AuthUtils.authTokenKey);
  print("removed the token : $removed");
  locator<NavigationService>().navigateTo(LoginPage.routeName);
}

