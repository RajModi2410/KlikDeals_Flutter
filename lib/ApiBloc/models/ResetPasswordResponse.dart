import 'package:vendor/commons/ApiError.dart';
import 'package:vendor/commons/ApiResponse.dart';
import 'package:vendor/commons/KeyConstant.dart';

class ResetPasswordResponse extends ApiResponse {
  bool status;
  String message;
  ErrorMessage errorMessage;

  ResetPasswordResponse({this.status, this.message, this.errorMessage})
      : super(ApiStatus.COMPLETED);

  ResetPasswordResponse.fromJson(Map<String, dynamic> json, bool isError)
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

  ResetPasswordResponse.fake(bool isError)
      : super.error(isError) {
    status = false;
    message = "The email address is wrong";
    if (isError) {
      errorMessage = ErrorMessage.error("Unable to reset the password");
    } else {
      errorMessage = null;
    }
  }

  ResetPasswordResponse.error() : super.network() {
    status = false;
    message = (KeyConstant.ERROR_CONNECTION_TIMEOUT);
    errorMessage = ErrorMessage.error(KeyConstant.ERROR_CONNECTION_TIMEOUT);
  }

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
