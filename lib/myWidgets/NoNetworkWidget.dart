import 'package:flutter/material.dart';
import 'package:klik_deals/AppLocalizations.dart';
import 'package:klik_deals/commons/Dimence.dart';

class NoNetworkWidget extends StatelessWidget {
  final VoidCallback retry;

  const NoNetworkWidget({Key key, this.retry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black45,
      child: Center(
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Card(
              elevation: 5,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16.0))),
              child: SizedBox(
                //replace this Container with your Card
                width: MediaQuery.of(context).size.width * 0.80,
                height: MediaQuery.of(context).size.height * 0.50,
                child: Column(children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: double.infinity,
                    color: Theme.of(context).primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Image.asset(
                        "assets/images/warning_icon.png",
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.03,
                        left: MediaQuery.of(context).size.width * 0.05,
                        right: MediaQuery.of(context).size.width * 0.05),
                    child: Text(
                      "ALERT",
                      style: TextStyle(
                          fontSize: Dimence.fontSize16,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.01,
                        left: MediaQuery.of(context).size.width * 0.05,
                        right: MediaQuery.of(context).size.width * 0.05),
                    child: Text(
                      AppLocalizations.of(context).translate("error_connection_timeout"),
                      style: TextStyle(
                          fontSize: Dimence.fontSize14,
                          fontWeight: FontWeight.normal),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 24.0,
                        right: 24.0,
                        top: MediaQuery.of(context).size.height * 0.03),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding:
                              EdgeInsets.only(left: 16.0, right: 16.0, top: 8),
                          child: new FlatButton(
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Colors.red,
                                    width: 1,
                                    style: BorderStyle.solid),
                                borderRadius: BorderRadius.circular(50)),
                            color: Colors.white,
                            onPressed: (){
                              // Navigator.of(context).pop();
                              retry();
                            },
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(AppLocalizations.of(context).translate("label_retry"),
                                    style: TextStyle(
                                      color: Colors.red,
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
