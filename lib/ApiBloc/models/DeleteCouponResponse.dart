import 'package:vendor/commons/ApiError.dart';
import 'package:vendor/commons/ApiResponse.dart';
import 'package:vendor/commons/KeyConstant.dart';

class DeleteCouponResponse extends ApiResponse {
  bool status;
  String message;
  ErrorMessage errorMessage;

  DeleteCouponResponse({this.status, this.message, this.errorMessage})
      : super.error(false);

  DeleteCouponResponse.fromJson(Map<String, dynamic> json, bool isError)
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

  DeleteCouponResponse.error() : super.network() {
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
  List<String> error;

  ErrorMessage({this.error});

  ErrorMessage.fromJson(Map<String, dynamic> json) {
    error = json['error'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    return data;
  }

  @override
  String toString() {
    return 'ErrorMessage{error: $error}';
  }

  ErrorMessage.error(String error) {
    this.error = [error];
  }

  @override
  bool isTokenError() {
    
    return super.checkTokenError(error);
  }
}
