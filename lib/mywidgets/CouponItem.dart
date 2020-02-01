import 'package:flutter/material.dart';
import 'package:klik_deals/ApiBloc/models/CouponListResponse.dart';

class listDetails extends StatelessWidget {
  Data data;

  listDetails(this.data);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme
        .of(context)
        .textTheme
        .display1;
    /* if (selected)
      textStyle = textStyle.copyWith(color: Colors.lightGreenAccent[400]);*/
    return Card(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            new Container(
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.topLeft,
                child: Icon(
                  Icons.ac_unit,
                  size: 80.0,
                  color: textStyle.color,
                )),
            new Expanded(
                child: new Container(
                  padding: const EdgeInsets.all(10.0),
                  alignment: Alignment.topLeft,
                  child: Text(
                    data.couponCode,
                    style: null,
                    textAlign: TextAlign.left,
                    maxLines: 5,
                  ),
                )),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ));
  }
}