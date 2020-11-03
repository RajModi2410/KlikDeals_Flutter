import 'package:vendor/commons/ApiResponse.dart';
import 'package:vendor/commons/ApiError.dart';
import 'package:vendor/commons/KeyConstant.dart';

class ChangePasswordResponse extends ApiResponse {
  String message;
  bool status;
  ErrorMessage errorMessage;

  ChangePasswordResponse({this.message, this.status, this.errorMessage})
      : super(ApiStatus.COMPLETED);

  ChangePasswordResponse.fromJson(Map<String, dynamic> json, bool isError)
      : super.error(isError) {
    status = json['status'];
    message = json['message'];
    if (isError) {
      errorMessage = json['error_message'] != null
          ? new ErrorMessage.fromJson(json['error_message'])
          : null;
    } else {
      errorMessage = null;
    }
  }

  ChangePasswordResponse.fake(bool isError) : super.error(isError) {
    status = false;
    message = "Fail to reset password";
    if (isError) {
      errorMessage = ErrorMessage.error(
          "The specified old password does not match with your current password.");
    } else {
      errorMessage = null;
    }
  }

  ChangePasswordResponse.error() : super.network() {
    status = false;
    message = (KeyConstant.ERROR_CONNECTION_TIMEOUT);
    errorMessage = ErrorMessage.error(KeyConstant.ERROR_CONNECTION_TIMEOUT);
  }

  // ChangePasswordResponse.fromJson(Map<String, dynamic> json)  {
  //   message = json['message'];
  //   status = json['status'];
  //   if (json['response'] != null) {
  //     response = new List<Null>();
  //     json['response'].forEach((v) {
  //       response.add(new Null.fromJson(v));
  //     });
  //   }
  //   if (json['error_message'] != null) {
  //     errorMessage = new List<Null>();
  //     json['error_message'].forEach((v) {
  //       errorMessage.add(new Null.fromJson(v));
  //     });
  //   }
  // }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.errorMessage != null) {
      data['error_message'] = this.errorMessage.toJson();
    }
    return data;
  }

  @override
  bool isTokenError() {
    return errorMessage.isTokenError();
  }
}

class ErrorMessage extends ApiError {
  List<String> generalError;
  List<String> userError;

  ErrorMessage({this.generalError, this.userError});

  ErrorMessage.error(String error) {
    this.generalError = [error];
  }

  ErrorMessage.fromJson(Map<String, dynamic> json) {
    var keys = json.keys;
    if (keys.contains(KeyConstant.ERROR_GENERAL)) {
      this.generalError = json[KeyConstant.ERROR_GENERAL].cast<String>();
    } else {
      this.generalError = [];
    }

    if (keys.contains(KeyConstant.ERROR_KEY_USER)) {
      this.userError = json[KeyConstant.ERROR_KEY_USER].cast<String>();
    } else {
      this.userError = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[KeyConstant.ERROR_GENERAL] = this.generalError;
    data[KeyConstant.ERROR_KEY_USER] = this.userError;
    return data;
  }

  @override
  bool isTokenError() {
    return super.checkTokenError(generalError);
  }
}
