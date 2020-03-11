import 'package:vendor/commons/ApiError.dart';
import 'package:vendor/commons/ApiResponse.dart';
import 'package:vendor/commons/KeyConstant.dart';

class EditCouponResponse extends ApiResponse {
  bool status;
  String message;
  ErrorMessage errorMessage;

  EditCouponResponse({this.status, this.message, this.errorMessage})
      : super.error(false);

  EditCouponResponse.fromJson(Map<String, dynamic> json, bool isError)
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.errorMessage != null) {
      data['error_message'] = this.errorMessage.toJson();
    }
    return data;
  }

  EditCouponResponse.error() : super.network() {
    status = false;
    message = (KeyConstant.ERROR_CONNECTION_TIMEOUT);
    errorMessage = ErrorMessage.error(KeyConstant.ERROR_CONNECTION_TIMEOUT);
  }

  @override
  bool isTokenError() {
    
    return errorMessage.isTokenError();
  }
}

class ErrorMessage extends ApiError {
  List<String> couponCode;
  List<String> startDate;
  List<String> endDate;
  List<String> description;
  List<String> couponImage;
  List<String> error;

  ErrorMessage(
      {this.startDate,
      this.endDate,
      this.couponImage,
      this.description,
      this.couponCode});

  ErrorMessage.fromJson(Map<String, dynamic> json) {
    var keys = json.keys;
    if (keys.contains("coupon_code")) {
      couponCode = json['coupon_code'].cast<String>();
    } else {
      couponCode = [];
    }

    if (keys.contains("start_date")) {
      startDate = json['start_date'].cast<String>();
    } else {
      startDate = [];
    }

    if (keys.contains("end_date")) {
      endDate = json['end_date'].cast<String>();
    } else {
      couponCode = [];
    }

    if (keys.contains("description")) {
      description = json['description'].cast<String>();
    } else {
      description = [];
    }

    if (keys.contains("coupon_image")) {
      couponImage = json['coupon_image'].cast<String>();
    } else {
      couponImage = [];
    }

    if (keys.contains("error")) {
      error = json['error'].cast<String>();
    } else {
      error = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['description'] = this.description;
    data['coupon_image'] = this.couponImage;
    data['error'] = this.error;
    return data;
  }

  ErrorMessage.error(String error) {
    this.error = [error];
  }

  @override
  bool isTokenError() {
    
    return super.checkTokenError(error);
  }

  @override
  String getCommonError() {
    String returnError;
    if (couponCode != null && couponCode.length > 0) {
      returnError = couponCode.first;
      print("We got the error in Coupon Code::$returnError");
    } else if (startDate != null && startDate.length > 0) {
      returnError = startDate.first;
    } else if (endDate != null && endDate.length > 0) {
      returnError = endDate.first;
    } else if (couponImage != null && couponImage.length > 0) {
      returnError = couponImage.first;
      print("We got the error in Coupon image::$returnError");
    } else if (description != null && description.length > 0) {
      returnError = description.first;
    } else if (error != null && error.length > 0) {
      returnError = error.first;
    }
    return returnError;
  }
}
