import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:vendor/AppLocalizations.dart';
import 'package:vendor/commons/Dimensions.dart';


class SuccessDialog extends StatefulWidget {
  final String mainMessage;
  final String okButtonText;

  SuccessDialog({Key key,this.mainMessage, this.okButtonText})
      : super(key: key);

  @override
  _SuccessDialogState createState() => new _SuccessDialogState(message: this.mainMessage, okButtonText: this.okButtonText);
}

class _SuccessDialogState extends State<SuccessDialog> {
  String message = "You have saved successfully!";
  String okButtonText = "Okay";

  _SuccessDialogState({this.message, this.okButtonText});

  @override
  Widget build(BuildContext context) {
    message = (message != null ? message: AppLocalizations.of(context).translate("message_saved"));
    okButtonText= (okButtonText != null ? okButtonText: AppLocalizations.of(context).translate("label_ok"));
    return Center(
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.width / 6),
            child: Card(
              elevation: 5,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16.0))),
              child: SizedBox(
                //replace this Container with your Card
                width: MediaQuery.of(context).size.width * 0.80,
                height: MediaQuery.of(context).size.height * 0.40,
                child: Column(children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: double.infinity,
                    color: Theme.of(context).primaryColor,
                    child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Icon(Icons.thumb_up,
                            color: Colors.white, size: 64.0)
                        // Image.asset(
                        //   "assets/images/warning_icon.png",
                        // ),
                        ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.03,
                        left: MediaQuery.of(context).size.width * 0.05,
                        right: MediaQuery.of(context).size.width * 0.05),
                    child: Text(
                      AppLocalizations.of(context).translate("label_success"),
                      style: TextStyle(
                          fontSize: Dimensions.fontSize16,
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
                      message,
                      style: TextStyle(
                          fontSize: Dimensions.fontSize14,
                          fontWeight: FontWeight.normal),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 24.0,
                        right: 24.0,
                        // top: MediaQuery.of(context).size.height * 0.03
                        ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding:
                              EdgeInsets.only(left: 16.0, right: 16.0, top: 8),
                          child: new FlatButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              // confirmed(true);
                              Navigator.of(context).pop(true);
                            },
                            child: Text(okButtonText,
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
