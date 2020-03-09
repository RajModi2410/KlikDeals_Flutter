import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class CouponErrorWidget extends StatelessWidget {
  final String errorMessage;

  CouponErrorWidget({Key key, @required this.errorMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          child: Center(child: Text("$errorMessage")),
        ),
      ],
    );
  }
}
