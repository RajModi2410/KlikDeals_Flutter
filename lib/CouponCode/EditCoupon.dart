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

class EditCoupon extends StatefulWidget {
  final Map<String, dynamic> map;

  EditCoupon({Key key, this.map}) : super(key: key);

  _EditCoupon createState() => _EditCoupon(map);
}

class _EditCoupon extends State<EditCoupon>
    with TickerProviderStateMixin, ImagePickerListener {
  DateTime _Startdate;
  AnimationController _controller;
  ImagePickerHandler imagePicker;
  bool _isLoading;
  Map<String, dynamic> mapData;
  File _imageBanner;
  bool isDirty = false;
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

  _EditCoupon(this.mapData);

  @override
  void initState() {
    super.initState();
    data = Data.fromJson(mapData);
    _isLoading = false;
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _startDateController = TextEditingController(text: data.startDate);
    _endDateController = TextEditingController(text: data.endDate);
    _couponCodeController = TextEditingController(text: data.couponCode);
    _descriptionController = TextEditingController(text: data.description);

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
        title: Text("Edit Coupon"),
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
        child: Text("SAVE".toUpperCase(), style: TextStyle(fontSize: 14)),
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
          style: TextStyle(color: Colors.redAccent),
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
                  child: data.couponImage == null
                      ? new Container(
                          height: 160.0,
                          width: 360.0,
                          decoration: new BoxDecoration(
                            image: _CouponImage(isDirty, _imageBanner, null),
                            border: Border.all(color: Colors.white, width: 0.5),
                          ),
                        )
                      : new Container(
                          height: 160.0,
                          width: 360.0,
                          decoration: new BoxDecoration(
                            image: _CouponImage(
                                isDirty, _imageBanner, data.couponImage),
                            border: Border.all(color: Colors.white, width: 0.5),
                          ),
                        )),
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
        auth.add(EditCouponEvent(_couponCodeValue, _startDateValue,
            _endDateValue, _descValue, data.id.toString(), _imageBanner));

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
    if (_image != null) {
      setState(() {
        isDirty = true;
        this._imageBanner = _image;
      });
    } else {
      print("Image is null please check @416");
    }
  }
}

_CouponImage(bool isDirty, File imageBanner, String couponImage) {
  if (isDirty) {
    return new DecorationImage(
      image: new FileImage(imageBanner),
      fit: BoxFit.cover,
    );
  } else if (couponImage != null) {
    return new DecorationImage(
      image: new NetworkImage(couponImage),
      fit: BoxFit.cover,
    );
  } else {
    return new DecorationImage(
      image: new AssetImage('assets/images/logo.png'),
      fit: BoxFit.cover,
    );
  }
}
