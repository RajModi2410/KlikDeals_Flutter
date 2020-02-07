class DeleteCouponResponse {
  bool status;
  String message;
  ErrorMessage errorMessage;

  DeleteCouponResponse({this.status, this.message, this.errorMessage});

  DeleteCouponResponse.fromJson(Map<String, dynamic> json, bool param1) {
    status = json['status'];
    message = json['message'];

    errorMessage = json['error_message'] != null
        ? new ErrorMessage.fromJson(json['error_message'])
        : null;
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
}

class ErrorMessage {
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
}
