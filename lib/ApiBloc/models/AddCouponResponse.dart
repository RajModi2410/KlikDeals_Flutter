class AddCouponResponse {
  bool status;
  String message;
  ErrorMessage errorMessage;

  AddCouponResponse({this.status, this.message, this.errorMessage});

  AddCouponResponse.fromJson(Map<String, dynamic> json, bool isError) {
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
  List<String> couponCode;
  List<String> startDate;
  List<String> endDate;
  List<String> description;
  List<String> couponImage;

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

    if (keys.contains("coupon_code")) {
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['description'] = this.description;
    data['coupon_image'] = this.couponImage;
    return data;
  }
}
