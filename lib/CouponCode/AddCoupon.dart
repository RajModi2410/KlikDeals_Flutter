import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:klik_deals/ApiBloc/ApiBloc_bloc.dart';
import 'package:klik_deals/ApiBloc/ApiBloc_event.dart';
import 'package:klik_deals/ApiBloc/ApiBloc_state.dart';
import 'package:klik_deals/ApiBloc/models/CouponListResponse.dart';
import 'package:klik_deals/HomeScreen/HomeState.dart';
import 'package:klik_deals/ImagePickerFiles/Image_picker_handler.dart';
import 'package:klik_deals/mywidgets/RoundWidget.dart';

import 'CouponStates.dart';

class AddCoupon extends StatefulWidget {
  final Map<String, dynamic> map;
  bool isFromEdit = false;

  AddCoupon({Key key, this.map, this.isFromEdit}) : super(key: key);

  _CouponAdd createState() => _CouponAdd(map, isFromEdit);
}

class _CouponAdd extends State<AddCoupon>
    with TickerProviderStateMixin, ImagePickerListener {
  DateTime _Startdate;
  AnimationController _controller;
  ImagePickerHandler imagePicker;
  File _imageBanner;
  bool _isLoading;
  Map<String, dynamic> mapData;
  bool isFromEdit = false;
  Data data;
  ApiBlocBloc auth;
  RoundWidget round;
  String _couponCodeValue;
  String _startDateValue;
  String _endDateValue;
  String _descValue;

  TextEditingController _startDateController,
      _endDateController,
      _couponCodeController,
      _descriptionController;

  _CouponAdd(this.mapData, this.isFromEdit);

  @override
  void initState() {
    super.initState();
    if (isFromEdit) {
      data = Data.fromJson(mapData);
    }
    _isLoading = false;
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _startDateController =
        TextEditingController(text: _getText(data, isFromEdit, "StartDate"));
    _endDateController =
        TextEditingController(text: _getText(data, isFromEdit, "EndDate"));
    _couponCodeController =
        TextEditingController(text: _getText(data, isFromEdit, "CouponCode"));
    _descriptionController =
        TextEditingController(text: _getText(data, isFromEdit, "Desc"));

    imagePicker = new ImagePickerHandler(this, _controller);
    imagePicker.init();
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    auth = BlocProvider.of<ApiBlocBloc>(context);
    return Stack(children: <Widget>[
      AddCouponDesign(context),
      BlocListener<ApiBlocBloc, ApiBlocState>(
          listener: (context, state) {
            if (state is CouponApiErrorState) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text("Somthing went to wrong. Please check again"),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state is CouponListFetchedState) {}
          },
          child: BlocBuilder<ApiBlocBloc, ApiBlocState>(
              bloc: auth,
              builder: (
                BuildContext context,
                ApiBlocState currentState,
              ) {
                if (currentState is ApiFetchingState) {
                  round = RoundWidget();
                  return round;
                } else {
                  return Container();
                }
              }))
    ]);
  }

  Widget AddCouponDesign(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(isFromEdit ? "Edit Coupon" : "Add Coupon"),
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
                  _couponCode(),
                  _startDate(context),
                  _expiryDate(context),
                  _uploadImage(context),
                  _description(),
                  _addCouponButton(),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Padding _addCouponButton() {
    return Padding(
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
        child: Text("ADD COUPON".toUpperCase(), style: TextStyle(fontSize: 14)),
      ),
    );
  }

  Padding _description() {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: TextFormField(
          onSaved: (value) => _descValue = value.trim(),
          controller: _descriptionController,
          validator: (value) {
            if (value.isEmpty || value == null) {
              return 'Please enter some text';
            }
            return null;
          },
          cursorColor: Colors.redAccent,
          maxLines: 6,
          decoration: _inputType("Description", false)),
    );
  }

  Padding _uploadImage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(width: 1, color: Colors.grey)),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 16.0, bottom: 16, left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    "Upload Coupon Image",
                    style: TextStyle(fontSize: 15.0, color: Colors.redAccent),
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
                                radius: 00.0, backgroundColor: Colors.white),
                          ),
                          new Center(
                            child:
                                new Image.asset("images/color samples-01.png"),
                          ),
                        ],
                      )
                    : new Container(
                        height: 160.0,
                        width: 360.0,
                        decoration: new BoxDecoration(
                          color: const Color(0xff7c94b6),
                          image:
                              _CouponImage(isFromEdit, _imageBanner.path, data),
                          border: Border.all(color: Colors.white, width: 0.5),
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
    );
  }

  Padding _expiryDate(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: TextFormField(
          onSaved: (value) => _endDateValue = value.trim(),
          validator: (value) {
            if (value == null || value.isEmpty) {
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
    );
  }

  Padding _startDate(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: TextFormField(
          onSaved: (value) => _startDateValue = value.trim(),
          validator: (value) {
            if (value == null || value.isEmpty) {
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
    );
  }

  TextFormField _couponCode() {
    return TextFormField(
        controller: _couponCodeController,
        onSaved: (value) => _couponCodeValue = value.trim(),
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
        style: TextStyle(color: Colors.redAccent),
        cursorColor: Colors.redAccent,
        decoration: _inputType("Coupon Code", false));
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
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
          borderSide: BorderSide(color: Colors.grey)),
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
        maxTime: DateTime(now.year + 1, now.month, now.day), onChanged: (date) {
      _endDateController.clear();
      print('change $date');
    }, onConfirm: (date) {
      _Startdate = date;
      var formatter = new DateFormat('yyyy/MM/dd');
      String formatted = formatter.format(date);
      print('confirm $date');
      setState(() {
        _startDateController.text = formatted.toString();
      });
    }, currentTime: DateTime.now(), locale: LocaleType.en);
  }

  //End date date picker
  void _showEndDatePicker(BuildContext context, DateTime startDate) {
    final now = DateTime.now();
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(startDate.year, startDate.month, startDate.day + 1),
        maxTime: DateTime(now.year + 1, now.month, now.day), onChanged: (date) {
      print('change $date');
    }, onConfirm: (date) {
      var formatter = new DateFormat('yyyy/MM/dd');
      String formatted = formatter.format(date);
      print('confirm $date');
      setState(() {
        _endDateController.text = formatted.toString();
      });
    }, currentTime: DateTime.now(), locale: LocaleType.en);
  }

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _validateRequiredFields() {
    if (validateAndSave()) {
      print(":::::::::::::::We get coupon data :::::::::::");
      print(_couponCodeValue);
      print(_startDateValue);
      print(_endDateValue);
      print(_descValue);
      print(_imageBanner);
      try {
        auth.add(AddCouponEvent(_couponCodeValue, _startDateValue,
            _endDateValue, _descValue, _imageBanner));
        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  @override
  userImage(File _image) {
    setState(() {
      this._imageBanner = _image;
    });
  }
}

_CouponImage(bool isFromEdit, String path, Data data) {
  if (isFromEdit) {
    return new DecorationImage(
      image: new ExactAssetImage(path),
      fit: BoxFit.cover,
    );
  } else {
    return new DecorationImage(
      image: new NetworkImage(
          'http://www.google.de/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png'),
      fit: BoxFit.cover,
    );
  }
}

String _getText(Data data, bool isFromEdit, type) {
  switch (type) {
    case "StartDate":
      {
        return isFromEdit ? data.startDate : "";
      }
      break;

    case "EndDate":
      {
        return isFromEdit ? data.endDate : "";
      }
      break;

    case "CouponCode":
      {
        return isFromEdit ? data.couponCode : "";
      }
      break;

    case "Desc":
      {
        return isFromEdit ? data.description : "";
      }
      break;
  }
}
