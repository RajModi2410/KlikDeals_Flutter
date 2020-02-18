import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klik_deals/ApiBloc/ApiBloc_bloc.dart';
import 'package:klik_deals/ApiBloc/ApiBloc_event.dart';
import 'package:klik_deals/ApiBloc/ApiBloc_state.dart';
import 'package:klik_deals/ApiBloc/models/GetProfileResponse.dart';
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
  bool isDirty = false;
  Response data;
  ApiBlocBloc auth;
  RoundWidget round;
  AnimationController _controller;
  ImagePickerHandler imagePicker;
  ImagePickerHandler imagePickerBanner;
  String _name, _addr, _email, _website, _desc, _number, _lat, _long,
      _addressString;

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

    imagePicker = new ImagePickerHandler(this, _controller);
    imagePicker.init();

    imagePickerBanner = new ImagePickerHandler(this, _controller);
    imagePickerBanner.init();
  }

  void setData(Response data) {
    _nameValue = TextEditingController(text: data.name);
    _addressValue = TextEditingController(text: data.address);
    _phoneNumber = TextEditingController(text: data.phoneNumber);
    _emailAddressValue = TextEditingController(text: data.email);
    _websiteValue = TextEditingController(text: data.website);
    _descValue = TextEditingController(text: data.about);
    _lat = data.latitude;
    _long = data.longitude;
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
              data = state.getProfileResponse.response;
              setState(() {
                setData(data);
              });
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
          backgroundColor:  Theme.of(context).primaryColor,
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
                        _selectAddressButton(context, data.toString()),
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
        color:  Theme.of(context).primaryColor,
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
          style: TextStyle(color:  Theme.of(context).primaryColor),
          cursorColor:  Theme.of(context).primaryColor,
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
        style: TextStyle(color:  Theme.of(context).primaryColor),
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
        keyboardType: TextInputType.emailAddress,
        controller: _emailAddressValue,
        decoration: _inputType("Email Address"),
        style: TextStyle(color:  Theme.of(context).primaryColor),
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
          } else if (value.length != 10) {
            return 'Please enter valid mobile number';
          }
          return null;
        },
        keyboardType: TextInputType.number,
        style: TextStyle(color:  Theme.of(context).primaryColor),
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
                      style: TextStyle(fontSize: 16, color:  Theme.of(context).primaryColor)),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.red)),
                      child: Text("Browse",
                          style: TextStyle(fontSize: 14, color: Colors.white)),
                      color:  Theme.of(context).primaryColor,
                      onPressed: () {
                        forlogo = false;
                        imagePicker.showDialog(context);
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _imageBanner == null
                    ? new Container(
                  height: 160.0,
                  width: 360.0,
                  decoration: new BoxDecoration(
                    image: _bannerImage(isDirty,
                        data != null ? data.banner : null, _imageBanner),
                  ),
                )
                    : new Container(
                  height: 160.0,
                  width: 360.0,
                  decoration: new BoxDecoration(
                    image: _bannerImage(isDirty,
                        data != null ? data.banner : null, _imageBanner),
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
                        TextStyle(fontSize: 16, color:  Theme.of(context).primaryColor)),
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
                      color:  Theme.of(context).primaryColor,
                      onPressed: () {
                        forlogo = true;
                        imagePicker.showDialog(context);
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _image == null
                    ? new Container(
                    height: 160.0,
                    width: 360.0,
                    decoration: new BoxDecoration(
                      image: _LogoImage(
                          isDirty, data != null ? data.logo : null, _image),
//                              image: new NetworkImage(_image.path),
                    ))
                    : new Container(
                  height: 160.0,
                  width: 360.0,
                  decoration: new BoxDecoration(
                    image: _LogoImage(
                        isDirty, data != null ? data.logo : null, _image),
//                            image: new NetworkImage(_image.path),
                    border: Border.all(color: Colors.white, width: 0.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding _selectAddressButton(BuildContext context, String profileData) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: new FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color:  Theme.of(context).primaryColor,
        onPressed: () {
          _goToLocationScreen(
              context, _lat, _long, _addressString);
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
          if (value.trim() == null || value
              .trim()
              .isEmpty) {
            return "Please enter Address";
          }
        },
        style: TextStyle(color:  Theme.of(context).primaryColor),
        controller: _addressValue,
        decoration: _inputType("Address"),
      ),
    );
  }

  Padding _profileName() {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: TextFormField(
          controller: _nameValue,
          onSaved: (value) => _name = value.trim(),
          validator: (value) {
            if (value.trim() == null || value
                .trim()
                .isEmpty) {
              return "Please enter name";
            }
          },
          style: TextStyle(color:  Theme.of(context).primaryColor),
          decoration: _inputType(
            "Name",
          )),
    );
  }

  @override
  userImage(File _image) {
    if (_image != null) {
      setState(() {
        isDirty = true;
        if (forlogo == true) {
          this._image = _image;
        } else {
          this._imageBanner = _image;
        }
      });
    }
  }

  InputDecoration _inputType(String hintText) {
    return InputDecoration(
      fillColor: Color(0xB3FFFFFF),
      filled: true,
      hintStyle: TextStyle(color:  Theme.of(context).primaryColor),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
          borderSide: BorderSide(color: Colors.grey)),
      border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(30.0)),
      labelStyle: TextStyle(color:  Theme.of(context).primaryColor),
      contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 10.0, 10.0),
      hintText: hintText,
    );
  }

  String emailValidator(String value) {
    if (value != null || value.isNotEmpty) {
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp exp = new RegExp(pattern);
      if (!exp.hasMatch(value.trim())) {
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
      print(_lat);
      print(_long);
      print(_imageBanner);
      print(_image);
      try {
        auth.add(UpdatePofileEvent(
            _name,
            _addr,
            _lat,
            _long,
            _number,
            _email,
            _website,
            _desc,
            _imageBanner,
            _image));
      } catch (e) {
        print('Error: $e');
      }
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

  void _goToLocationScreen(BuildContext context, String latitude,
      String longitude, String address) async {
    print(
        "1 latitude :: $latitude longitude :: $longitude address :: $address");
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              SelectAddress(
                  addressString: address, lat: latitude, long: longitude)),
    );
    var data = result.split("*");
    _lat = data[0].toString();
    _long = data[1].toString();
    _addressString = data[2].toString();
    _addressValue = TextEditingController(text: data[2].toString());

    print(
        "We got selected latlong ::: ${data[0].toString()} - ${data[1]
            .toString()} - ${data[2].toString()}");
  }
}

_bannerImage(bool isDirty, String oldBanner, File imageBanner) {
  print("We got null banner file :: $isDirty :: $oldBanner :: $imageBanner");
  if (isDirty && imageBanner != null) {
    return new DecorationImage(
      image: new FileImage(imageBanner),
      fit: BoxFit.scaleDown,
    );
  } else if (oldBanner != null) {
    return new DecorationImage(
      image: new NetworkImage(oldBanner),
      fit: BoxFit.scaleDown,
    );
  } else {
    return new DecorationImage(
      image: new AssetImage('assets/images/logo.png'),
      fit: BoxFit.scaleDown,
    );
  }
}

_LogoImage(bool isDirty, String oldLogo, File imageLogo) {
  print("We got null banner file :: $isDirty :: $oldLogo :: $imageLogo");
  if (isDirty && imageLogo != null) {
    return new DecorationImage(
      image: new FileImage(imageLogo),
      fit: BoxFit.scaleDown,
    );
  } else if (oldLogo != null) {
    return new DecorationImage(
      image: new NetworkImage(oldLogo),
      fit: BoxFit.scaleDown,
    );
  } else {
    return new DecorationImage(
      image: new AssetImage('assets/images/logo.png'),
      fit: BoxFit.scaleDown,
    );
  }
}

void callGetVendorProfile(ApiBlocBloc auth) {
  auth.add(GetProfileEvent());
}
