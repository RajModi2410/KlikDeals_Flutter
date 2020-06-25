import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vendor/ApiBloc/models/CouponListResponse.dart';
import 'package:vendor/commons/Dimensions.dart';

typedef onKlikDeal = void Function(Data, int);

class HistoryScreenCell extends StatefulWidget {
  final Data data;
  bool isForHistory = false;

  // final GestureTapCallback onDeleteClick;
  final Function(int) onDeleteClick;
  final Function(Data) onEditClick;

  HistoryScreenCell(
      {@required this.data,
      this.isForHistory,
      this.onDeleteClick,
      this.onEditClick});

  _HistoryScreenCellState createState() =>
      _HistoryScreenCellState(data, isForHistory, onDeleteClick, onEditClick);
}

class _HistoryScreenCellState extends State<HistoryScreenCell> {
  Uri dynamicLink;

  final Data data;
  bool isForHistory = false;

  // final GestureTapCallback onDeleteClick;
  final Function(int) onDeleteClick;
  final Function(Data) onEditClick;

  _HistoryScreenCellState(
      this.data, this.isForHistory, this.onDeleteClick, this.onEditClick);

  String lat;
  String lng;
  String token;
  int couponId;

  @override
  void initState() {
    super.initState();
  }

  double recommendedHeight = 0;

  @override
  Widget build(BuildContext context) {
    recommendedHeight = Dimensions.getCellHeight(
        MediaQuery.of(context).size.height, MediaQuery.of(context).size.width);
    return Stack(
      key: UniqueKey(),
      alignment: Alignment.topCenter,
      children: <Widget>[
        Card(
          // color: cardColor,
          color: Colors.white,
          elevation: 5,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ConstrainedBox(
                constraints: buildBoxConstraints(context),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AspectRatio(
                      aspectRatio: 16 / 9, child: getCouponImage(context)),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 8, right: 8, top: 8),
                    child: Center(
                      child: Text(
                        data.couponCode.toUpperCase(),
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: Dimensions.fontSize18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8, right: 8, top: 2),
                    child: Center(
                      child: getApprovedBy(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8, right: 8, top: 2),
                    child: Center(
                      child: getRedeemDate(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8, right: 8, top: 2),
                    child: Center(
                      child: _status(),
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  getApprovedBy() {
    if (data.approvedBy != null) {
      return Padding(
        padding: const EdgeInsets.only(top: 4.0, left: 8.0),
        child: Text(
          "Approved By: ${data.approvedBy}",
          style: TextStyle(
            fontSize: 14.0,
            color: Color(0xff434A5E),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget getRedeemDate() {
    String date;
    date = dateFormatter("", "", data.approvedDate);
    if (data.approvedBy != null) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 8.0),
        child: Text(
          date,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
            color: Color(0xff434A5E),
            fontSize: 12.0,
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _status() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        "Status: ${data.statusName}",
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: TextStyle(
          color: Color(0xff4C536A),
          fontSize: 12.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String dateFormatter(String startDate, String endDate, String grabDate) {
    if (grabDate != null) {
      DateTime grabFormat =
          new DateFormat('yyyy-MM-dd HH:mm:ss').parse(grabDate);
      String grabDateFormat = new DateFormat('dd-MMM-yyyy').format(grabFormat);
      return "Redeem at: $grabDateFormat";
    } else {
      return null;
    }
  }

  TextStyle buildTextStyle(BuildContext context) {
    return TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: Dimensions.fontSize14,
        fontWeight: FontWeight.bold);
  }

  BoxConstraints buildBoxConstraints(BuildContext context) {
    print("we got total height: ${MediaQuery.of(context).size.height}");
    return BoxConstraints(
      //replace this Container with your Card
      minWidth: MediaQuery.of(context).size.width * 1,
      minHeight: recommendedHeight / 3,
      /*maxHeight: MediaQuery
          .of(context)
          .size
          .height * 0.20,*/
//      maxHeight: recommendedHeight,
    );
  }

  /*Widget getCouponImage(BuildContext context) {
    // print("we are getting getCouponImage: ${data.couponImage}");
    if (data.couponImage == null) {
      return Image.asset(
        "assets/images/main_logo.png",
        fit: BoxFit.cover,
        colorBlendMode: BlendMode.darken,
        color: Colors.black.withOpacity(0.2),
        // width: MediaQuery.of(context).size.width * 0.9,
        height: recommendedHeight,
      );
    } else {
      return CachedNetworkImage(
        height: recommendedHeight,
        fit: BoxFit.cover,
        imageUrl: data.couponImage,
        colorBlendMode: BlendMode.darken,
        color: Colors.black.withOpacity(0.2),
        errorWidget: (context, url, error) {
          print("we got error : $error");
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Image.asset(
                "assets/images/main_logo.png",
                fit: BoxFit.cover,
                colorBlendMode: BlendMode.darken,
                color: Colors.black.withOpacity(0.2),
                // width: MediaQuery.of(context).size.width,
                height: recommendedHeight,
              ),
            ),
          );
        },
      );
    }
  }*/

  Widget getCouponImage(BuildContext context) {
    BoxFit singles = BoxFit.contain;
    if (data != null && data.couponImage != null) {
      return CachedNetworkImage(
        imageUrl: data.couponImage,
        fit: singles,
//        height: recommendedHeight,
        errorWidget: (context, url, error) => Padding(
          padding: const EdgeInsets.all(32.0),
          child: Image.asset(
            'assets/images/main_logo.png',
            fit: singles,
          ),
        ),
      );
    } else {
      return Image.asset(
        'assets/images/main_logo.png',
        fit: singles,
//          height: recommendedHeight,
      );
    }
  }
}
