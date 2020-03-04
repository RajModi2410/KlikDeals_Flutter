import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'image_picker_dialog.dart';

class ImagePickerHandler {
  ImagePickerDialog imagePicker;
  AnimationController _controller;
  ImagePickerListener _listener;
  double maxWidth = -1;
  double maxHeight = -1;

  ImagePickerHandler(this._listener, this._controller,
      {this.maxWidth, this.maxHeight});

  openCamera() async {
    imagePicker.dismissDialog();
    var image = await ImagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: (maxWidth!=null && maxWidth > -1 ? maxWidth : 720),
        maxHeight: (maxHeight!=null && maxHeight > -1 ? maxHeight : 400));
    _listener.userImage(image);

//    cropImage(image);
  }

  openGallery() async {
    imagePicker.dismissDialog();
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: (maxWidth!=null && maxWidth > -1 ? maxWidth : 720),
        maxHeight: (maxHeight!=null && maxHeight > -1 ? maxHeight : 400));
    _listener.userImage(image);
//    cropImage(image);
  }

  void init() {
    imagePicker = new ImagePickerDialog(this, _controller);
    imagePicker.initState();
  }

  /*Future cropImage(File image) async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: image.path,
      ratioX: 1.0,
      ratioY: 1.0,
      maxWidth: 512,
      maxHeight: 512,
    );
    _listener.userImage(croppedFile);
    
    // _listener
  }*/

  showDialog(BuildContext context) {
    imagePicker.getImage(context);
  }
}

abstract class ImagePickerListener {
  userImage(File _image);
// userImagebanner(File _image);
}
