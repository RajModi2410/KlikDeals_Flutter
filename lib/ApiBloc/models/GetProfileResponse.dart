import 'package:vendor/commons/ApiError.dart';
import 'package:vendor/commons/ApiResponse.dart';
import 'package:vendor/commons/KeyConstant.dart';

class GetProfileResponse   extends ApiResponse{
  bool status;
  String message;
  Response response;
  ErrorMessage errorMessage;

  GetProfileResponse(
      {this.status, this.message, this.response, this.errorMessage}): super.error(false);

  GetProfileResponse.fromJson(Map<String, dynamic> json, bool isError) : super.error(isError){
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

   GetProfileResponse.error(): super.network() {
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
  String name;
  String email;
  String address;
  String phoneNumber;
  String website;
  String about;
  String logo;
  String banner;
  String latitude;
  String longitude;
  String countryId;
  String stateId;

  Response(
      {this.name,
        this.email,
        this.address,
        this.phoneNumber,
        this.website,
        this.about,
        this.logo,
        this.banner,
        this.latitude,
        this.longitude,
        this.countryId,
        this.stateId});

  Response.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    address = json['address'];
    phoneNumber = json['phone_number'];
    website = json['website'];
    about = json['about'];
    logo = json['logo'];
    banner = json['banner'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    countryId = json['country_id'];
    stateId = json['state_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['address'] = this.address;
    data['phone_number'] = this.phoneNumber;
    data['website'] = this.website;
    data['about'] = this.about;
    data['logo'] = this.logo;
    data['banner'] = this.banner;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['country_id'] = this.countryId;
    data['state_id'] = this.stateId;
    return data;
  }
}

class ErrorMessage extends ApiError{
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


   ErrorMessage.error(String error) {
    this.error = [error];
  }

  @override
  bool isTokenError() {
    return super.checkTokenError(error);
  }
}
