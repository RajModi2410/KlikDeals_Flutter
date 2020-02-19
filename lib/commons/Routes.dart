import 'package:flutter/material.dart';
import 'package:klik_deals/CouponCode/AddCoupon.dart';
import 'package:klik_deals/CouponCode/EditCoupon.dart';
import 'package:klik_deals/HomeScreen/ActiveCouponTabWidget.dart';
import 'package:klik_deals/LoginScreen/LoginPage.dart';
import 'package:klik_deals/ProfileScreen/Profile.dart';
import 'package:klik_deals/mywidgets/HomeMainTab.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;
    print("let's got this rounte => : " + settings.name);
    switch (settings.name) {
      case LoginPage.routeName:
        return MaterialPageRoute(builder: (context) => new LoginPage());
      case '/':
      case HomeMainTab.routeName:
        return MaterialPageRoute(builder: (context) => HomeMainTab());
      case ActiveCouponTabWidget.routeName:
        return MaterialPageRoute(
            builder: (context) => ActiveCouponTabWidget(args));
      case Profile.routeName:
        return MaterialPageRoute(builder: (context) => Profile());
      case AddCoupon.routeName:
        return MaterialPageRoute(builder: (context) => AddCoupon());
      case EditCoupon.routeName:
        return MaterialPageRoute(
          builder: (context) => EditCoupon(map: args),
        );
      default:
        // If there is no such named route in the switch statement, e.g. /third
        print("default we got rounte : " + settings.name);
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
