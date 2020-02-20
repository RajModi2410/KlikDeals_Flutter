import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klik_deals/ApiBloc/ApiBloc_bloc.dart';
import 'package:klik_deals/ApiBloc/ApiBloc_state.dart';
import 'package:klik_deals/ApiBloc/index.dart';
import 'package:klik_deals/ApiBloc/models/CouponListResponse.dart';
import 'package:klik_deals/CouponCode/EditCoupon.dart';
import 'package:klik_deals/HomeScreen/HomeState.dart';

import 'RoundWidget.dart';

class CouponItem extends StatelessWidget {
  Data data;
  bool isForHistory = false;
  ApiBlocBloc auth;
  RoundWidget round;

  CouponItem({@required this.data, this.isForHistory});

  @override
  Widget build(BuildContext context) {
    String date;
    if (isForHistory) {
      date = dateFormatter("", "", isForHistory, data.grabDate);
    } else {
      date = dateFormatter(data.startDate, data.endDate, isForHistory, "");
    }
    auth = BlocProvider.of<ApiBlocBloc>(context);
    return Stack(children: <Widget>[
      couponList(context, date),
      BlocListener<ApiBlocBloc, ApiBlocState>(
          listener: (context, state) {
            if (state is CouponDeleteErrorState) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text(state.deleteCouponResponse.errorMessage.toString()),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              );
            } else if (state is CouponDeleteFetchedState) {
              print(
                  "Delete coupon successfully :: ${state.deleteCouponResponse.message}");
            }
          },
          child: BlocBuilder<ApiBlocBloc, ApiBlocState>(
              bloc: auth,
              builder: (
                BuildContext context,
                ApiBlocState currentState,
              ) {
                if (currentState is ApiFetchingState) {
                  round = RoundWidget();
                  return round;
                } else {
                  return Container();
                }
              }))
    ]);
  }

  Widget couponList(BuildContext context, String date) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8), topRight: Radius.circular(8)),
              child: AspectRatio(
                aspectRatio: 18.0 / 12.0,
                child: getImage(),
              ),
            ),
            new Padding(
              padding: EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 2.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                    // child: ListTile(
                    //   title: Text(
                    //         data.couponCode,
                    //         overflow: TextOverflow.ellipsis,
                    //         maxLines: 1,
                    //         style: TextStyle(
                    //           fontSize: 15.0,
                    //           color: Colors.black,
                    //           fontWeight: FontWeight.bold,
                    //         ),
                    //       ),
                    //       trailing: getActions(context),
                    // ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 7,
                          child: Text(
                            data.couponCode,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: getActions(context),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                    child: Text(
                      data.description,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0, left: 8.0),
                    child: Text(
                      date,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0, left: 8.0),
                    child: _staus(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row getActions(BuildContext context) {
    if (isForHistory) {
      return Row();
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          GestureDetector(
              onTap: () {
                _goToEditScreen(context, data.toJson(), auth);
              },
              child: SizedBox(
                height: 20,
                width: 20,
                child: Image.asset("assets/images/pencils.png"))),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 0),
            child: GestureDetector(
                onTap: () {
                  _showPopup(context, data.id, auth);
                },
                 child: SizedBox(
                height: 20,
                width: 20,
                child: Image.asset("assets/images/bins.png"))),
          )
        ],
      );
    }
  }

  Image getImage() {
    if (data != null && data.couponImage != null) {
      return Image.network(
        data.couponImage,
        fit: BoxFit.cover,
      );
    } else {
      return Image.asset(
        'assets/images/kfc.png',
        fit: BoxFit.cover,
      );
    }
  }

  Widget _staus() {
    if (data.isFromHistory) {
      return Text(
        "${data.statusName}",
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: TextStyle(
          color: Colors.black54,
          fontSize: 12.0,
        ),
      );
    } else {
      return Text(
        "",
        style: TextStyle(
          color: Colors.black54,
          fontSize: 12.0,
        ),
      );
    }
  }
}

String dateFormatter(
    String startDate, String endDate, bool isForHistory, String grabDate) {
  var months = {
    '01': 'Jan',
    '02': 'Feb',
    '03': 'Mar',
    '04': 'Apr',
    '05': 'May',
    '06': 'Jun',
    '07': 'Jul',
    '08': 'Aug',
    '09': 'Sept',
    '10': 'Oct',
    '11': 'Nov',
    '12': 'Dec'
  };

  if (isForHistory) {
    var grabDateArray = grabDate.split("/");
    var grabMonth = months[grabDateArray[1]];
    return "Redeem Date: ${grabDateArray[2]} "
        "$grabMonth "
        "${grabDateArray[0]}";
  } else {
    String startFormattedDate;
    String endFormattedDate;
    var startDateArray = startDate.split("/");
    var endDateArray = endDate.split("/");
    var startMonth = months[startDateArray[1]];
    var endMonth = months[endDateArray[1]];
    startFormattedDate = "Good from ${startDateArray[0]} "
        "$startMonth "
        "${startDateArray[2]} To ";
    endFormattedDate = "${endDateArray[0]} " "$endMonth " "${endDateArray[2]}";
    return startFormattedDate + endFormattedDate;
  }
}

void _showPopup(BuildContext context, int id, ApiBlocBloc auth) {
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
              RemoveCouponApi(id, auth);
            },
          )
        ],
      );
    },
  );
}

void RemoveCouponApi(int couponId, ApiBlocBloc auth) {
  auth.add(CouponDeleteEvent(couponId.toString()));
}

void _goToEditScreen(
    BuildContext context, Map<String, dynamic> data, ApiBlocBloc auth) async {
  var result = await Navigator.of(context)
      .pushNamed(EditCoupon.routeName, arguments: data);

  if (result) {
    auth.add(ReloadEvent(true));
  }
}
