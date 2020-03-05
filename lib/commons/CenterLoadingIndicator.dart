import 'package:flutter/material.dart';

class CenterLoadingIndicator extends StatelessWidget {
  String message = "Please wait...";
  CenterLoadingIndicator({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(this.message != null ? this.message : "Please wait...",
                  style: TextStyle(
                    color: Colors.white
                  ),),
                  CircularProgressIndicator(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
