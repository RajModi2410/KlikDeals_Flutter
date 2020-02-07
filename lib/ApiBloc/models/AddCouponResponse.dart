class AddCouponResponse {
  bool status;
  String message;
  ErrorMessage errorMessage;

  AddCouponResponse({this.status, this.message, this.errorMessage});

  AddCouponResponse.fromJson(Map<String, dynamic> json, bool param1) {
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
  List<String> startDate;
  List<String> endDate;

  ErrorMessage({this.startDate, this.endDate});

  ErrorMessage.fromJson(Map<String, dynamic> json) {
    startDate = json['start_date'].cast<String>();
    endDate = json['end_date'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    return data;
  }
}
