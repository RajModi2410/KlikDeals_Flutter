import 'package:flutter/material.dart';
import 'package:klik_deals/CouponCode/AddCoupon.dart';
import 'package:klik_deals/HomeScreen/ActiveCouponTabWidget.dart';
import 'package:klik_deals/HomeScreen/HistoryTabWidget.dart';
import 'package:klik_deals/LoginScreen/LoginPage.dart';
import 'package:klik_deals/MyThemeData.dart';
import 'package:klik_deals/ProfileScreen/Profile.dart';

class HomeMainTab extends StatefulWidget {
  static const String routeName = "/home";

  HomeMainTab({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyDetailsList createState() => _MyDetailsList();
}

class _MyDetailsList extends State<HomeMainTab>
    with SingleTickerProviderStateMixin {
  bool firstSelected = true;
  bool isHomeScreen = true;
  TabController _controller;

  @override
  void initState() {
    super.initState();
    firstSelected = true;
    _controller = new TabController(
      length: 2,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "KLIK DEALS",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _controller,
          labelStyle:
              TextStyle(fontFamily: "Montserrat", fontWeight: FontWeight.w400),
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BoxDecoration(color: Colors.white),
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
          tabs: <Widget>[Tab(text: "Active Coupons"), Tab(text: "History")],
        ),
      ),
      drawer: new Drawer(
          child: new ListView(
        children: <Widget>[
          new DrawerHeader(
            child: new Image.asset('assets/images/logo.png'),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: new Row(children: <Widget>[
              SizedBox(
                  height: 20,
                  width: 20,
                  child: Image.asset('assets/images/home_menu.png')),
              InkWell(
                child: new Text('HOME'),
                onTap: () {
                  Navigator.pop(context);
                  _goToHome();
                },
              ),
            ]),
          ),
          new ListTile(
            leading: SizedBox(
              height: 20,
              width: 20,
              child: Image.asset('assets/images/user_profile.png'),
            ),
            title: new Text('PROFILE'),
            onTap: () {
              Navigator.pop(context);
              _goToProfile(context);
            },
          ),
//              new Divider(),
          new ListTile(
            leading: SizedBox(
              height: 20,
              width: 20,
              child: Image.asset('assets/images/voucher.png'),
            ),
            title: new Text('ADD COUPON'),
            onTap: () {
              Navigator.pop(context);
              _goToAddCoupon();
            },
          ),
          new ListTile(
            leading: SizedBox(
              height: 20,
              width: 20,
              child: Image.asset('assets/images/logout.png'),
            ),
            title: new Text('LOGOUT'),
            onTap: () {
              _logOut(context);
            },
          ),
        ],
      )),
      body: TabBarView(
        controller: _controller,
        children: <Widget>[
          ActiveCouponTabWidget(false),
          HistoryTabWidget(true),
        ],
      ),
    );
  }

  void _goToHome() {
    Navigator.pop(context);
  }

  void _goToProfile(BuildContext context) {
    isHomeScreen = false;
    Navigator.of(context).pushNamed(Profile.routeName);
  }

  void _goToAddCoupon() {
    isHomeScreen = false;
    Navigator.of(context).pushNamed(AddCoupon.routeName);
  }

  Future<bool> _logOut(BuildContext context) {
    return showDialog(
        context: context,
        child: AlertDialog(
            title: new Text("Warning"),
            content: new Text("Are you sure want to Logout?"),
            actions: <Widget>[
              FlatButton(
                child: const Text('No, Thanks'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: const Text("Yes, I'm"),
                onPressed: () {
                  Navigator.of(context).pop();
                  clearDataAndRedirectLoginScreen(context);
                },
              )
            ]));
  }
}

Future<void> clearDataAndRedirectLoginScreen(BuildContext context) async {
  /*SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove("token");*/
  Navigator.popUntil(context, ModalRoute.withName(LoginPage.routeName));
}
