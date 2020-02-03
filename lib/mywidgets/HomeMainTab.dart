import 'package:flutter/material.dart';
import 'package:klik_deals/CouponCode/Coupon.dart';

import '../HomeScreen/home.dart';

class HomeMainTab extends StatefulWidget {
  HomeMainTab({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyDetailsList createState() => _MyDetailsList();
}

class _MyDetailsList extends State<HomeMainTab> {
  bool firstSelected = true;


  @override
  void initState() {
    firstSelected = true;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          title: Text("KLIK DEALS", style: TextStyle(fontSize: 15),),
          bottom: TabBar(
            labelColor: Colors.redAccent,
            unselectedLabelColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              /*  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5)),*/
                color: Colors.white),
            onTap: (index) {
              if (index == 0) {
                setState(() {
                  firstSelected = true;
                });
              } else {
                setState(() {
                  firstSelected = false;
                });
              }
            },
            tabs: <Widget>[
              Tab(text: "Active Coupons"),
              Tab(text: "History")
            ],
          ),
        ),
        drawer: new Drawer(
            child: new ListView(
              children: <Widget>[
                new DrawerHeader(
                  child: new Image.asset('assets/images/logo.png'),
                ),
                new ListTile(
                  leading: Icon(
                    Icons.category,
                    color: Colors.redAccent,
                    size: 24.0,
                  ),
                  title: new Text('Home'),
                  onTap: () {
                    _goToHome();
                  },
                ),
                new ListTile(
                  leading: Icon(
                    Icons.confirmation_number,
                    color: Colors.redAccent,
                    size: 24.0,
                  ),
                  title: new Text('PROFILE'),
                  onTap: () {
                    _goToProfile();
                  },
                ),
//              new Divider(),
                new ListTile(
                  leading: Icon(
                    Icons.favorite,
                    color: Colors.redAccent,
                    size: 24.0,
                  ),
                  title: new Text('ADD COUPON'),
                  onTap: () {
                    _goToAddCoupon();
                  },
                ),
                new ListTile(
                  leading: Icon(
                    Icons.info,
                    color: Colors.redAccent,
                    size: 24.0,
                  ),
                  title: new Text('LOGOUT'),
                  onTap: () {
                    _logOut();
                  },
                ),
              ],
            )),
        body: TabBarView(
          children: <Widget>[
            HomeScreen(false),
            HomeScreen(true),
          ],
        ),
      ),
    );
  }

  void _goToHome() {}

  void _goToProfile() {}

  void _goToAddCoupon() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Coupon()),
    );
  }

  void _logOut() {}
}
