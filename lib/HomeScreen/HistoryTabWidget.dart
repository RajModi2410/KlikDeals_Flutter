import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klik_deals/ApiBloc/ApiBloc_event.dart';
import 'package:klik_deals/ApiBloc/ApiBloc_state.dart';
import 'package:klik_deals/ApiBloc/models/CouponListResponse.dart';
import 'package:klik_deals/History_bloc.dart';
import 'package:klik_deals/mywidgets/CouponErrorWidget.dart';
import 'package:klik_deals/mywidgets/CouponItem.dart';
import 'package:klik_deals/mywidgets/EmptyListWidget.dart';
import 'package:klik_deals/mywidgets/RoundWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'HomeState.dart';

var token = "";
SharedPreferences sharedPreferences;

class HistoryTabWidget extends StatefulWidget {
  bool isForHistory;

  HistoryTabWidget(this.isForHistory);

  @override
  State<StatefulWidget> createState() => new _HistoryTabState(isForHistory);
}

class _HistoryTabState extends State<HistoryTabWidget>{// with AutomaticKeepAliveClientMixin<HistoryTabWidget>{
  bool _isLoading;
  HistoryBloc auth;
  int _perpage = 10;
  var choices;
  bool isForHistory;

  _HistoryTabState(this.isForHistory);

@override
void initState() { 
  super.initState();
  print("we are initstate _HistoryTabState");
  getToken();
}

  @override
  Widget build(BuildContext context) {
    print("we are build _HistoryTabState");
    auth = BlocProvider.of<HistoryBloc>(context);
    return Scaffold(
      body: BlocListener<HistoryBloc, ApiBlocState>(
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
        child: BlocBuilder<HistoryBloc, ApiBlocState>(
            bloc: auth,
            builder: (
              BuildContext context,
              ApiBlocState currentState,
            ) {
              if (currentState is ApiFetchingState) {
                print("Home Page :: We are in fetching state.....");
                return RoundWidget();
              } else if (currentState is CouponHistoryErroState) {
                print(
                    "Home Page :: We got error.....${currentState.couponlist.errorMessage.error[0]}");
                return CouponErrorWidget(errorMessage: currentState.couponlist.errorMessage.error.first);
              } else if (currentState is CouponHistoryListFetchedState) {
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
          return listDetails(data: listData, isForHistory: true);
        },
      )
          .toList(),
    );
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
        auth.add(CouponListEvent(_perpage, "history"));
    } catch (e) {
      print("Home Page :: We got error in catch.....${e.toString()}");
    }
  }

  // @override
  // bool get wantKeepAlive => true;
}
