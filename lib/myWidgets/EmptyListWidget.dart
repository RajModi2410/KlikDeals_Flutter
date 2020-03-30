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
          child: Padding(
            padding: const EdgeInsets.only(left:8.0,right: 8.0),
            child: Text("Oh ho! $emptyMessage", style:
            TextStyle(
              color: Theme.of(context).primaryColor
            ),),
          ),
        ),
      ],
    );
  }
}