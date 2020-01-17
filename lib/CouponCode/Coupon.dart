import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

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
  // String

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
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                elevation: 5.0,
                  shadowColor: Colors.lightGreen,
                  child: Container(
                    color: Colors.white,
                    child: TextFormField(
                      // maxLines: 8,
                      // minLines: 6,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),

                        hintText: 'Description',
                        // border: OutlineInputBorder(
                        //     borderRadius: BorderRadius.circular(8.0)),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  elevation: 4.0,
                  onPressed: () {
                    DatePicker.showDatePicker(context,
                        theme: DatePickerTheme(
                          containerHeight: 210.0,
                        ),
                        showTitleActions: true,
                        minTime: DateTime(2000, 1, 1),
                        maxTime: DateTime(2022, 12, 31), onConfirm: (date) {
                      print('confirm $date');
                      _Startdate = '${date.year} - ${date.month} - ${date.day}';
                      setState(() {});
                    }, currentTime: DateTime.now(), locale: LocaleType.en);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "$_Startdate",
                                    style: TextStyle(
                                        color: Colors.teal,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        Icon(
                          Icons.date_range,
                          size: 18.0,
                          color: Colors.teal,
                        ),
                        // Text(
                        //   "Change",
                        //   style: TextStyle(
                        //     color: Colors.teal,
                        //       fontWeight: FontWeight.bold,
                        //       fontSize: 18.0),
                        // ),
                      ],
                    ),
                  ),
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  elevation: 4.0,
                  onPressed: () {
                    DatePicker.showDatePicker(context,
                        theme: DatePickerTheme(
                          containerHeight: 210.0,
                        ),
                        showTitleActions: true,
                        minTime: DateTime(2000, 1, 1),
                        maxTime: DateTime(2022, 12, 31), onConfirm: (date) {
                      print('confirm $date');
                      _Expirydate = '${date.year} - ${date.month} - ${date.day}';
                      setState(() {});
                    }, currentTime: DateTime.now(), locale: LocaleType.en);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "$_Expirydate",
                                    style: TextStyle(
                                        color: Colors.teal,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        Icon(
                          Icons.date_range,
                          size: 18.0,
                          color: Colors.teal,
                        ),
                      ],
                    ),
                  ),
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                elevation: 5.0,
                  shadowColor: Colors.lightGreen,
                  child: Container(
                    color: Colors.white,
                    child: TextFormField(
                      maxLines: 8,
                      minLines: 6,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),

                        hintText: 'Description',
                        // border: OutlineInputBorder(
                        //     borderRadius: BorderRadius.circular(8.0)),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 8),
                child: Container(
                  width: double.infinity,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    onPressed: () {
                      // Navigator.of(context).pushNamed(HomePage.tag);
                    },
                    padding: EdgeInsets.all(12),
                    color: Colors.lightGreenAccent[700],
                    child: Text('ADD COUPON',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
