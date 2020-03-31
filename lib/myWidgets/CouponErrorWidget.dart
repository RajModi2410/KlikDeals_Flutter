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
          child: Center(child: Padding(
            padding: const EdgeInsets.only(left:16.0,right: 16.0),
            child: Text("$errorMessage", style: TextStyle(
              color: Theme.of(context).primaryColor
            ),textAlign: TextAlign.center,),
          )),
        ),
      ],
    );
  }
}
