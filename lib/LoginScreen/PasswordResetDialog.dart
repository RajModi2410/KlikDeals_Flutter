import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:vendor/AppLocalizations.dart';
import '../commons/Dimensions.dart';

class PasswordResetDialog extends StatelessWidget{
  final bool isSuccess;
  final String titleToShow;
final String messageToShow;

  PasswordResetDialog(this.titleToShow, this.isSuccess, this.messageToShow);

  final String title = "PasswordResetDialog";

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          AnimatedContainer(
            padding: MediaQuery.of(context).viewInsets,
            duration: const Duration(milliseconds: 300),
            child: Card(
              elevation: 5,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16.0))),
              child: ConstrainedBox(
                //replace this Container with your Card
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width * 0.8,
                  maxWidth: MediaQuery.of(context).size.width * 0.8,
                  minHeight: MediaQuery.of(context).size.height * 0.40,
                ),
                child:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Image.asset(
                     isSuccess ? 'assets/images/alertDeal.png': 'assets/images/warning_icon.png' ,
                      color: Theme.of(context).primaryColor,
                      colorBlendMode: BlendMode.srcATop,
                      width: 500,
                      height: 100,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                    child: Text(
                      titleToShow,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: Dimensions.fontSize22,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                    child: Text(
                      messageToShow,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: Dimensions.fontSize16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 24),
                    child: new FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Padding(
                            padding:
                                const EdgeInsets.only(top: 16.0, bottom: 16.0),
                            child: Text(
                                AppLocalizations.of(context)
                                    .translate("label_ok"),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
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
