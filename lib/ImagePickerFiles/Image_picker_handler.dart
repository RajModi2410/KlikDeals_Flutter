import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

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
    bool denied = await Permission.camera.isDenied;
    print("camera permission here : $denied");
    if (!denied) {
      denied = await Permission.camera.isPermanentlyDenied;
      print("camera permission denied here : $denied");
      if (denied) {
        // openAppSettings();
        _listener.cameraPermissionDenied(true);
      }
    } else {
      _listener.cameraPermissionDenied(false);
    }
    if (denied) {
      print("we denied $denied");
    } else {
      try {
        var image = await ImagePicker.pickImage(
            source: ImageSource.camera,
            maxWidth: (maxWidth != null && maxWidth > -1 ? maxWidth : 720),
            maxHeight: (maxHeight != null && maxHeight > -1 ? maxHeight : 400));
        _listener.userImage(image);
      } on PlatformException catch (e) {
        print("we got ${e.code}  and ${e.details}");
      } catch (e, s) {
        print("error is $e $s");
      }
    }

//    cropImage(image);
  }

  openGallery() async {
    imagePicker.dismissDialog();
    bool denied = await Permission.photos.isDenied;
    print("Photo permission here : $denied");
    if (!denied) {
      denied = await Permission.photos.isPermanentlyDenied;
      if (denied) {
        _listener.galleryPermissionDenied(true);
        // openAppSettings();
      }
      print("Photo permission denied here : $denied");
    } else {
      _listener.galleryPermissionDenied(false);
    }
    if (!denied) {
      denied = await Permission.mediaLibrary.isPermanentlyDenied;
      print("mediaLibrary permission denied here : $denied");
    }
    if (!denied) {
      denied = await Permission.mediaLibrary.isDenied;
      print("mediaLibrary permission denied here : $denied");
    }
    if (denied) {
      print("we are not allow to pick image from gallery");
    } else {
      try {
        var image = await ImagePicker.pickImage(
            source: ImageSource.gallery,
            maxWidth: (maxWidth != null && maxWidth > -1 ? maxWidth : 720),
            maxHeight: (maxHeight != null && maxHeight > -1 ? maxHeight : 400));
        _listener.userImage(image);
      } on PlatformException catch (e) {
        print("we got ${e.code}  and ${e.details}");
      } catch (e, s) {
        print("error is $e $s");
      }
    }
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
  cameraPermissionDenied(bool permanent);
  galleryPermissionDenied(bool permanent);
// userImagebanner(File _image);
}
