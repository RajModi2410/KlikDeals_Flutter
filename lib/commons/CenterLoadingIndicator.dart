import 'package:flutter/material.dart';

class CenterLoadingIndicator extends StatelessWidget {
  String message = "Please wait...";
  CenterLoadingIndicator({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black45,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: MediaQuery
                .of(context)
                .size
                .width * 0.15, right: MediaQuery
                .of(context)
                .size
                .width * 0.15),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              color: Colors.white,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 16.0, bottom: 16.0, right: 8.0),
                  child: Row(
//                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          this.message != null
                              ? this.message
                              : "Please wait...", textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      CircularProgressIndicator(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
