import 'package:flutter/material.dart';

class Coupon extends StatefulWidget {
  Coupon({Key key, this.title}) : super(key: key);
  final String title;

  // @override
  // State<StatefulWidget> createState() {
  //   // TODO: implement createState
  //   return null;
  // }
  _CouponAdd createState() => _CouponAdd();
}

class _CouponAdd extends State<Coupon> {
  String _Startdate = "Start Date";
  String _Expirydate = "Expiry Date";

//  TextEditingController _textFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Coupon'),
        backgroundColor: Colors.redAccent,
      ),
      body: Stack(children: <Widget>[
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/splash_bg.png'),
                  fit: BoxFit.cover)),
        ),
        new Padding(
          padding: const EdgeInsets.only(left: 28.0, right: 28.0, top: 8.0),
          child: Container(
            child: ListView(
              children: <Widget>[
                TextFormField(
                    cursorColor: Colors.redAccent,
                    decoration: _inputType("Coupon Code", false)),
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: TextFormField(
                      decoration: _forSearchInputType("Start Date", true)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: TextFormField(
                      decoration: _forSearchInputType("Expiry Date", true)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(width: 1, color: Colors.grey)),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 16.0, bottom: 8, left: 16, right: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                "Upload Coupon Image",
                                style: TextStyle(
                                    fontSize: 15.0, color: Colors.redAccent),
                              ),
                              Spacer(),
                              Icon(
                                Icons.attach_file,
                                color: Colors.redAccent,
                                size: 20,
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Image.asset(
                              'assets/images/kfc.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: TextFormField(
                      cursorColor: Colors.redAccent,
                      maxLines: 6,
                      decoration: _inputType("Description", false)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: RaisedButton(
                    padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                        side: BorderSide(color: Colors.redAccent)),
                    onPressed: () {},
                    color: Colors.red,
                    textColor: Colors.white,
                    child: Text("ADD COUPON".toUpperCase(),
                        style: TextStyle(fontSize: 14)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  InputDecoration _inputType(String hintText, bool isForImageUpload) {
    return InputDecoration(
      fillColor: Color(0xB3FFFFFF),
      filled: true,
      hintStyle: TextStyle(color: Colors.redAccent),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
          borderSide: BorderSide(color: Colors.grey)),
      border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(30.0)),
      labelStyle: TextStyle(color: Colors.redAccent),
      contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 10.0, 10.0),
      hintText: hintText,
    );
  }

  InputDecoration _forSearchInputType(String hintText, bool isForCal) {
    return InputDecoration(
      fillColor: Color(0xB3FFFFFF),
      filled: true,
      hintStyle: TextStyle(color: Colors.redAccent),
      suffixIcon: _InputsuffixIcon(isForCal),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
          borderSide: BorderSide(color: Colors.grey)),
      border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(30.0)),
      labelStyle: TextStyle(color: Colors.redAccent),
      contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 10.0, 10.0),
      hintText: hintText,
    );
  }

  _InputsuffixIcon(bool isForCal) {
    if (isForCal) {
      return new Icon(
        Icons.calendar_today,
        color: Colors.redAccent,
        size: 20,
      );
    } else {
      return new Icon(
        Icons.attach_file,
        color: Colors.redAccent,
        size: 20,
      );
    }
  }
}
