import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:vendor/ApiBloc/models/CouponListResponse.dart';
import 'package:vendor/commons/Dimensions.dart';

typedef onKlikDeal = void Function(Data, int);

class DetailScreenCell extends StatefulWidget {
  final Data data;
  bool isForHistory = false;

  // final GestureTapCallback onDeleteClick;
  final Function(int) onDeleteClick;
  final Function(Data) onEditClick;

  DetailScreenCell(
      {@required this.data,
      this.isForHistory,
      this.onDeleteClick,
      this.onEditClick});

  _DetailScreenCellState createState() =>
      _DetailScreenCellState(data, isForHistory, onDeleteClick, onEditClick);
}

class _DetailScreenCellState extends State<DetailScreenCell> {
  Uri dynamicLink;

  final Data data;
  bool isForHistory = false;

  // final GestureTapCallback onDeleteClick;
  final Function(int) onDeleteClick;
  final Function(Data) onEditClick;

  _DetailScreenCellState(
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
            children: <Widget>[
              ConstrainedBox(
                constraints: buildBoxConstraints(context),
                child: getCouponImage(context),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 8, right: 8, top: 8),
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
                  Padding(
                    padding: EdgeInsets.only(left: 8, right: 8, top: 2),
                    child: Center(
                      child: Text(
                        data.description,
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: Dimensions.fontSize11,
                            color: Colors.black),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 2, right: 2, top: 2),
                    child: Text(
                      "",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: Dimensions.fontSize10,
                          color: Colors.black54),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(left: 2, right: 2, top: 2.0, bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Center(
                              child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            elevation: 2.0,
                            color: Colors.white,
                            textColor: Colors.black,
                            onPressed: () => onEditClick(data),
                            child: Text("Edit",
                                style: TextStyle(
                                  fontSize: Dimensions.fontSize14,
                                )),
                          )),
                        ),
                        Expanded(
                            flex: 1,
                            child: Center(
                              child: RaisedButton(
                                elevation: 2.0,
                                 shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                                onPressed: () => onDeleteClick(data.id),
                                color: Theme.of(context).primaryColor,
                                textColor: Colors.white,
                                child: Text("Delete",
                                    style: TextStyle(
                                      fontSize: Dimensions.fontSize14,
                                    )),
                              ),
                            )),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
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
      minHeight: recommendedHeight,
      /*maxHeight: MediaQuery
          .of(context)
          .size
          .height * 0.20,*/
      maxHeight: recommendedHeight,
    );
  }

  Widget getCouponImage(BuildContext context) {
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
  }
}
