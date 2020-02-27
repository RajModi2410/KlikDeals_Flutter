import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:klik_deals/ApiBloc/ApiBloc_bloc.dart';
import 'package:klik_deals/ApiBloc/ApiBloc_state.dart';
import 'package:klik_deals/ApiBloc/index.dart';
import 'package:klik_deals/ApiBloc/models/CouponListResponse.dart';
import 'package:klik_deals/CouponCode/EditCoupon.dart';
import 'package:klik_deals/HomeScreen/HomeState.dart';

import 'RoundWidget.dart';

class CouponItem extends StatelessWidget {
  final Data data;
  bool isForHistory = false;
  ApiBlocBloc auth;
  RoundWidget round;
  // final GestureTapCallback onDeleteClick;
  final Function(int) onDeleteClick;

  CouponItem({@required this.data, this.isForHistory, this.onDeleteClick});

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
      padding: const EdgeInsets.all(0.0),
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
            getFooter(context, date),
          ],
        ),
      ),
    );
  }

  Padding getFooter(BuildContext context, String date) {
    return new Padding(
      // padding: EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 2.0),
      padding: EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 8.0, right: 8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 7,
                  child: Text(
                    data.couponCode,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 12.0,
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
          // Padding(
          //   padding: const EdgeInsets.only(top: 8.0, left: 8.0),
          //   child: Text(
          //     data.description,
          //     overflow: TextOverflow.ellipsis,
          //     maxLines: 1,
          //     style: TextStyle(
          //       color: Colors.black54,
          //       fontSize: 12.0,
          //     ),
          //   ),
          // ),
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
            padding: EdgeInsets.only(
                top: data.isFromHistory ? 4.0 : 0,
                left: data.isFromHistory ? 8.0 : 0),
            child: _staus(),
          ),
        ],
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
                  height: 16,
                  width: 16,
                  child: Image.asset("assets/images/pencils.png"))),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 0),
            child: GestureDetector(
                onTap: () {
                  // _showPopup(context, data.id, auth);
                  onDeleteClick(data.id);
                },
                child: SizedBox(
                    height: 16,
                    width: 16,
                    child: Image.asset("assets/images/bins.png"))),
          )
        ],
      );
    }
  }

  Widget getImage() {
    if (data != null && data.couponImage != null) {
      // return Image.network(
      //   data.couponImage,
      //   fit: BoxFit.cover,
      // );
      return CachedNetworkImage(
        imageUrl: data.couponImage,
        fit: BoxFit.cover,
        height: 100,
        width: 100,
        errorWidget: (context, url, error) => Image.asset(
          'assets/images/kfc.png',
          fit: BoxFit.cover,
        ),
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
  // var months = {
  //   '01': 'Jan',
  //   '02': 'Feb',
  //   '03': 'Mar',
  //   '04': 'Apr',
  //   '05': 'May',
  //   '06': 'Jun',
  //   '07': 'Jul',
  //   '08': 'Aug',
  //   '09': 'Sept',
  //   '10': 'Oct',
  //   '11': 'Nov',
  //   '12': 'Dec'
  // };

  if (isForHistory) {
    DateTime grabFormat = new DateFormat('yyyy/MM/dd').parse(grabDate);
    String grabDateFormat = new DateFormat('yyyy MMM dd').format(grabFormat);
    // var grabDateArray = grabDate.split("/");
    // var grabMonth = months[grabDateArray[1]];
    // return "Redeem Date: ${grabDateArray[2]} "
    //     "$grabMonth "
    //     "${grabDateArray[0]}";
    return "Redeem Date: $grabDateFormat";
  } else {
    DateFormat originalFormat = new DateFormat('yyyy/MM/dd');
    DateFormat convertFormat = new DateFormat('MMM dd');
    String startFormattedDate;
    String endFormattedDate;
    // var startDateArray = startDate.split("/");
    // var endDateArray = endDate.split("/");
    // var startMonth = months[startDateArray[1]];
    // var endMonth = months[endDateArray[1]];
    startFormattedDate =
        "" + convertFormat.format(originalFormat.parse(startDate)) + " To ";
    endFormattedDate = convertFormat.format(originalFormat.parse(endDate));
    // startFormattedDate = "Good from ${startDateArray[0]} "
    //     "$startMonth "
    //     "${startDateArray[2]} To ";
    // endFormattedDate = "${endDateArray[0]} " "$endMonth " "${endDateArray[2]}";
    return startFormattedDate + endFormattedDate;
  }
}

void _goToEditScreen(
    BuildContext context, Map<String, dynamic> data, ApiBlocBloc auth) async {
  var result = await Navigator.of(context)
      .pushNamed(EditCoupon.routeName, arguments: data);

  if (result) {
    auth.add(ReloadEvent(true));
  }
}
