import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:klik_deals/ImagePickerFiles/Image_picker_handler.dart';

class Coupon extends StatefulWidget {
  Coupon({Key key, this.title}) : super(key: key);
  final String title;

  _CouponAdd createState() => _CouponAdd();
}

class _CouponAdd extends State<Coupon>
    with TickerProviderStateMixin, ImagePickerListener {
  DateTime _Startdate;
  String _Expirydate = "Expiry Date";
  AnimationController _controller;
  ImagePickerHandler imagePicker;
  File _imageBanner;

  TextEditingController _startDateController =
  TextEditingController(text: 'Satrt Date');
  TextEditingController _endDateController =
  TextEditingController(text: 'Expiry Date');

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    imagePicker = new ImagePickerHandler(this, _controller);
    imagePicker.init();
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      style: TextStyle(color: Colors.redAccent),
                      cursorColor: Colors.redAccent,
                      decoration: _inputType("Coupon Code", false)),
                  Padding(
                    padding: const EdgeInsets.only(top: 32.0),
                    child: TextFormField(
                        validator: (value) {
                          if (value == "Satrt Date") {
                            return 'Please selecct start date';
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.redAccent),
                        controller: _startDateController,
                        onTap: () {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          _showStartDatePicker(context);
                        },
                        decoration: _forSearchInputType("Start Date", true)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 32.0),
                    child: TextFormField(
                        validator: (value) {
                          if (value == "Expiry Date") {
                            return 'Please select expiry date';
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.redAccent),
                        controller: _endDateController,
                        onTap: () {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          if (_Startdate != null && _Startdate != "") {
                            _showEndDatePicker(context, _Startdate);
                          } else {
                            final snackBar = SnackBar(
                              backgroundColor: Colors.redAccent,
                              content: Text("Please select start date first"),
                            );
                            _scaffoldKey.currentState.showSnackBar(snackBar);
                          }
                        },
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
                            top: 16.0, bottom: 16, left: 16, right: 16),
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
                                IconButton(
                                  icon: new Icon(Icons.attach_file),
                                  iconSize: 20,
                                  color: Colors.redAccent,
                                  onPressed: () {
                                    imagePicker.showDialog(context);
                                  },
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: _imageBanner == null
                                  ? new Stack(
                                children: <Widget>[
                                  new Center(
                                    child: new CircleAvatar(
                                        radius: 00.0,
                                        backgroundColor: Colors.white),
                                  ),
                                  new Center(
                                    child: new Image.asset(
                                        "images/color samples-01.png"),
                                  ),
                                ],
                              )
                                  : new Container(
                                height: 160.0,
                                width: 360.0,
                                decoration: new BoxDecoration(
                                  color: const Color(0xff7c94b6),
                                  image: new DecorationImage(
                                    image: new ExactAssetImage(
                                        _imageBanner.path),
                                    fit: BoxFit.cover,
                                  ),
                                  border: Border.all(
                                      color: Colors.white, width: 0.5),
                                  // borderRadius:
                                  //     new BorderRadius.all(const Radius.circular(80.0)
                                  //     ),
                                ),
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
                        validator: (value) {
                          if (value.isEmpty && value == null) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        cursorColor: Colors.redAccent,
                        maxLines: 6,
                        decoration: _inputType("Description", false)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 32.0, bottom: 16),
                    child: RaisedButton(
                      padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                          side: BorderSide(color: Colors.redAccent)),
                      onPressed: () {
                        _validateRequiredFields();
                      },
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

  //Start date date picker
  void _showStartDatePicker(BuildContext context) {
    final now = DateTime.now();
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(now.year, now.month, now.day + 1),
        maxTime: DateTime(now.year + 1, now.month, now.day),
        onChanged: (date) {
          _endDateController.clear();
          print('change $date');
        },
        onConfirm: (date) {
          _Startdate = date;
          var formatter = new DateFormat('yyyy-MM-dd');
          String formatted = formatter.format(date);
          print('confirm $date');
          setState(() {
            _startDateController.text = formatted.toString();
          });
        },
        currentTime: DateTime.now(),
        locale: LocaleType.en);
  }

  //End date date picker
  void _showEndDatePicker(BuildContext context, DateTime startDate) {
    final now = DateTime.now();
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(startDate.year, startDate.month, startDate.day + 1),
        maxTime: DateTime(now.year + 1, now.month, now.day),
        onChanged: (date) {
          print('change $date');
        },
        onConfirm: (date) {
          var formatter = new DateFormat('yyyy-MM-dd');
          String formatted = formatter.format(date);
          print('confirm $date');
          setState(() {
            _endDateController.text = formatted.toString();
          });
        },
        currentTime: DateTime.now(),
        locale: LocaleType.en);
  }

  void _validateRequiredFields() {
    if (_formKey.currentState.validate()) {
      print("All is Well");
    } else {
      print("Some error found");
    }
  }

  @override
  userImage(File _image) {
    setState(() {
      this._imageBanner = _image;
    });
  }
}
