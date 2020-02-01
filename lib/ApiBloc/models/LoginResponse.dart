import 'package:klik_deals/commons/KeyConstant.dart';

class LoginResponse {
  bool status;
  String message;
  ErrorMessage errorMessage;
  String token;

  LoginResponse({this.status, this.message, this.errorMessage, this.token});

  LoginResponse.fromJson(Map<String, dynamic> json, bool isError) {
    status = json['status'];
    message = json['message'];
    if (isError) {
      errorMessage = json['error_message'] != null
          ? new ErrorMessage.fromJson(json['error_message'])
          : null;
    } else {
      errorMessage = null;
    }
    if (!isError) {
      token = json['token'] != null ? json['token'] : null;
    } else {
      token = null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.errorMessage != null) {
      data['error_message'] = this.errorMessage.toJson();
    }
    data['token'] = this.token;
    return data;
  }
}

class ErrorMessage {
  List<String> general_error;
  List<String> user_error;

  ErrorMessage({this.general_error, this.user_error});

  ErrorMessage.fromJson(Map<String, dynamic> json) {
    var keys = json.keys;
    if (keys.contains(KeyConstant.ERROR_GENERAL)) {
      this.general_error = json[KeyConstant.ERROR_GENERAL].cast<String>();
    } else {
      this.general_error = [];
    }

    if (keys.contains(KeyConstant.ERROR_KEY_USER)) {
      this.user_error = json[KeyConstant.ERROR_KEY_USER].cast<String>();
    } else {
      this.user_error = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[KeyConstant.ERROR_GENERAL] = this.general_error;
    data[KeyConstant.ERROR_KEY_USER] = this.user_error;
    return data;
  }
}
