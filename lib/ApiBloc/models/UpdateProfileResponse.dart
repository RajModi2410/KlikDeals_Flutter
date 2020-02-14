class UpdateProfileResponse {
  bool status;
  String message;
  Response response;
  ErrorMessage errorMessage;

  UpdateProfileResponse(
      {this.status, this.message, this.response, this.errorMessage});

  UpdateProfileResponse.fromJson(Map<String, dynamic> json, bool isError) {
    status = json['status'];
    message = json['message'];
    response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
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

class ErrorMessage {
  List<String> mapLat;
  List<String> mapLog;
  List<String> phoneNumber;

  ErrorMessage({this.mapLat, this.mapLog, this.phoneNumber});

  ErrorMessage.fromJson(Map<String, dynamic> json) {
    mapLat = json['map_lat'].cast<String>();
    mapLog = json['map_log'].cast<String>();
    phoneNumber = json['phone_number'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['map_lat'] = this.mapLat;
    data['map_log'] = this.mapLog;
    data['phone_number'] = this.phoneNumber;
    return data;
  }
}
