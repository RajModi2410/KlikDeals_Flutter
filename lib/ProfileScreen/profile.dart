import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:klik_deals/ProfileScreen/Image_picker_handler.dart';

class Profile extends StatefulWidget {
  Profile({Key key, this.title}) : super(key: key);
  final String title;

  // @override
  // State<StatefulWidget> createState() {
  //   // TODO: implement createState
  //   return null;
  // }
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  verticalDirection: VerticalDirection.down,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(48.0),
                        child: Image(
                          width: 100,
                          height: 100,
                          image: AssetImage("images/color samples-01.png"),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        "Vendor Profile",
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 34.0),
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
                            // maxLines: 8,
                            // minLines: 6,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                              hintText: 'Name',
                              // border: OutlineInputBorder(
                              //     borderRadius: BorderRadius.circular(8.0)),
                            ),
                          ),
                        ),
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
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),

                              hintText: 'Address',
                              // border: OutlineInputBorder(
                              //     borderRadius: BorderRadius.circular(8.0)),
                            ),
                          ),
                        ),
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
                            // maxLines: 8,
                            // minLines: 6,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                              hintText: 'Location',
                              // border: OutlineInputBorder(
                              //     borderRadius: BorderRadius.circular(8.0)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Card(
                      elevation: 5.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Text("Logo",
                                    style: TextStyle(fontSize: 16)),
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton(
                                  child: Text("Browse"),
                                  
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              RaisedButton(
                                onPressed: () {
                                  forlogo = true;
                                  imagePicker.showDialog(context);
                                },
                                // onTap:
                                child: new Center(
                                  child: Padding(
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
                                ),
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Card(
                      elevation: 5.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                           Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Text("Banner",
                                    style: TextStyle(fontSize: 16)),
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton(
                                  child: Text("Browse"),
                                  
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            // crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              RaisedButton(
                                onPressed: () {
                                  forlogo = false;
                                  imagePicker.showDialog(context);
                                },

                                // onTap:
                                child: new Center(
                                  child: Padding(
                                    
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
                                ),
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ],
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
                            // maxLines: 8,
                            // minLines: 6,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                              hintText: 'Phone Number',
                              // border: OutlineInputBorder(
                              //     borderRadius: BorderRadius.circular(8.0)),
                            ),
                          ),
                        ),
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
                            // maxLines: 8,
                            // minLines: 6,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                              hintText: 'Email Address',
                              // border: OutlineInputBorder(
                              //     borderRadius: BorderRadius.circular(8.0)),
                            ),
                          ),
                        ),
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
                            // maxLines: 8,
                            // minLines: 6,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                              hintText: 'Website',
                              // border: OutlineInputBorder(
                              //     borderRadius: BorderRadius.circular(8.0)),
                            ),
                          ),
                        ),
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
                            maxLines: 6,
                            minLines: 4,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                              hintText: 'About Vendor',
                              // border: OutlineInputBorder(
                              //     borderRadius: BorderRadius.circular(8.0)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FloatingActionButton(
                            // color: Color(0xff01A0C7),

                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                // Process data.
                              }
                            },
                            tooltip: 'Increment',
                            child: Icon(Icons.arrow_right),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
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
}
