package common;

import 'package:flutter/material.dart';
import 'package:wds_stock_app/admin/brand/AddBrandFormScreen.dart';
import 'package:wds_stock_app/admin/brand/BrandListScreen.dart';
import 'package:wds_stock_app/admin/category/AddCategoryFormScreen.dart';
import 'package:wds_stock_app/admin/home/DashboardScreen.dart';
import 'package:wds_stock_app/admin/item/AddItemFormScreen.dart';
import 'package:wds_stock_app/admin/manageStock/AddStockScreen.dart';
import 'package:wds_stock_app/admin/manageStock/RemoveStockScreen.dart';
import 'package:wds_stock_app/admin/manageStock/StockManageScreen.dart';
import 'package:wds_stock_app/admin/setting/SettingScreen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;
    print("let's got this route => : " + settings.name);
    switch (settings.name) {
      case AddBrandFormScreen.routeName:
        return MaterialPageRoute(
            builder: (context) => new AddBrandFormScreen());
      case AddCategoryFormScreen.routeName:
        return MaterialPageRoute(
            builder: (context) => new AddCategoryFormScreen());
      case AddItemFormScreen.routeName:
        return MaterialPageRoute(builder: (context) => new AddItemFormScreen());
      case SettingScreen.routeName:
        return MaterialPageRoute(builder: (context) => new SettingScreen());
      case DashboardScreen.routeName:
        return MaterialPageRoute(builder: (context) => new DashboardScreen());
      case BrandListScreen.routeName:
        return MaterialPageRoute(builder: (context) => new BrandListScreen());
      case StockManageScreen.routeName:
        return MaterialPageRoute(builder: (context) => new StockManageScreen());
      case AddStockScreen.routeName:
        return MaterialPageRoute(
            builder: (context) => new AddStockScreen());
      case RemoveStockScreen.routeName:
        return MaterialPageRoute(
            builder: (context) => new RemoveStockScreen());
      case '/':
      default:
        // If there is no such named route in the switch statement, e.g. /third
        print("default we got route : " + settings.name);
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
