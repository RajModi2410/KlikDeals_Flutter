import 'package:flutter/material.dart';
import 'package:klik_deals/ApiBloc/models/DrawerItem.dart';
import 'package:klik_deals/AppLocalizations.dart';
import 'package:klik_deals/CouponCode/AddCoupon.dart';
import 'package:klik_deals/HomeScreen/ActiveCouponTabWidget.dart';
import 'package:klik_deals/HomeScreen/HistoryTabWidget.dart';
import 'package:klik_deals/LoginScreen/LoginPage.dart';
import 'package:klik_deals/ProfileScreen/Profile.dart';
import 'package:klik_deals/commons/AuthUtils.dart';
import 'package:klik_deals/myWidgets/SingleDrawerItem.dart';
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
        selectedImage: "assets/images/home_white.png"),
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).translate("title_appname"),
          style: Theme.of(context).textTheme.title,
        ),
        bottom: TabBar(
          controller: _controller,
          labelStyle:
              TextStyle(fontFamily: "Montserrat", fontWeight: FontWeight.w500),
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
          tabs: <Widget>[
            Tab(
                text: AppLocalizations.of(context)
                    .translate("title_active_coupon")),
            Tab(
                text:
                    AppLocalizations.of(context).translate("title _historytab"))
          ],
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
            title: new Text(AppLocalizations.of(context).translate("label_warning")),
            content: new Text(AppLocalizations.of(context).translate("error_message_logout")
),
            actions: <Widget>[
              FlatButton(
                child:  Text(AppLocalizations.of(context).translate("label_no_thanks")),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child:  Text(AppLocalizations.of(context).translate("label_yes_i'm")),
                onPressed: () {
                  Navigator.of(context).pop();
                  clearDataAndRedirectLoginScreen(context);
                },
              )
            ]));
  }
}

Future<void> clearDataAndRedirectLoginScreen(BuildContext context) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  bool removed = await pref.remove(AuthUtils.authTokenKey);
  print("removed the token : $removed");
  Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
}
