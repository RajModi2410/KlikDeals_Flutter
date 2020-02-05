import 'dart:io';

import 'package:flutter/material.dart';
import 'package:klik_deals/ImagePickerFiles/Image_picker_handler.dart';
import 'package:klik_deals/SelectAddress/SelectAddress.dart';

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

  AnimationController _controller;
  ImagePickerHandler imagePicker;
  ImagePickerHandler imagePickerBanner;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

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
                        Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: TextFormField(
                              decoration: _inputType(
                            "Name",
                          )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: TextFormField(
                            decoration: _inputType("Address"),
                          ),
                        ),
                        Padding(
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
                                  padding: const EdgeInsets.only(
                                      top: 16.0, bottom: 16.0),
                                  child: Text("SELECT ADDRESS",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(width: 1, color: Colors.grey)),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 0, bottom: 16, left: 16, right: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text("Logo",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.redAccent)),
                                      ),
                                      Spacer(),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: RaisedButton(
                                          shape: new RoundedRectangleBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      18.0),
                                              side: BorderSide(
                                                  color: Colors.red)),
                                          child: Text("Browse",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white)),
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
                                                    radius: 00.0,
                                                    backgroundColor:
                                                        Colors.white),
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
                                                    _image.path),
                                                fit: BoxFit.cover,
                                              ),
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 0.5),
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
                          padding: const EdgeInsets.only(top: 24.0),
                          child: Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(width: 1, color: Colors.grey)),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 0, bottom: 16, left: 16, right: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text("Banner",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.redAccent)),
                                      Spacer(),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: RaisedButton(
                                          shape: new RoundedRectangleBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      18.0),
                                              side: BorderSide(
                                                  color: Colors.red)),
                                          child: Text("Browse",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white)),
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
                                                    radius: 00.0,
                                                    backgroundColor:
                                                        Colors.white),
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
                                                  color: Colors.white,
                                                  width: 0.5),
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
                          padding: const EdgeInsets.only(top: 24.0),
                          child: TextFormField(
                            decoration: _inputType("Phone Number"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: TextFormField(
                            decoration: _inputType("Email Address"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: TextFormField(
                            decoration: _inputType("Website"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: TextFormField(
                              validator: (value) {
                                if (value.isEmpty && value == null) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              cursorColor: Colors.redAccent,
                              maxLines: 6,
                              decoration: _inputType("About Vendor")),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: new FlatButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            color: Colors.redAccent,
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
// Process data.
                              }
                            },
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Padding(
                                  padding: const EdgeInsets.only(
                                      top: 16.0, bottom: 16.0),
                                  child: Text("SAVE",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ]));
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
}

void _goToLocationScreen(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => SelectAddress()),
  );
}
