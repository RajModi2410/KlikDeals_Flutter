import 'package:klik_deals/commons/ApiError.dart';
import 'package:klik_deals/commons/ApiResponse.dart';
import 'package:klik_deals/commons/KeyConstant.dart';

class UpdateProfileResponse extends ApiResponse {
  bool status;
  String message;
  Response response;
  ErrorMessage errorMessage;

  UpdateProfileResponse(
      {this.status, this.message, this.response, this.errorMessage})
      : super.error(false);

  UpdateProfileResponse.fromJson(Map<String, dynamic> json, bool isError)
      : super.error(isError) {
    status = json['status'];
    message = json['message'];
    if (!isError) {
      response = json['response'] != null
          ? new Response.fromJson(json['response'])
          : null;
    } else {
      response = null;
    }
    if (isError) {
      errorMessage = json['error_message'] != null
          ? new ErrorMessage.fromJson(json['error_message'])
          : null;
    } else {
      errorMessage = null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.response != null) {
      data['response'] = this.response.toJson();
    }
    if (this.errorMessage != null) {
      data['error_message'] = this.errorMessage.toJson();
    }
    return data;
  }

  UpdateProfileResponse.error() : super.network() {
    status = false;
    message = (KeyConstant.ERROR_CONNECTION_TIMEOUT);
    errorMessage = ErrorMessage.error(KeyConstant.ERROR_CONNECTION_TIMEOUT);
  }

  @override
  bool isTokenError() {
    
    return errorMessage.isTokenError();
  }
}

class Response {
  String address;

  Response({this.address});

  Response.fromJson(Map<String, dynamic> json) {
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    return data;
  }
}

class ErrorMessage extends ApiError {
  List<String> mapLat;
  List<String> mapLog;
  List<String> phoneNumber;
  List<String> banner;
  List<String> logo;
  List<String> error;

  ErrorMessage({this.mapLat, this.mapLog, this.phoneNumber});

  ErrorMessage.fromJson(Map<String, dynamic> json) {
    var keys = json.keys;
    if (keys.contains(KeyConstant.ERROR_LAT)) {
      mapLat = json[KeyConstant.ERROR_LAT].cast<String>();
    } else {
      mapLat = [];
    }

    if (keys.contains(KeyConstant.ERROR_LONG)) {
      mapLog = json[KeyConstant.ERROR_LONG].cast<String>();
    } else {
      mapLog = [];
    }

    if (keys.contains(KeyConstant.ERROR_PHONE)) {
      phoneNumber = json[KeyConstant.ERROR_PHONE].cast<String>();
    } else {
      phoneNumber = [];
    }

    if (keys.contains(KeyConstant.ERROR_BANNER)) {
      banner = json[KeyConstant.ERROR_BANNER].cast<String>();
    } else {
      banner = [];
    }

    if (keys.contains(KeyConstant.ERROR_LOGO)) {
      logo = json[KeyConstant.ERROR_LOGO].cast<String>();
    } else {
      logo = [];
    }

    if (keys.contains(KeyConstant.ERROR_GENERAL)) {
      error = json[KeyConstant.ERROR_GENERAL].cast<String>();
    } else {
      error = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['map_lat'] = this.mapLat;
    data['map_log'] = this.mapLog;
    data['phone_number'] = this.phoneNumber;
    return data;
  }

  ErrorMessage.error(String error) {
    this.error = [error];
  }

  @override
  bool isTokenError() {
    
    return super.checkTokenError(error);
  }
}
