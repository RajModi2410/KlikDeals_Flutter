import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart';

class RoundWidget extends StatelessWidget {
  const RoundWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: Loading(indicator: BallSpinFadeLoaderIndicator(), size: 100.0, color: Colors.pink),
        ),
    );
  }
}