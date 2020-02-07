import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klik_deals/ApiBloc/ApiBloc_bloc.dart';
import 'package:klik_deals/ApiBloc/ApiBloc_state.dart';
import 'package:klik_deals/ApiBloc/index.dart';
import 'package:klik_deals/ApiBloc/models/CouponListResponse.dart';
import 'package:klik_deals/CouponCode/AddCoupon.dart';
import 'package:klik_deals/HomeScreen/HomeState.dart';

import 'RoundWidget.dart';

class listDetails extends StatelessWidget {
  Data data;
  bool isForHistory;
  ApiBlocBloc auth;
  RoundWidget round;

  listDetails({@required this.data, this.isForHistory});

  @override
  Widget build(BuildContext context) {
    auth = BlocProvider.of<ApiBlocBloc>(context);
    return Stack(children: <Widget>[
      couponList(context),
      BlocListener<ApiBlocBloc, ApiBlocState>(
          listener: (context, state) {
            if (state is CouponDeleteErrorState) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      state.deleteCouponResponse.errorMessage.toString()),
                  backgroundColor: Colors.red,
                ),);
            } else if (state is CouponDeleteFetchedState) {
              print("Delete coupon successfully :: ${state.deleteCouponResponse
                  .message}");
            }
          },
          child: BlocBuilder<ApiBlocBloc, ApiBlocState>(
              bloc: auth,
              builder: (BuildContext context,
                  ApiBlocState currentState,) {
                if (currentState is ApiFetchingState) {
                  round = RoundWidget();
                  return round;
                } else {
                  return Container();
                }
              }))
    ]);
  }

  Widget couponList(BuildContext context) {
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
                          child: Row(
                            children: <Widget>[
                              GestureDetector(
                                  onTap: () {
                                    _goToEditScreen(context, data.toJson());
                                  },
                                  child: Icon(Icons.edit, size: 20,)),
                              Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: GestureDetector(
                                    onTap: () {
                                      _showPopup(context, data.id, auth);
                                    },
                                    child: Icon(Icons.delete, size: 20,)),
                              )
                            ],
                          ),
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
                  ), Padding(
                    padding: const EdgeInsets.only(top: 4.0, left: 8.0),
                    child: Text(
                      "Redeem Data: 24 Feb 2019",
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


void _goToEditScreen(BuildContext context, Map<String, dynamic> data) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddCoupon(map: data, isFromEdit: true),
      ));
}
