import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vendor/ApiBloc/ApiBloc_bloc.dart';
import 'package:vendor/ApiBloc/ApiBloc_event.dart';
import 'package:vendor/ApiBloc/ApiBloc_state.dart';
import 'package:vendor/ApiBloc/models/CouponListResponse.dart';
import 'package:vendor/CouponCode/EditCoupon.dart';
import 'package:vendor/HomeScreen/HomeState.dart';
import 'package:vendor/commons/CenterLoadingIndicator.dart';
import 'package:vendor/myWidgets/BackgroundWidget.dart';
import 'package:vendor/myWidgets/BottomLoader.dart';
import 'package:vendor/myWidgets/CouponErrorWidget.dart';
import 'package:vendor/myWidgets/CouponItem.dart';
import 'package:vendor/myWidgets/EmptyListWidget.dart';
import 'package:vendor/myWidgets/NoNetworkWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../AppLocalizations.dart';

var token = "";
SharedPreferences sharedPreferences;

class ActiveCouponTabWidget extends StatefulWidget {
  static const String routeName = "/active_coupon";
  final bool isForHistory;

  ActiveCouponTabWidget(this.isForHistory);

  @override
  State<StatefulWidget> createState() => new _ActiveCouponPage(isForHistory);
}

class _ActiveCouponPage extends State<ActiveCouponTabWidget>
    with AutomaticKeepAliveClientMixin<ActiveCouponTabWidget> {
  ApiBlocBloc apiBloc;
  int _perPage = 10;
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
    super.build(context);
    print("build initstate");
    apiBloc = BlocProvider.of<ApiBlocBloc>(context);
    return Scaffold(
      body: BlocListener<ApiBlocBloc, ApiBlocState>(
        listener: (context, state) {
          if (state is ApiErrorState) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalizations.of(context)
                      .translate("error_fetching_coupon"),
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
                  }
                  if (currentState is ApiReloadState) {
                    print("Home Page :: We are in reloading state.....");
                    getCouponList();
                    return CenterLoadingIndicator();
                  } else if (currentState is CouponApiErrorState) {
                    print(
                        "Home Page :: We got error.....${currentState.couponList.errorMessage.error[0]}");
                    return CouponErrorWidget(
                        errorMessage:
                            currentState.couponList.errorMessage.error.first);
                  } else if (currentState is CouponListFetchedState) {
                    CenterLoadingIndicator(
                      message: "Fetching active deals....",
                    );
                    return _couponList(currentState.couponList.response);


                  } else if (currentState is ApiEmptyState) {
                    print("Home Page :: We got empty data.....");

                    return EmptyListWidget(
                        emptyMessage: AppLocalizations.of(context)
                            .translate("error_no_coupon_active"));
                  } else if (currentState is CouponDeleteFetchedState) {
                    getCouponList();
                    return CenterLoadingIndicator(message: "Refreshing active deals....",
                    );
                  } else if (currentState is NoInternetState) {
                    return NoNetworkWidget(
                      retry: () {
                        retryCall();
                      },
                      isFromInternetConnection: currentState.isFromInternetConnection,
                    );
                  } else {
                    return EmptyListWidget(
                        emptyMessage: AppLocalizations.of(context)
                            .translate("error_no_coupon_active"));
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
            childAspectRatio: 1, //8.0 / 10.0,
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
              },
              onEditClick: (data) {
                _goToEditScreen(data.toJson());
              },
            );
          },
          childCount: getTotalCount(data),
        ),
      ),
      new SliverToBoxAdapter(
        child: hasReachedEnd ? Container() : BottomLoader(),
      )
    ]);
  }

  void _goToEditScreen(Map<String, dynamic> data) async {
    var result = await Navigator.of(context)
        .pushNamed(EditCoupon.routeName, arguments: data);
    if (result != null && result) {
      apiBloc.add(ReloadEvent(true));
    }
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
        // print("limit reached : " + hasReachedEnd.toString());
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
      lastEvent = CouponListEvent(_perPage, null, currentPage);
      apiBloc.add(lastEvent);
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
          lastEvent = ReloadEvent(true);
          apiBloc.add(lastEvent);
          break;
        case AppLifecycleState.inactive:
          break;
        case AppLifecycleState.paused:
          break;
        case AppLifecycleState.detached:
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
          title:
              new Text(AppLocalizations.of(context).translate("label_warning")),
          content: new Text(
              AppLocalizations.of(context).translate("message_confirm_delete")),
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
                removeCouponApi(id);
              },
            )
          ],
        );
      },
    );
  }

  void removeCouponApi(int couponId) {
    lastEvent = CouponDeleteEvent(couponId.toString());
    apiBloc.add(lastEvent);
  }
}
