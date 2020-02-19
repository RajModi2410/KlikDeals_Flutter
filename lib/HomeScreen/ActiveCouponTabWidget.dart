import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klik_deals/ApiBloc/ApiBloc_bloc.dart';
import 'package:klik_deals/ApiBloc/ApiBloc_event.dart';
import 'package:klik_deals/ApiBloc/ApiBloc_state.dart';
import 'package:klik_deals/ApiBloc/models/CouponListResponse.dart';
import 'package:klik_deals/HomeScreen/HomeState.dart';
import 'package:klik_deals/mywidgets/CouponErrorWidget.dart';
import 'package:klik_deals/mywidgets/CouponItem.dart';
import 'package:klik_deals/mywidgets/EmptyListWidget.dart';
import 'package:klik_deals/mywidgets/RoundWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

var token = "";
SharedPreferences sharedPreferences;

class ActiveCouponTabWidget extends StatefulWidget {
  static const String routeName = "/active_coupon";
  bool isForHistory;

  ActiveCouponTabWidget(this.isForHistory);

  @override
  State<StatefulWidget> createState() => new _ActiveCouponPage(isForHistory);
}

class _ActiveCouponPage extends State<ActiveCouponTabWidget>
    with AutomaticKeepAliveClientMixin<ActiveCouponTabWidget> {
  bool _isLoading;
  ApiBlocBloc apiBloc;
  int _perpage = 10;
  var choices;
  bool isForHistory;

  _ActiveCouponPage(this.isForHistory);

  @override
  Widget build(BuildContext context) {
    print("build initstate");
    apiBloc = BlocProvider.of<ApiBlocBloc>(context);
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
            bloc: apiBloc,
            builder: (
              BuildContext context,
              ApiBlocState currentState,
            ) {
              if (currentState is ApiFetchingState) {
                print("Home Page :: We are in fetching state.....");
                return RoundWidget();
              }
              if (currentState is ApiReloadState) {
                print("Home Page :: We are in reloading state.....");
                getCouponList();
                return RoundWidget();
              } else if (currentState is couponApiErrorState) {
                print(
                    "Home Page :: We got error.....${currentState.couponlist.errorMessage.error[0]}");
                return CouponErrorWidget(
                    errorMessage:
                        currentState.couponlist.errorMessage.error.first);
              } else if (currentState is CouponListFetchedState) {
                return _couponList(currentState.couponlist.response.data);
              } else if (currentState is ApiEmptyState) {
                print("Home Page :: We got empty data.....");
                return EmptyListWidget(emptyMessage: "No coupon Data found");
              } else if (currentState is CouponDeleteFetchedState) {
                getCouponList();
                return RoundWidget();
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
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: _gridView(data),
      ),
    ]);
  }

  // Widget _gridView(List<Data> data) {
  //   return GridView.count(
  //     crossAxisCount: 2,
  //     padding: EdgeInsets.all(4.0),
  //     childAspectRatio: isForHistory ? 10.0 / 12.5 : 8.0 / 10.0,
  //     children: data
  //         .map(
  //           (listData) {
  //         listData.isFromHistory = isForHistory;
  //         return listDetails(data: listData, isForHistory: false);
  //       },
  //     ).toList(),
  //   );
  // }

  Widget _gridView(List<Data> data) {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: isForHistory ? 10.0 / 12.5 : 8.0 / 10.0,
            crossAxisCount: 2,
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0),
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          var listData = data[index];
          listData.isFromHistory = isForHistory;
          return CouponItem(data: listData, isForHistory: false);
        });
  }

  @override
  void initState() {
    super.initState();
    getToken();
    print("_ActiveCouponPage initstate");
  }

  getToken() async {
    sharedPreferences = await SharedPreferences.getInstance();
    token = sharedPreferences.getString("token");
    if (token != null && token.isNotEmpty) {
      getCouponList();
    } else {}
    print("Home Page :: We got Token $token");
  }

  void getCouponList() {
    try {
      apiBloc.add(CouponListEvent(_perpage, null));
    } catch (e) {
      print("Home Page :: We got error in catch.....${e.toString()}");
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      switch (state) {
        case AppLifecycleState.resumed:
          apiBloc.add(ReloadEvent(true));
          break;
        case AppLifecycleState.inactive:
          // Handle this case
          break;
        case AppLifecycleState.paused:
          // Handle this case
          break;
        case AppLifecycleState.detached:
          // TODO: Handle this case.
          break;
      }
    });
  }
}
