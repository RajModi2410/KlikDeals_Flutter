import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klik_deals/ApiBloc/ApiBloc_bloc.dart';
import 'package:klik_deals/ApiBloc/ApiBloc_event.dart';
import 'package:klik_deals/ApiBloc/ApiBloc_state.dart';
import 'package:klik_deals/ImagePickerFiles/Image_picker_handler.dart';
import 'package:klik_deals/SelectAddress/SelectAddress.dart';
import 'package:klik_deals/mywidgets/RoundWidget.dart';

import 'ProfileStates.dart';

class Profile extends StatefulWidget {
  Profile({Key key, this.title}) : super(key: key);
  final String title;

  _profilePage createState() => _profilePage();
}

class _profilePage extends State<Profile>
    with TickerProviderStateMixin, ImagePickerListener {
  final _formKey = GlobalKey<FormState>();
  File _image;
  File _imageBanner;
  bool forlogo = false;

  ApiBlocBloc auth;
  RoundWidget round;
  AnimationController _controller;
  ImagePickerHandler imagePicker;
  ImagePickerHandler imagePickerBanner;
  String _name, _addr, _email, _website, _desc, _number;

  TextEditingController _nameValue,
      _addressValue,
      _phoneNumber,
      _emailAddressValue,
      _websiteValue,
      _descValue;

  @override
  void initState() {
    super.initState();
    auth = BlocProvider.of<ApiBlocBloc>(context);
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    callGetVendorProfile(auth);
    _nameValue = TextEditingController(text: "VT");
    _addressValue = TextEditingController(text: "407");
    _phoneNumber = TextEditingController(text: "7698380093");
    _emailAddressValue =
        TextEditingController(text: "testing8.webdesksoluation@gmail.com");
    _websiteValue = TextEditingController(text: "aaaaaaa");
    _descValue = TextEditingController(text: "aaaaaaa");

    imagePicker = new ImagePickerHandler(this, _controller);
    imagePicker.init();

    imagePickerBanner = new ImagePickerHandler(this, _controller);
    imagePickerBanner.init();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      ProfileData(context),
      BlocListener<ApiBlocBloc, ApiBlocState>(
          listener: (context, state) {
            if (state is GetProfileApiErrorState) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text("Something went to wrong. Please try again"),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state is GetProfileApiFetchedState) {

            }
          },
          child: BlocBuilder<ApiBlocBloc, ApiBlocState>(
              bloc: auth,
              builder: (BuildContext context,
                  ApiBlocState currentState,) {
                if (currentState is ApiFetchingState) {
                  round = RoundWidget();
                  return round;
                } else {
                  return Container();
                }
              }))
    ]);
  }

  Widget ProfileData(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Profile'),
          backgroundColor: Colors.redAccent,
        ),
        body: Stack(children: <Widget>[
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/splash_bg.png'),
                    fit: BoxFit.cover)),
          ),
          new SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 24.0, right: 24.0, top: 8.0, bottom: 16.0),
                    child: Column(
                      verticalDirection: VerticalDirection.down,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _profileName(),
                        _address(),
                        _selectAddressButton(context),
                        selectLogo(),
                        selectBanner(),
                        phoneNumber(),
                        emailAddress(),
                        website(),
                        desc(),
                        saveButton(),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ]));
  }

  Padding saveButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: new FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.redAccent,
        onPressed: () {
          validateRequiredFields();
        },
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
              child: Text("SAVE",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Padding desc() {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: TextFormField(
          onSaved: (value) => _desc = value.trim(),
          controller: _descValue,
          validator: (value) {
            if (value.isEmpty || value == null) {
              return 'Please enter some text';
            }
            return null;
          },
          cursorColor: Colors.redAccent,
          maxLines: 6,
          decoration: _inputType("About Vendor")),
    );
  }

  Padding website() {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: TextFormField(
        onSaved: (value) => _website = value.trim(),
        validator: (value) {
          if (value.isEmpty || value == null) {
            return 'Please enter some text';
          }
          return null;
        },
        controller: _websiteValue,
        decoration: _inputType("Website"),
      ),
    );
  }

  Padding emailAddress() {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: TextFormField(
        onSaved: (value) => _email = value.trim(),
        validator: emailValidator,
        controller: _emailAddressValue,
        decoration: _inputType("Email Address"),
      ),
    );
  }

  Padding phoneNumber() {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: TextFormField(
        onSaved: (value) => _number = value.trim(),
        validator: (value) {
          if (value.isEmpty || value == null) {
            return 'Please enter some text';
          }
          return null;
        },
        controller: _phoneNumber,
        decoration: _inputType("Phone Number"),
      ),
    );
  }

  Padding selectBanner() {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(width: 1, color: Colors.grey)),
        child: Padding(
          padding:
          const EdgeInsets.only(top: 0, bottom: 16, left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text("Banner",
                      style: TextStyle(fontSize: 16, color: Colors.redAccent)),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.red)),
                      child: Text("Browse",
                          style: TextStyle(fontSize: 14, color: Colors.white)),
                      color: Colors.redAccent,
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
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
                    image: new DecorationImage(
                      image: new ExactAssetImage(_imageBanner.path),
                      fit: BoxFit.cover,
                    ),
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

  Padding selectLogo() {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(width: 1, color: Colors.grey)),
        child: Padding(
          padding:
          const EdgeInsets.only(top: 0, bottom: 16, left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Logo",
                        style:
                        TextStyle(fontSize: 16, color: Colors.redAccent)),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.red)),
                      child: Text("Browse",
                          style: TextStyle(fontSize: 12, color: Colors.white)),
                      color: Colors.redAccent,
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _image == null
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
                    image: new DecorationImage(
                      image: new ExactAssetImage(_image.path),
                      fit: BoxFit.cover,
                    ),
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

  Padding _selectAddressButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: new FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.redAccent,
        onPressed: () {
          _goToLocationScreen(context);
        },
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
              child: Text("SELECT ADDRESS",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Padding _address() {
    return Padding(

      padding: const EdgeInsets.only(top: 24.0),
      child: TextFormField(
        onSaved: (value) => _addr = value.trim(),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter Address";
          }
        },
        controller: _addressValue,
        decoration: _inputType("Address"),
      ),
    );
  }

  Padding _profileName() {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: TextFormField(
          onSaved: (value) => _name = value.trim(),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter name";
            }
          },
          controller: _nameValue,
          decoration: _inputType(
            "Name",
          )),
    );
  }

  @override
  userImage(File _image) {
    setState(() {
      if (forlogo == true) {
        this._image = _image;
      } else {
        this._imageBanner = _image;
      }
    });
  }

  InputDecoration _inputType(String hintText) {
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

  String emailValidator(String value) {
    if (value != null || value.isNotEmpty) {
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp exp = new RegExp(pattern);
      if (!exp.hasMatch(value)) {
        return 'Please enter valid email.';
      } else {
        return null;
      }
    } else {
      return 'Please enter email adderess.';
    }
  }

  void validateRequiredFields() {
    if (validateAndSave()) {
      print(":::::::::::::::We get coupon data :::::::::::");
      print(_name);
      print(_addr);
      print(_number);
      print(_email);
      print(_website);
      print(_desc);
      print(_imageBanner);
      print(_image);
      /*try {
      auth.add(AddCouponEvent(
            _couponCodeValue, _startDateValue, _endDateValue, _descValue,
            _imageBanner));
        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        print('Error: $e');
      }*/
    }
  }

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}

void callGetVendorProfile(ApiBlocBloc auth) {
  auth.add(GetProfileEvent());
}

void _goToLocationScreen(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => SelectAddress()),
  );
}
