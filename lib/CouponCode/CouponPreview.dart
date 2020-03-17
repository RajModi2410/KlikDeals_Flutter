import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CouponPreview extends StatefulWidget {
  final SingleDetails item;
  CouponPreview({Key key, this.item}) : super(key: key);

  @override
  _CouponPreviewState createState() => _CouponPreviewState(this.item);
}

class SingleDetails {
  int id;
  String vendorId;
  String couponCode;
  String couponImage;
  String description;
  String status;
  String grabDate;
  String startDate;
  String endDate;
  bool isSelected = false;
  bool isFile;

  SingleDetails.staticReport() {
    id = 23;
    vendorId = "39";
    couponCode = "COUPON-51";
    couponImage =
        "https://wdszone.com/klikdeals/images/coupon/1583998857_image_picker_ba76cfe2-4e1a-4d27-afe0-6db005763224-35815-000085f23be41053.jpg";
    description = "This is the description";
    status = "DEMO11";
    grabDate = null;
    startDate = "2020/03/12";
    endDate = "2070/02/2";
    isSelected = false;
    isFile = false;
  }
}

class _CouponPreviewState extends State<CouponPreview> {
  final SingleDetails item;

  _CouponPreviewState(this.item);

  Widget getCouponImage(BuildContext context) {
    if (item.couponImage == null) {
      return Image.asset(
        "assets/images/coupon.jpg",
        width: MediaQuery.of(context).size.width,
        // width: 300,
        height: MediaQuery.of(context).size.height * 0.25,
        fit: BoxFit.fill,
      );
    } else {
      return CachedNetworkImage(
        // width: 300,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.25,
        fit: BoxFit.fill, imageUrl: item.couponImage,
        errorWidget: (context, url, serror) {
          return Image.asset(
            "assets/images/coupon.jpg",
            width: MediaQuery.of(context).size.width,
            // width: 300,
            height: MediaQuery.of(context).size.height * 0.25,
            fit: BoxFit.fill,
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black.withOpacity(0.6),
      body: SizedBox.expand(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.cancel,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            Expanded(
              child: Container(
                child: Center(
                  child: Wrap(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.width / 18),
                        child: Card(
                          // color: cardColor,
                          color: Colors.white,
                          elevation: 5,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16.0))),
                          child: SizedBox(
                            //replace this Container with your Card
                            width: MediaQuery.of(context).size.width * 1,
                            height: MediaQuery.of(context).size.height * 0.20,
                            child: Row(children: <Widget>[
                              Expanded(
                                flex: 5,
                                child: Stack(
                                  children: <Widget>[
                                    ClipPath(
                                      clipBehavior: Clip.antiAlias,
                                      child: getCouponImage(context),
                                      clipper: new MyClipper(),
                                    ),
                                    ClipPath(
                                      child: Container(
                                        color: Color.fromARGB(100, 0, 0, 0),
                                      ),
                                      clipper: new MyClipper(),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.03),
                                      child: Text(
                                        item.couponCode,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 2, right: 2, top: 2),
                                      child: Text(
                                        item.description,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 11, color: Colors.black),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 2, right: 2, top: 2),
                                      child: Text(
                                        (item.startDate +
                                            " TO " +
                                            item.endDate),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.black54),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 2,
                                          right: 2,
                                          top: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.05),
                                      child: InkWell(
                                        onTap: () {
                                          // onKlikDeals(item, index);
                                        },
                                        child: Text(
                                          "KLIK THE DEAL",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Color(0xff0DB84D)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0.0, size.height);
    path.lineTo(size.width * 0.9, size.height);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
