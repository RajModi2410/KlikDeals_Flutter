import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vendor/ApiBloc/models/CouponListResponse.dart';

class CouponItem extends StatelessWidget {
  final Data data;
  bool isForHistory = false;
  // final GestureTapCallback onDeleteClick;
  final Function(int) onDeleteClick;
  final Function(Data) onEditClick;
  double recommendedHeight = 0;
  
  CouponItem(
      {@required this.data,
      this.isForHistory,
      this.onDeleteClick,
      this.onEditClick});

  @override
  Widget build(BuildContext context) {
    String date;
    date = ""; //dateFormatter(data.startDate, data.endDate, isForHistory, "");
    // recommendedHeight = MediaQuery.of(context).size.height  * 0.3;
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
              child: AspectRatio(
                aspectRatio: 1.76,
                child: getImage(),
              ),
            ),
            // ConstrainedBox(
            //   constraints: buildBoxConstraints(context),
            //   child: getImage(),
            // ),
            getFooter(context, date),
          ],
        ),
      ),
    );
  }

BoxConstraints buildBoxConstraints(BuildContext context) {
    print("we got total height: ${MediaQuery.of(context).size.height}");
    return BoxConstraints(
      //replace this Container with your Card
      minWidth: MediaQuery.of(context).size.width * 1,
      minHeight: recommendedHeight,
      /*maxHeight: MediaQuery
          .of(context)
          .size
          .height * 0.20,*/
      maxHeight: recommendedHeight,
    );
  }
  Padding getFooter(BuildContext context, String date) {
    return new Padding(
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
                    // overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Color(0xff434A5E),
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
            padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
            child: Text(
              data.description,
              // overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12.0,
                color: Color(0xff434A5E),
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          // showDate(date),
        ],
      ),
    );
  }

  Padding showDate(String date) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 8.0),
      child: Text(
        date,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: TextStyle(
          color: Colors.black54,
          fontSize: 12.0,
        ),
      ),
    );
  }

  Row getActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        GestureDetector(
            onTap: () {
              // _goToEditScreen(context, data.toJson(), auth);
              onEditClick(data);
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
        errorWidget: (context, url, error) => Padding(
          padding: const EdgeInsets.all(32.0),
          child: Image.asset(
            'assets/images/main_logo.png',
            fit: BoxFit.contain,
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(32.0),
        child: Image.asset(
          'assets/images/main_logo.png',
          fit: BoxFit.contain,
        ),
      );
    }
  }
}

String dateFormatter(
    String startDate, String endDate, bool isForHistory, String grabDate) {
  if (isForHistory) {
    DateTime grabFormat = new DateFormat('yyyy/MM/dd').parse(grabDate);
    String grabDateFormat = new DateFormat('yyyy MMM dd').format(grabFormat);
    return "Redeem at: $grabDateFormat";
  } else {
    DateFormat originalFormat = new DateFormat('yyyy/MM/dd');
    DateFormat convertFormat = new DateFormat('MMM dd');
    String startFormattedDate;
    String endFormattedDate;
    startFormattedDate = "Good from " +
        convertFormat.format(originalFormat.parse(startDate)) +
        " To ";
    endFormattedDate = convertFormat.format(originalFormat.parse(endDate));
    return startFormattedDate + endFormattedDate;
  }
}
