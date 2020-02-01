import 'package:flutter/material.dart';
import 'package:klik_deals/ApiBloc/index.dart';
import 'package:meta/meta.dart';

class CouponErrorWidget extends StatelessWidget {
  couponApiErrorState state;

  CouponErrorWidget({Key key, @required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          child: Center(child: Text("${this.state.couponlist.errorMessage.error[0]}")),
        ),
      ],
    );
  }
}
