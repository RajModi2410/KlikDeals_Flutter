import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klik_deals/ApiBloc/ApiBloc_bloc.dart';
import 'package:klik_deals/ApiBloc/ApiBloc_event.dart';
import 'package:klik_deals/ApiBloc/ApiBloc_state.dart';
import 'package:klik_deals/ApiBloc/models/CouponListResponse.dart';
import 'package:klik_deals/mywidgets/CouponErrorWidget.dart';
import 'package:klik_deals/mywidgets/CouponItem.dart';
import 'package:klik_deals/mywidgets/EmptyListWidget.dart';
import 'package:klik_deals/mywidgets/RoundWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

var token = "";
SharedPreferences sharedPreferences;

class HomeScreen extends StatefulWidget {
  bool isForHistory;

  HomeScreen(this.isForHistory);

  @override
  State<StatefulWidget> createState() => new _HomePage(isForHistory);
}

class _HomePage extends State<HomeScreen> {
  bool _isLoading;
  ApiBlocBloc auth;
  int _perpage = 10;
  var choices;
  bool isForHistory;

  _HomePage(this.isForHistory);

  @override
  Widget build(BuildContext context) {
    auth = BlocProvider.of<ApiBlocBloc>(context);
    return Scaffold(
      body: BlocListener<ApiBlocBloc, ApiBlocState>(
        listener: (context, state) {
          if (state is ApiErrorState) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('error occurred'),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is CouponListFetchedState) {}
        },
        child: BlocBuilder<ApiBlocBloc, ApiBlocState>(
            bloc: auth,
            builder: (
              BuildContext context,
              ApiBlocState currentState,
            ) {
              if (currentState is ApiFetchingState) {
                print("Home Page :: We are in fetching state.....");
                return RoundWidget();
              } else if (currentState is couponApiErrorState) {
                print(
                    "Home Page :: We got error.....${currentState.couponlist.errorMessage.error[0]}");
                return CouponErrorWidget(state: currentState);
              } else if (currentState is CouponListFetchedState) {
                return _couponList(currentState.couponlist.response.data);
              } else if (currentState is ApiEmptyState) {
                print("Home Page :: We got empty data.....");
                return EmptyListWidget(emptyMessage: "No coupon Data found");
              } else {
                return EmptyListWidget(emptyMessage: "No coupon Data found");
              }
            }),
      ),
    );
    // return null;
  }

  Widget _couponList(List<Data> data) {
    return Stack(children: <Widget>[
      Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/splash_bg.png'),
                fit: BoxFit.cover)),
      ),
      _gridView(data),
    ]);
  }

  Widget _gridView(List<Data> data) {
    return GridView.count(
      crossAxisCount: 2,
      padding: EdgeInsets.all(4.0),
      childAspectRatio: isForHistory ? 10.0 / 12.5 : 8.0 / 10.0,
      children: data
          .map(
            (listData) {
          listData.isFromHistory = isForHistory;
          return listDetails(data: listData);
        },
      )
          .toList(),
    );
  }

  @override
  void initState() {
    super.initState();
    getToken();
  }

  getToken() async {
    sharedPreferences = await SharedPreferences.getInstance();
    token = sharedPreferences.getString("token");
    if (token!=null && token.isNotEmpty) {
      getCouponList();
    } else {}
    print("Home Page :: We got Token $token");
  }

  void getCouponList() {
    try {
      if (!isForHistory) {
        auth.add(CouponListEvent(_perpage, null));
      } else {
        auth.add(CouponListEvent(_perpage, "history"));
      }
    } catch (e) {
      print("Home Page :: We got error in catch.....${e.toString()}");
    }
  }
}
