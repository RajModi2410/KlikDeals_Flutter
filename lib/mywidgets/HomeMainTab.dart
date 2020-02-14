import 'package:flutter/material.dart';
import 'package:klik_deals/CouponCode/AddCoupon.dart';
import 'package:klik_deals/HomeScreen/ActiveCouponTabWidget.dart';
import 'package:klik_deals/HomeScreen/HistoryTabWidget.dart';
import 'package:klik_deals/MyThemeData.dart';
import 'package:klik_deals/ProfileScreen/Profile.dart';

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
    super.initState();
    firstSelected = true;
  }

  @override
  bool wantKeepAlive() {
    return true;
  }

  @override
  void dispose() {
    // _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: myTheme,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            // backgroundColor: Colors.redAccent,
            title: Text(
              "KLIK DEALS",
              style: TextStyle(fontSize: 15),
            ),
            bottom: TabBar(
              // controller: _controller,
              labelColor: Colors.redAccent,
              unselectedLabelColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                  // /*  borderRadius: BorderRadius.only(
                  //     topLeft: Radius.circular(5),
                  //     topRight: Radius.circular(5)),*/
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
              tabs: <Widget>[Tab(text: "Active Coupons"), Tab(text: "History")],
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
                title: new Text('HOME'),
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
            // controller: _controller,
            children: <Widget>[
              ActiveCouponTabWidget(false),
              HistoryTabWidget(true),
            ],
          ),
        ),
      ),
    );
  }

  void _goToHome() {}

  void _goToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Profile()),
    );
  }

  void _goToAddCoupon() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddCoupon()),
    );
  }

  void _logOut() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
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
          ],
        );
      },
    );
  }
}

Future<void> clearDataAndRedirectLoginScreen(BuildContext context) async {
  /*SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove("token");*/
  Navigator.popUntil(context, ModalRoute.withName("/"));
}
