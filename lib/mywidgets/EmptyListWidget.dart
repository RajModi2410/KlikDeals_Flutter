import 'package:flutter/material.dart';

class EmptyListWidget extends StatelessWidget {
  final String emptyMessage;
  
  EmptyListWidget({Key key,@required this.emptyMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("we here: $emptyMessage");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          child: Text("Oh ho! $emptyMessage"),
        ),
      ],
    );
  }
}