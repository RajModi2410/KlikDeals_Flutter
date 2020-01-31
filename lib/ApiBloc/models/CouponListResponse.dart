class CouponListResponse {
  bool status;
  String message;
  Response response;
  ErrorMessage errorMessage;

  CouponListResponse(
      {this.status, this.message, this.response, this.errorMessage});

  CouponListResponse.fromJson(Map<String, dynamic> json, bool parseError) {
    status = json['status'];
    message = json['message'];

    if (!parseError) {
      response = json['response'] != null
          ? new Response.fromJson(json['response'])
          : null;
    } else {
      response = null;
    }
    if (parseError) {
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

  @override
  String toString() {
    return 'CouponListResponse{status: $status, message: $message, response: $response, errorMessage: $errorMessage}';
  }
}

class Response {
  int currentPage;
  List<Data> data;
  int from;
  String nextPageUrl;
  String path;
  String perPage;
  String prevPageUrl;
  int to;

  Response(
      {this.currentPage,
      this.data,
      this.from,
      this.nextPageUrl,
      this.path,
      this.perPage,
      this.prevPageUrl,
      this.to});

  Response.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    from = json['from'];
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['from'] = this.from;
    data['next_page_url'] = this.nextPageUrl;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['prev_page_url'] = this.prevPageUrl;
    data['to'] = this.to;
    return data;
  }
}

class Data {
  int id;
  String vendorId;
  String couponCode;
  String description;
  String status;
  String grabDate;
  String startDate;
  String endDate;

  Data(
      {this.id,
      this.vendorId,
      this.couponCode,
      this.description,
      this.status,
      this.grabDate,
      this.startDate,
      this.endDate});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vendorId = json['vendor_id'];
    couponCode = json['coupon_code'];
    description = json['description'];
    status = json['status'];
    grabDate = json['grab_date'];
    startDate = json['start_date'];
    endDate = json['end_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['vendor_id'] = this.vendorId;
    data['coupon_code'] = this.couponCode;
    data['description'] = this.description;
    data['status'] = this.status;
    data['grab_date'] = this.grabDate;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    return data;
  }

  @override
  String toString() {
    return 'Data{id: $id, vendorId: $vendorId, couponCode: $couponCode, description: $description, status: $status, grabDate: $grabDate, startDate: $startDate, endDate: $endDate}';
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

  @override
  String toString() {
    return 'ErrorMessage{error: $error}';
  }
}
