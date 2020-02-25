import 'package:flutter/material.dart';
import 'package:klik_deals/ApiBloc/models/DrawerItem.dart';
import 'package:klik_deals/CouponCode/AddCoupon.dart';
import 'package:klik_deals/HomeScreen/ActiveCouponTabWidget.dart';
import 'package:klik_deals/HomeScreen/HistoryTabWidget.dart';
import 'package:klik_deals/LoginScreen/LoginPage.dart';
import 'package:klik_deals/MyThemeData.dart';
import 'package:klik_deals/ProfileScreen/Profile.dart';
import 'package:klik_deals/commons/AuthUtils.dart';
import 'package:klik_deals/mywidgets/SingleDrawerItem.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  List<DrawerItem> sideMenu = [
    DrawerItem("assets/images/home_menu.png", "HOME",
        selecteImage: "assets/images/home_white.png"),
    DrawerItem("assets/images/user_profile.png", "PROFILE"),
    DrawerItem("assets/images/voucher.png", "ADD COUPON"),
    DrawerItem("assets/images/logout.png", "LOGOUT")
  ];
  int _selectedIndex = 0;

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
          new Container(
            height: double.maxFinite,
            child: ListView.builder(
                itemCount: sideMenu.length,
                itemBuilder: (context, index) {
                  return SingleDrawerItem1(
                      item: sideMenu[index],
                      currentIndex: index,
                      selectedIndex: _selectedIndex,
                      onClicked: (currentIndex) {
                        // setState(() {
                        //   _selectedIndex = currentIndex;
                        // });
                        switch (currentIndex) {
                          case 0:
                            _goToHome();
                            break;
                          case 1:
                            _goToProfile();
                            break;
                          case 2:
                            _goToAddCoupon();
                            break;
                          case 3:
                            _logOut();
                            break;
                          default:
                        }
                      });
                }),
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

  void _goToProfile() {
    isHomeScreen = false;
    print("_goToProfile " +
        context.widget.toStringShort() +
        "::" +
        context.widget.hashCode.toString());
    Navigator.pop(context);
    Navigator.of(context).pushNamed(Profile.routeName);
  }

  void _goToAddCoupon() {
    isHomeScreen = false;
    setState(() {
      print("_goToAddCoupon " +
          context.widget.toStringShort() +
          "::" +
          context.widget.hashCode.toString());
      Navigator.pop(context);
      Navigator.of(context).pushNamed(AddCoupon.routeName);
    });
  }

  Future<bool> _logOut() {
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
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool removed = await prefs.remove(AuthUtils.authTokenKey);
  print("reved the token : $removed");
  Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
}
