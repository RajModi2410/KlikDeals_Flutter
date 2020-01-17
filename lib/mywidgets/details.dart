import 'package:flutter/material.dart';

import '../home.dart';

class MyDetailList extends StatefulWidget {
  MyDetailList({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyDetailsList createState() => _MyDetailsList();
}

class _MyDetailsList extends State<MyDetailList> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Appbar with tabs"),
          
          bottom: TabBar(
            tabs: <Widget>[
              // CouponList(),
              // CouponList(),
              Text("Active Coupons"),
             Text("History")
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            // AndroidAction(),
            // Text("Active coupons select"),
            // Text("History select"),
              CouponList(),
                CouponList(),
          ],
        ),
      ),
    );
  }
}
