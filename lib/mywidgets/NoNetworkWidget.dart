import 'package:flutter/material.dart';
import 'package:klik_deals/commons/KeyConstant.dart';

class NoNetworkWidget extends StatelessWidget {
  final VoidCallback retry;

  const NoNetworkWidget({Key key, this.retry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/splash_bg.png'),
                  fit: BoxFit.cover)),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Wrap(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(KeyConstant.NO_INTERNET),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: OutlineButton(
                          // shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.lerp(a, b, t)),
                            onPressed: retry,
                            focusColor: Theme.of(context).primaryColor,
                            color: Colors.white,
                            child: Text(
                              "Retry",
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}
