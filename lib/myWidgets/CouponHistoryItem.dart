import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vendor/ApiBloc/models/CouponListResponse.dart';

class CouponHistoryItem extends StatelessWidget {
  final Data data;
  // final GestureTapCallback onDeleteClick;

  CouponHistoryItem({@required this.data});

  @override
  Widget build(BuildContext context) {
    String date;
    date = "";//dateFormatter("", "", data.approvedDate);
    return couponList(context, date);
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
                  child: getCouponCodeText(),
                ),
              ],
            ),
          ),
          getApprovedBy(),
          getRedeemDate(date),
          Padding(
            padding: EdgeInsets.only(top: 8.0, left: 8.0),
            child: _status(),
          ),
        ],
      ),
    );
  }

  Widget getRedeemDate(String date) {
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

  Text getCouponCodeText() {
    return Text(
      data.couponCode,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: TextStyle(
        fontSize: 16.0,
        color: Color(0xff434A5E),
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Row getActions(BuildContext context) {
    return Row();
  }

  Widget getImage() {
    if (data != null && data.couponImage != null) {
      return CachedNetworkImage(
        imageUrl: data.couponImage,
        fit: BoxFit.cover,
        height: 100,
        width: 100,
        errorWidget: (context, url, error) => Image.asset(
          'assets/images/logo.png',
          fit: BoxFit.cover,
        ),
      );
    } else {
      return Image.asset(
        'assets/images/logo.png',
        fit: BoxFit.cover,
      );
    }
  }

  Widget _status() {
    return Text(
      "Status: ${data.statusName}",
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: TextStyle(
        color: Color(0xff4C536A),
        fontSize: 12.0,
        fontWeight: FontWeight.w500,
      ),
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
}

String dateFormatter(String startDate, String endDate, String grabDate) {
  if (grabDate != null) {
    DateTime grabFormat = new DateFormat('yyyy-MM-dd HH:mm:ss').parse(grabDate);
    String grabDateFormat = new DateFormat('dd-MM-yyyy').format(grabFormat);
    return "Redeem at: $grabDateFormat";
  } else {
    return null;
  }
}