import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klik_deals/ApiBloc/ApiBloc_bloc.dart';
import 'package:klik_deals/ApiBloc/ApiBloc_event.dart';
import 'package:klik_deals/ApiBloc/ApiBloc_state.dart';
import 'package:klik_deals/ApiBloc/models/CouponListResponse.dart';
import 'package:klik_deals/HomeScreen/HomeState.dart';
import 'package:klik_deals/commons/KeyConstant.dart';
import 'package:klik_deals/mywidgets/CouponErrorWidget.dart';
import 'package:klik_deals/mywidgets/CouponItem.dart';
import 'package:klik_deals/mywidgets/EmptyListWidget.dart';
import 'package:klik_deals/mywidgets/NoNetworkWidget.dart';
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
  ApiBlocEvent lastEvent;

  int perPage = 4;
  int currentPage = 1;
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  bool hasReachedEnd = false;
  bool inProcess = false;

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
                content: Text('error occurred during fetching coupons..'),
                backgroundColor: Theme.of(context).primaryColor,
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
                return _couponList(currentState.couponlist.response);
              } else if (currentState is ApiEmptyState) {
                print("Home Page :: We got empty data.....");
                return EmptyListWidget(
                    emptyMessage: KeyConstant.ERROR_NO_COUPON_ACTIVE);
              } else if (currentState is CouponDeleteFetchedState) {
                getCouponList();
                return RoundWidget();
              } else if (currentState is NoInternetState) {
                return NoNetworkWidget(
                  retry: () {
                    retryCall();
                  },
                );
              } else {
                return EmptyListWidget(
                    emptyMessage: KeyConstant.ERROR_NO_COUPON_ACTIVE);
              }
            }),
      ),
    );
    // return null;
  }

  Widget _couponList(Response data) {
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

  Widget _gridView(Response data) {
    return GridView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 8.0 / 10.0,
            crossAxisCount: 2,
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0),
        itemCount: getTotalCount(data),
        itemBuilder: (BuildContext context, int index) {
          if (index == data.data.length) {
            print(
                "we are getting bottom at $index and total is: ${data.data.length}");
            return BottomLoader();
          } else {
            var listData = data.data[index];
            listData.isFromHistory = isForHistory;
            // return GridTile(child: null)
            return CouponItem(
                data: listData,
                isForHistory: false,
                onDeleteClick: (id) {
                  _showPopup(id);
                });
          }
        });
  }

  int getTotalCount(Response vendorList) {
    var responseData = vendorList;
    hasReachedEnd = responseData.currentPage == responseData.lastPage;
    print(
        "CategoriesListScreen We need Data ::: $hasReachedEnd :: ${responseData.currentPage} :: ${responseData.lastPage}");
    // BottomLoader();
    // print("CategoriesListScreen we are in bottom of::$BottomLoader()");
    // return vendorList == null ? 0 : resppnse.data.length + (hasReachedEnd? 0 : 1);
    var totalLength = responseData.data.length + (hasReachedEnd ? 0 : 1);
    print("We are returning totalLength : $totalLength");
    return totalLength;
  }

  @override
  void initState() {
    super.initState();
    getToken();
    print("_ActiveCouponPage initstate");
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      if (!hasReachedEnd && !inProcess) {
        inProcess = true;
        print("Before current page : $currentPage");
        // currentPage = currentPage + 1;
        // print("current page : $currentPage");
        // getCouponList();
      } else {
        // print("limit reahed : " + hasReachedEnd.toString());
      }
    }
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
      lastEvent = CouponListEvent(_perpage, null, currentPage);
      apiBloc.add(lastEvent);
    } catch (e) {
      print("Home Page :: We got error in catch.....${e.toString()}");
    }
  }

  @override
  bool get wantKeepAlive => true;

  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      switch (state) {
        case AppLifecycleState.resumed:
          lastEvent = ReloadEvent(true);
          apiBloc.add(lastEvent);
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

  void retryCall() {
    if (lastEvent != null) {
      apiBloc.add(lastEvent);
    }
  }

  void _showPopup(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Warning"),
          content: new Text("Are you sure want to delete this coupon?"),
          actions: <Widget>[
            FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: const Text('ACCEPT'),
              onPressed: () {
                Navigator.of(context).pop();
                RemoveCouponApi(id);
              },
            )
          ],
        );
      },
    );
  }

  void RemoveCouponApi(int couponId) {
    lastEvent = CouponDeleteEvent(couponId.toString());
    apiBloc.add(lastEvent);
  }
}

class BottomLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber,
      alignment: Alignment.center,
      child: Center(
        child: SizedBox(
          width: 33,
          height: 33,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
          ),
        ),
      ),
    );
  }
}
