import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klik_deals/ApiBloc/ApiBloc_bloc.dart';
import 'package:klik_deals/ApiBloc/ApiBloc_event.dart';
import 'package:klik_deals/ApiBloc/ApiBloc_state.dart';
import 'package:klik_deals/ApiBloc/models/CouponListResponse.dart';
import 'package:klik_deals/HomeScreen/HomeState.dart';
import 'package:klik_deals/commons/CenterLoadingIndicator.dart';
import 'package:klik_deals/commons/KeyConstant.dart';
import 'package:klik_deals/mywidgets/BackgroundWidget.dart';
import 'package:klik_deals/mywidgets/BottomLoader.dart';
import 'package:klik_deals/mywidgets/CouponErrorWidget.dart';
import 'package:klik_deals/mywidgets/CouponItem.dart';
import 'package:klik_deals/mywidgets/EmptyListWidget.dart';
import 'package:klik_deals/mywidgets/NoNetworkWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../AppLocalizations.dart';

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

//Pagination Stuff Start
  int currentPage = 1;
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  bool hasReachedEnd = false;
  bool inProcess = false;
//Pagination Stuff End

  _ActiveCouponPage(this.isForHistory);

  @override
  void initState() {
    super.initState();
    getToken();
    print("_ActiveCouponPage initstate");
    _scrollController.addListener(_onScroll);
  }

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
                content: Text(AppLocalizations.of(context).translate("error_fetching_coupon"),
),
                backgroundColor: Theme.of(context).primaryColor,
              ),
            );
          } else if (state is CouponListFetchedState) {}
        },
        child: Stack(
          children: <Widget>[
            BackgroundWidget(),
            BlocBuilder<ApiBlocBloc, ApiBlocState>(
                bloc: apiBloc,
                builder: (
                  BuildContext context,
                  ApiBlocState currentState,
                ) {
                  inProcess = false;
                  if (currentState is ApiFetchingState) {
                    print("Home Page :: We are in fetching state.....");
                    return CenterLoadingIndicator();
                    // return RoundWidget();
                  }
                  if (currentState is ApiReloadState) {
                    print("Home Page :: We are in reloading state.....");
                    getCouponList();
                    return CenterLoadingIndicator();
                    //  RoundWidget();
                  } else if (currentState is couponApiErrorState) {
                    print(
                        "Home Page :: We got error.....${currentState.couponlist.errorMessage.error[0]}");
                    return CouponErrorWidget(
                        errorMessage:
                            currentState.couponlist.errorMessage.error.first);
                  } else if (currentState is CouponListFetchedState) {
                    CenterLoadingIndicator();

                    return _couponList(currentState.couponlist.response);
                  } else if (currentState is ApiEmptyState) {
                    print("Home Page :: We got empty data.....");
                    return EmptyListWidget(
                        emptyMessage: AppLocalizations.of(context).translate("error_no_coupon_active"));

                  } else if (currentState is CouponDeleteFetchedState) {
                    getCouponList();
                    return CenterLoadingIndicator();
                  } else if (currentState is NoInternetState) {
                    return NoNetworkWidget(
                      retry: () {
                        retryCall();
                      },
                    );
                  } else {
                    return EmptyListWidget(
                      emptyMessage: AppLocalizations.of(context).translate("error_no_coupon_active"));
                  }
                }),
          ],
        ),
      ),
    );
    // return null;
  }

  Widget _couponList(Response data) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: _gridView(data),
    );
  }

  Widget _gridView(Response data) {
    return CustomScrollView(controller: _scrollController, slivers: <Widget>[
      new SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 8.0 / 10.0,
            crossAxisCount: 2,
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            var listData = data.data[index];
            listData.isFromHistory = isForHistory;
            // return GridTile(child: null)
            return CouponItem(
                data: listData,
                isForHistory: false,
                onDeleteClick: (id) {
                  _showPopup(id);
                });
          },
          childCount: getTotalCount(data),
        ),
      ),
      new SliverToBoxAdapter(
        child: hasReachedEnd ? Container() : BottomLoader(),
      )
    ]);

    //       child: GridView.builder(
    //       controller: _scrollController,
    //       physics: const AlwaysScrollableScrollPhysics(),
    //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //           childAspectRatio: 8.0 / 10.0,
    //           crossAxisCount: 2,
    //           mainAxisSpacing: 4.0,
    //           crossAxisSpacing: 4.0),
    //       itemCount: getTotalCount(data),
    //       itemBuilder: (BuildContext context, int index) {
    //         if (index == data.data.length) {
    //           print(
    //               "we are getting bottom at $index and total is: ${data.data.length}");
    //           return BottomLoader();
    //         } else {
    //           var listData = data.data[index];
    //           listData.isFromHistory = isForHistory;
    //           // return GridTile(child: null)
    //           return CouponItem(
    //               data: listData,
    //               isForHistory: false,
    //               onDeleteClick: (id) {
    //                 _showPopup(id);
    //               });
    //         }
    //       }),
    // );
  }

  int getTotalCount(Response vendorList) {
    var responseData = vendorList;
    hasReachedEnd = responseData.currentPage == responseData.lastPage;
    print(
        "CategoriesListScreen We need Data ::: $hasReachedEnd :: ${responseData.currentPage} :: ${responseData.lastPage}");
    var totalLength = responseData.data.length;
    print("We are returning totalLength : $totalLength");
    return totalLength;
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      if (!hasReachedEnd && !inProcess) {
        inProcess = true;
        print("Before current page : $currentPage");
        currentPage = currentPage + 1;
        print("current page : $currentPage");
        getCouponList();
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

  Widget buildListView(BuildContext context) {
    // return Container();
    return CenterLoadingIndicator();
  }

  void _showPopup(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(AppLocalizations.of(context).translate("label_warning")),
          content: new Text(AppLocalizations.of(context).translate("message_confirm_delete")),
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
