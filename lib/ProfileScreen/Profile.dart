import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:string_validator/string_validator.dart';
import 'package:vendor/ApiBloc/ApiBloc_event.dart';
import 'package:vendor/ApiBloc/ApiBloc_state.dart';
import 'package:vendor/ApiBloc/models/GetProfileResponse.dart';
import 'package:vendor/AppLocalizations.dart';
import 'package:vendor/ChangePassword/ChangePassword.dart';
import 'package:vendor/ChangePassword/ChangePasswordForm.dart';
import 'package:vendor/ImagePickerFiles/Image_picker_handler.dart';
import 'package:vendor/ProfileScreen/Profile_bloc.dart';
import 'package:vendor/SelectAddress/SelectAddress.dart';
import 'package:vendor/commons/CenterLoadingIndicator.dart';
import 'package:vendor/commons/KeyConstant.dart';
import 'package:vendor/myWidgets/ErrorDialog.dart';
import 'package:vendor/myWidgets/NoNetworkWidget.dart';
import 'package:vendor/myWidgets/RoundWidget.dart';
import 'package:vendor/myWidgets/SuccessDialog.dart';

import 'ProfileStates.dart';

class Profile extends StatefulWidget {
  static const String routeName = "/profile";

  Profile({Key key, this.title}) : super(key: key);
  final String title;

  _ProfilePage createState() => _ProfilePage();
}

class _ProfilePage extends State<Profile>
    with TickerProviderStateMixin, ImagePickerListener {
  final _formKey = GlobalKey<FormState>();
  File _image;
  File _imageBanner;
  bool forLogo = false;
  bool isDirty = false;
  Response data;
  ProfileBloc auth;
  RoundWidget round;
  AnimationController _controller;
  ImagePickerHandler imagePicker;
  ImagePickerHandler imagePickerBanner;
  String _name,
      _addr,
      _email,
      _website,
      _desc,
      _number,
      _lat,
      _long,
      _addressString;

  TextEditingController _nameValue,
      _addressValue,
      _phoneNumber,
      _emailAddressValue,
      _websiteValue,
      _descValue;

  ApiBlocEvent lastEvent;

  @override
  void initState() {
    super.initState();
    auth = BlocProvider.of<ProfileBloc>(context);
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    callGetVendorProfile(auth);

    imagePicker = new ImagePickerHandler(this, _controller,
        maxWidth: 150, maxHeight: 150);
    imagePicker.init();

    imagePickerBanner =
        new ImagePickerHandler(this, _controller, maxWidth: 1080);
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
    return Scaffold(
        appBar: AppBar(
          title: Text(
              AppLocalizations.of(context).translate("title_edit_profile"),
              style: Theme.of(context).textTheme.title),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Stack(children: <Widget>[
          profileData(context),
          BlocListener<ProfileBloc, ApiBlocState>(
              listener: (context, state) {
                if (state is GetProfileApiErrorState) {
                  var error =
                      state.getProfileResponse.errorMessage.getCommonError();
                  // Scaffold.of(context).showSnackBar(
                  //   SnackBar(
                  //     content: Text(error != null ? error : AppLocalizations.of(context)
                  //         .translate("common_error")),
                  //     backgroundColor: Theme.of(context).primaryColor,
                  //   ),
                  // );
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => ErrorDialog(
                      mainMessage: error != null
                          ? error
                          : AppLocalizations.of(context)
                              .translate("common_error"),
                      okButtonText:
                          AppLocalizations.of(context).translate("label_ok"),
                    ),
                  ).then((isConfirm) {
                    print("we got isConfirm $isConfirm");
                    if (isConfirm) {
                      Navigator.of(context).pop();
                    }
                  });
                } else if (state is GetProfileApiFetchedState) {
                  data = state.getProfileResponse.response;
                  setState(() {
                    setData(data);
                  });
                } else if (state is UpdateProfileApiErrorState) {
                  var error = state.error;
                  var unl =
                      state.updateProfileResponse.errorMessage.ultimateError;
                  if (error != null) {
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text(AppLocalizations.of(context)
                                .translate("error_update_profile") +
                            " " +
                            error),
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                    );
                  } else if (unl != null) {
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text(AppLocalizations.of(context)
                                .translate("error_update_profile") +
                            " " +
                            unl),
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                    );
                  } else {
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text(AppLocalizations.of(context)
                            .translate("error_update_profile")),
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                    );
                  }
                } else if (state is UpdateProfileSuccessState) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => SuccessDialog(
                      mainMessage: AppLocalizations.of(context)
                          .translate("message_profile_success"),
                      okButtonText:
                          AppLocalizations.of(context).translate("label_ok"),
                    ),
                  ).then((isConfirm) {
                    print("we got isConfirm $isConfirm");
                    if (isConfirm) {
                      _dismissKeyboard(context);
//                      Navigator.of(context).pop();
                    }
                  });
                }
              },
              child: BlocBuilder<ProfileBloc, ApiBlocState>(
                  bloc: auth,
                  builder: (
                    BuildContext context,
                    ApiBlocState currentState,
                  ) {
                    if (currentState is ApiFetchingState) {
                      round = RoundWidget();
                      return CenterLoadingIndicator();
                      // return round;
                    } else if (currentState is NoInternetState) {
                      return NoNetworkWidget(
                        retry: () {
                          retryCall();
                        },
                        isFromInternetConnection:
                            currentState.isFromInternetConnection,
                      );
                    } else {
                      return Container();
                    }
                  }))
        ]));
  }

  Widget profileData(BuildContext context) {
    return Stack(children: <Widget>[
      Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/splash_bg.webp'),
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
                    showResetLink()
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ]);
  }

  Padding saveButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: new FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Theme.of(context).primaryColor,
        onPressed: () {
          validateRequiredFields();
        },
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
              child: Text(AppLocalizations.of(context).translate("label_save"),
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
        child: GestureDetector(
          onTap: () {
            this._dismissKeyboard(context);
          },
          child: TextFormField(
              onSaved: (value) => _desc = value.trim(),
              controller: _descValue,
              validator: (value) {
                if (value.trim().isEmpty || value == null) {
                  return AppLocalizations.of(context)
                      .translate("error_add_text");
                }
                return null;
              },
              style: TextStyle(color: Theme.of(context).primaryColor),
              cursorColor: Theme.of(context).primaryColor,
              maxLines: 6,
              decoration: _inputType(
                  AppLocalizations.of(context).translate("title_vendor"))),
        ));
  }

  Padding website() {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: TextFormField(
        onSaved: (value) => _website = value.trim(),
        validator: (value) {
          /*if (value.trim().isEmpty || value == null) {
                                return AppLocalizations.of(context).translate("error_add_text");
                              } 
                              else if (!isURL(value, {"require_protocol": true, "require_protocols": true})) {
                                return AppLocalizations.of(context).translate("error_message_website");
                              }*/

          if (value != null && value.trim().isNotEmpty) {
            if (!isURL(
                value, {"require_protocol": true, "require_protocols": true})) {
              return AppLocalizations.of(context)
                  .translate("error_message_website");
            }
          }
          return null;
        },
        style: TextStyle(color: Theme.of(context).primaryColor),
        controller: _websiteValue,
        decoration:
            _inputType(AppLocalizations.of(context).translate("title_website")),
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
        decoration:
            _inputType(AppLocalizations.of(context).translate("title_email")),
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
    );
  }

  _dismissKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  Padding phoneNumber() {
    return Padding(
        padding: const EdgeInsets.only(top: 24.0),
        child: GestureDetector(
          onTap: () {
            this._dismissKeyboard(context);
          },
          child: TextFormField(
            inputFormatters: [
              WhitelistingTextInputFormatter(KeyConstant.numberReg())
            ],
            onSaved: (value) => _number = value.trim(),
            validator: (value) {
              if (value.trim().isEmpty || value == null) {
                return AppLocalizations.of(context).translate("error_add_text");
              } else if (value.length != 10) {
                return AppLocalizations.of(context)
                    .translate("error_message_phone_number");
              } else if (!isNumeric(value.trim())) {
                return AppLocalizations.of(context)
                    .translate("error_message_phone_number");
              }
              return null;
            },
            keyboardType: TextInputType.number,
            style: TextStyle(color: Theme.of(context).primaryColor),
            controller: _phoneNumber,
            decoration: _inputType(
                AppLocalizations.of(context).translate("title_phone_number")),
          ),
        ));
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
                  Text(AppLocalizations.of(context).translate("label_banner"),
                      style: TextStyle(
                          fontSize: 16, color: Theme.of(context).primaryColor)),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.red)),
                      child: Text(
                          AppLocalizations.of(context)
                              .translate("title_browse"),
                          style: TextStyle(fontSize: 14, color: Colors.white)),
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        forLogo = false;
                        imagePickerBanner.showDialog(context);
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
                        child: _bannerImage(isDirty,
                            data != null ? data.banner : null, _imageBanner),
                      )
                    : new Container(
                        height: 160.0,
                        width: 360.0,
                        child: _bannerImage(isDirty,
                            data != null ? data.banner : null, _imageBanner),
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
                    child: Text(
                        AppLocalizations.of(context).translate("title_logo"),
                        style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).primaryColor)),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.red)),
                      child: Text(
                          AppLocalizations.of(context)
                              .translate("title_browse"),
                          style: TextStyle(fontSize: 12, color: Colors.white)),
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        forLogo = true;
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
                        child: _logoImage(
                            isDirty, data != null ? data.logo : null, _image),
                        //                              image: new NetworkImage(_image.path),
                      )
                    : new Container(
                        height: 160.0,
                        width: 360.0,
                        child: _logoImage(
                            isDirty, data != null ? data.logo : null, _image),
                        //                            image: new NetworkImage(_image.path),
                        decoration: new BoxDecoration(
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
        color: Theme.of(context).primaryColor,
        onPressed: () {
          _goToLocationScreen(context, _lat, _long, _addressString);
        },
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
              child: Text(
                  AppLocalizations.of(context).translate("title_address"),
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
      child: GestureDetector(
        onTap: () {
          print("We are here TAP FOR HIDE KEYBOARD");
          this._dismissKeyboard(context);
        },
        child: TextFormField(
          onSaved: (value) => _addr = value.trim(),
          validator: (value) {
            if (value.trim() == null || value.trim().isEmpty) {
              return AppLocalizations.of(context)
                  .translate("error_message_address");
            }
            return null;
          },
          style: TextStyle(color: Theme.of(context).primaryColor),
          controller: _addressValue,
          decoration: _inputType(
              AppLocalizations.of(context).translate("title _address_field")),
        ),
      ),
    );
  }

  Padding _profileName() {
    return Padding(
        padding: const EdgeInsets.only(top: 24.0),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: TextFormField(
              controller: _nameValue,
              onSaved: (value) => _name = value.trim(),
              validator: (value) {
                if (value.trim() == null || value.trim().isEmpty) {
                  return "Please enter name";
                }
                return null;
              },
              style: TextStyle(color: Theme.of(context).primaryColor),
              decoration: _inputType(
                "Name",
              )),
        ));
  }

  @override
  userImage(File _image) {
    if (_image != null) {
      setState(() {
        isDirty = true;
        if (forLogo == true) {
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
      hintStyle: TextStyle(color: Theme.of(context).hintColor),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
          borderSide: BorderSide(color: Colors.grey)),
      border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(30.0)),
      labelStyle: TextStyle(color: Theme.of(context).primaryColor),
      contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 10.0, 10.0),
      hintText: hintText,
    );
  }

  String emailValidator(String value) {
    if (value != null || value.trim().isNotEmpty) {
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp exp = new RegExp(pattern);
      if (!exp.hasMatch(value.trim())) {
        return AppLocalizations.of(context).translate("error_message_email");
      } else {
        return null;
      }
    } else {
      return AppLocalizations.of(context)
          .translate("error_message_email_valid");
    }
  }

  void validateRequiredFields() {
    if (validateAndSave()) {
      print(":::::::::::::::We get coupon data :::::::::::");
      print("_name $_name");
      print("_addr $_addr");
      print("_number $_number");
      print("_email $_email");
      print("_website $_website");
      print("_desc $_desc");
      print("_lat $_lat");
      print("_long $_long");
      print("_imageBanner $_imageBanner");
      print("_imageLogo $_image");
      try {
        lastEvent = UpdateProfileEvent(_name, _addr, _lat, _long, _number,
            _email, _website, _desc, _image, _imageBanner);
        auth.add(lastEvent);
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  void callGetVendorProfile(ProfileBloc auth) {
    lastEvent = GetProfileEvent();
    auth.add(lastEvent);
  }

  retryCall() {
    if (lastEvent != null) {
      auth.add(lastEvent);
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
          builder: (context) => SelectAddress(
              addressString: address, lat: latitude, long: longitude)),
    );
    if (result != null) {
      var data = result.split("*");
      _lat = data[0].toString();
      _long = data[1].toString();
      _addressString = data[2].toString();
      _addressValue = TextEditingController(text: data[2].toString());
      print(
          "We got selected latLong ::: ${data[0].toString()} - ${data[1].toString()} - ${data[2].toString()}");
    }
  }

  showResetLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.fromLTRB(8, 16, 8, 24),
            child: GestureDetector(
              onTap: () => _goToChangePassword(context),
              child: Text("Change your password",
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(decoration: TextDecoration.underline)),
            )),
      ],
    );
  }

  @override
  cameraPermissionDenied(bool permanent) async {
    if (permanent) {
      // openAppSettings();
      new Timer(_duration, () {
        _showPopup(true);
      });
    } else {
      PermissionStatus gallery = await Permission.camera.request();
      if (gallery.isGranted) {
        imagePicker.showDialog(context);
      } else {
        new Timer(_duration, () {
          _showPopup(true);
        });
      }
    }
  }

  var _duration = new Duration(milliseconds: 250);

  @override
  galleryPermissionDenied(bool permanent) async {
    print("galleryPermissionDenied called with $permanent");

    if (permanent) {
      // openAppSettings();
      new Timer(_duration, () {
        _showPopup(false);
      });
    } else {
      PermissionStatus gallery = await Permission.photos.request();
      if (gallery.isGranted) {
        imagePicker.showDialog(context);
      } else {
        new Timer(_duration, () {
          _showPopup(false);
        });
      }
    }
  }

  void _showPopup(bool isForCamera) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: new Text(isForCamera
              ? "Keyy is not able to access your camera for add the coupon. Please allow application for camera usage."
              : "Keyy is not able to access your photo gallery for add the coupon. Please allow application for photo gallery usage."),
          actions: <Widget>[
            FlatButton(
              child: Text('Later',
                  style: TextStyle(color: Theme.of(context).primaryColor)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Allow',
                  style: TextStyle(color: Theme.of(context).primaryColor)),
              onPressed: () {
                Navigator.of(context).pop();
                imagePicker.showDialog(context);
              },
            )
          ],
        );
      },
    );
  }
}

void _goToChangePassword(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ChangePassword()),
  );
}

Widget _bannerImage(bool isDirty, String oldBanner, File imageBanner) {
  print("We got null banner file :: $isDirty :: $oldBanner :: $imageBanner");
  if (isDirty && imageBanner != null) {
    return new Image.file(
      imageBanner,
      fit: BoxFit.scaleDown,
    );
  } else if (oldBanner != null) {
    return new CachedNetworkImage(
      imageUrl: oldBanner,
      fit: BoxFit.scaleDown,
      errorWidget: (context, url, error) => Image.asset(
        'assets/images/main_logo.png',
        fit: BoxFit.scaleDown,
        color: Colors.white.withOpacity(0.2),
        colorBlendMode: BlendMode.dstATop,
      ),
    );
  } else {
    return Image.asset(
      'assets/images/main_logo.png',
      fit: BoxFit.scaleDown,
      color: Colors.white.withOpacity(0.2),
      colorBlendMode: BlendMode.dstATop,
    );
  }
}

Widget _logoImage(bool isDirty, String oldLogo, File imageLogo) {
  print("We got null banner file :: $isDirty :: $oldLogo :: $imageLogo");
  if (isDirty && imageLogo != null) {
    return Image.file(
      imageLogo,
      fit: BoxFit.scaleDown,
    );
  } else if (oldLogo != null) {
    return CachedNetworkImage(
        imageUrl: oldLogo,
        fit: BoxFit.scaleDown,
        errorWidget: (context, url, error) => Image.asset(
              'assets/images/main_logo.png',
              fit: BoxFit.scaleDown,
              color: Colors.white.withOpacity(0.2),
              colorBlendMode: BlendMode.dstATop,
            ));
  } else {
    return Image.asset(
      'assets/images/main_logo.png',
      fit: BoxFit.scaleDown,
      color: Colors.white.withOpacity(0.2),
      colorBlendMode: BlendMode.dstATop,
    );
  }
}

bool isURL(String str, [Map options]) {
  if (str == null ||
      str.isEmpty ||
      str.length > 2083 ||
      str.indexOf('mailto:') == 0) {
    return false;
  }

  Map default_url_options = {
    'protocols': ['http', 'https', 'ftp'],
    'require_tld': true,
    'require_protocol': false,
    'allow_underscores': false
  };

  options = merge(options, default_url_options);

  print("we got options: $options");
  var protocol,
      user,
      pass,
      auth,
      host,
      hostname,
      port,
      port_str,
      path,
      query,
      hash,
      split;

  // check protocol
  split = str.split('://');
  if (split.length > 1) {
    protocol = shift(split);
    if (options['protocols'].indexOf(protocol) == -1) {
      return false;
    }
  } else if (options['require_protocols'] == true) {
    return false;
  }
  str = split.join('://');

  // check hash
  split = str.split('#');
  str = shift(split);
  hash = split.join('#');
  if (hash != null && hash != "" && RegExp(r'\s').hasMatch(hash)) {
    return false;
  }

  // check query params
  split = str.split('?');
  str = shift(split);
  query = split.join('?');
  if (query != null && query != "" && RegExp(r'\s').hasMatch(query)) {
    return false;
  }

  // check path
  split = str.split('/');
  str = shift(split);
  path = split.join('/');
  if (path != null && path != "" && RegExp(r'\s').hasMatch(path)) {
    return false;
  }

  // check auth type urls
  split = str.split('@');
  if (split.length > 1) {
    auth = shift(split);
    if (auth.indexOf(':') >= 0) {
      auth = auth.split(':');
      user = shift(auth);
      if (!RegExp(r'^\S+$').hasMatch(user)) {
        return false;
      }
      pass = auth.join(':');
      if (!RegExp(r'^\S*$').hasMatch(pass)) {
        return false;
      }
    }
  }

  // check hostname
  hostname = split.join('@');
  split = hostname.split(':');
  host = shift(split);
  if (split.length > 0) {
    port_str = split.join(':');
    try {
      port = int.parse(port_str, radix: 10);
    } catch (e) {
      return false;
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(port_str) || port <= 0 || port > 65535) {
      return false;
    }
  }

  if (!isIP(host) && !isFQDN(host, options) && host != 'localhost') {
    return false;
  }

  if (options['host_whitelist'] == true &&
      options['host_whitelist'].indexOf(host) == -1) {
    return false;
  }

  if (options['host_blacklist'] == true &&
      options['host_blacklist'].indexOf(host) != -1) {
    return false;
  }

  return true;
}

shift(List l) {
  if (l.isNotEmpty) {
    var first = l.first;
    l.removeAt(0);
    return first;
  }
  return null;
}

Map merge(Map obj, defaults) {
  if (obj == null) {
    obj = new Map();
  }
  defaults.forEach((key, val) => obj.putIfAbsent(key, () => val));
  return obj;
}
