import 'package:klik_deals/commons/ApiError.dart';
import 'package:klik_deals/commons/ApiResponse.dart';
import 'package:klik_deals/commons/KeyConstant.dart';
class EditCouponResponse   extends ApiResponse{
  bool status;
  String message;
  ErrorMessage errorMessage;

  EditCouponResponse({this.status, this.message, this.errorMessage}): super.error(false);

  EditCouponResponse.fromJson(Map<String, dynamic> json, bool isError)  : super.error(isError){
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
    // TODO: implement isTokenError
    return errorMessage.isTokenError();
  }

  
}

class ErrorMessage extends ApiError{
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
    // TODO: implement isTokenError
    return super.checkTokenError(error);
  }
}
