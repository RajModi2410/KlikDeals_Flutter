class EditCouponResponse {
  bool status;
  String message;
  ErrorMessage errorMessage;

  EditCouponResponse({this.status, this.message, this.errorMessage});

  EditCouponResponse.fromJson(Map<String, dynamic> json, bool isError) {
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
}

class ErrorMessage {
  List<String> startDate;

  ErrorMessage({this.startDate});

  ErrorMessage.fromJson(Map<String, dynamic> json) {
    startDate = json['start_date'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['start_date'] = this.startDate;
    return data;
  }
}
