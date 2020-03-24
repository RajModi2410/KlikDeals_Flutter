import 'package:flutter/material.dart';

class BackgroundWidget extends StatelessWidget {
  const BackgroundWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      foregroundDecoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/splash_bg.webp'),
              fit: BoxFit.cover)),
    );
  }
}
