import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:vendor/AppLocalizations.dart';
import '../commons/Dimensions.dart';

class ApprovedByPopupScreen extends StatefulWidget {
  String activeDealList;

  ApprovedByPopupScreen(this.activeDealList);

  @override
  _ApprovedByPopupScreenState createState() =>
      new _ApprovedByPopupScreenState(activeDealList);
}

class _ApprovedByPopupScreenState extends State<ApprovedByPopupScreen> {
  final String title = "ApprovedByPopupScreen";
  String activeDealList;
  final myController = TextEditingController();
  bool _isValid = true;
  RegExp exp;
  _ApprovedByPopupScreenState(this.activeDealList) {
    Pattern pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    exp = new RegExp(pattern);
  }

  bool isEmailValidator(String value) {
    print("we are getting $value");
    if (value.isEmpty) {
      return false;
    }
    print("not empty");
    return (exp.hasMatch(value));
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

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
                      'assets/images/warning_icon.png',
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
                      activeDealList,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: Dimensions.fontSize22,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 24, left: 16.0, right: 16.0),
                    child: Text(
                      "Please enter your email address so that we can help you for your password.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: Dimensions.fontSize12),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16.0, right: 16.0, top: 16),
                    child: new TextFormField(
                      cursorColor: Colors.black,
                      controller: myController,
                      style: TextStyle(color: Theme.of(context).primaryColor),
                      autofocus: false,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        fillColor: Color(0xB3FFFFFF),
                        filled: true,
                        hintStyle:
                            TextStyle(color: Theme.of(context).primaryColor),
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                            borderSide: BorderSide(color: Colors.grey)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey, style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(30.0)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey, style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(30.0)),
                        labelStyle:
                            TextStyle(color: Theme.of(context).primaryColor),
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 20.0, 10.0, 10.0),
                        errorText: !_isValid
                            ? 'Email must not be blank or invalid'
                            : null,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 8),
                    child: new FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        print("Approved By : " + myController.text);
                        setState(() {
                          _isValid = isEmailValidator(myController.text.trim());
                        });
                        print("we got validate $_isValid");
                        if (myController.text
                            .trim()
                            .isNotEmpty && _isValid) {
                          Navigator.of(context).pop(myController.text);
                        }
                      },
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Padding(
                            padding:
                                const EdgeInsets.only(top: 16.0, bottom: 16.0),
                            child: Text(
                                AppLocalizations.of(context)
                                    .translate("label_confirm"),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: 32, bottom: 8.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          AppLocalizations.of(context)
                              .translate("label_no_thanks"),
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline),
                        ),
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
