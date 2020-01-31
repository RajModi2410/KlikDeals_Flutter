import 'package:flutter/material.dart';

class BackgroundWidget extends StatelessWidget {
  const BackgroundWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child:Image.asset('assets/images/splash_bg.png',fit: BoxFit.contain,),
            ),
          ],
        ),
      ),
          );
  }
}
