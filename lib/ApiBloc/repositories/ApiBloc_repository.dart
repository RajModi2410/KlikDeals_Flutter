import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as Dio;
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:klik_deals/ApiBloc/ApiBloc_event.dart';
import 'package:klik_deals/ApiBloc/models/AddCouponResponse.dart';
import 'package:klik_deals/ApiBloc/models/CouponListResponse.dart';
import 'package:klik_deals/ApiBloc/models/DeleteCouponResponse.dart';
import 'package:klik_deals/ApiBloc/models/EditCouponResponse.dart';
import 'package:klik_deals/ApiBloc/models/GetProfileResponse.dart';
import 'package:klik_deals/ApiBloc/models/LoginResponse.dart';
import 'package:klik_deals/ApiBloc/models/SearchResponse.dart';
import 'package:klik_deals/ApiBloc/models/UpdateProfileResponse.dart';
import 'package:klik_deals/commons/ApiResponse.dart';
import 'package:klik_deals/commons/AppExceptions.dart';
import 'package:path/path.dart';

import '../ApiBloc_provider.dart';

typedef void VoidCallback();

class ApiBlocRepository {
  final ApiBlocProvider _apiBlocProvider = ApiBlocProvider();
  var dio = Dio.Dio();
  static dynamic Function() simples;

  static final ApiBlocRepository _instance = ApiBlocRepository._internal();

  factory ApiBlocRepository({Function onRevoke}) {
    print("this is factory");
    if (simples == null) {
      simples = onRevoke;
    }

    return _instance;
  }

  ApiBlocRepository._internal() {
    print("this is factory _internal");
    dio.interceptors.add(LogInterceptor(responseBody: false));
    dio.options.connectTimeout = 5000; //5s
    dio.options.receiveTimeout = 3000;
    // dio
    //   ..interceptors.add(InterceptorsWrapper(
    //       onError: (DioError dioError) => errorInterceptor(dioError)));
    // _onRevoke();
  }

  void test(bool isError) {
    this._apiBlocProvider.test(isError);
  }

  String zometoUrl = "https://developers.zomato.com/api/v2.1/";
  String baseUrl = "https://wdszone.com/klikdeals/api/v1/";
  String key = "753aa59220ffd0cd2804ea892deaa693";
  String token;
  final successCode = 200;

  Future<SearchResponse> searchRestaurant(String query, int count) async {
    final response = await http.get(
        baseUrl + "search?q=" + query + "&count=$count",
        headers: getCommonHeaders());
    return parseResponse(response);
  }

  Future<LoginResponse> login(Map map) async {
    try {
      print(baseUrl + "vendorlogin" + map.toString());
      Dio.FormData formData = new Dio.FormData.fromMap(map);
      Dio.Response response =
          await dio.post(baseUrl + "vendorlogin", data: formData);
      return parseLoginResponse(response);
    } on Dio.DioError catch (e) {
      print(e.type);
      if (e.type == Dio.DioErrorType.RECEIVE_TIMEOUT ||
          e.type == Dio.DioErrorType.DEFAULT ||
          e.type == Dio.DioErrorType.CONNECT_TIMEOUT) {
        // return LoginResponse.error();
        throw NoInternetException("");
      } else if (e.response != null) {
        Dio.Response response = e.response;
        return parseLoginResponse(response);
      }
    }
  }

  Future<CouponListResponse> coupon(Map map) async {
    print(baseUrl + "listcouponbyvendor:" + map.toString());
    Dio.FormData formData = new Dio.FormData.fromMap(map);
    try {
      Dio.Response response = await dio.get(baseUrl + "listcouponbyvendor",
          queryParameters: map,
          options: Dio.Options(headers: getCommonHeaders()));

      return parseCouponResponse(response);
    } on Dio.DioError catch (e) {
      print(e.type);
      if (e.type == Dio.DioErrorType.RECEIVE_TIMEOUT ||
          e.type == Dio.DioErrorType.DEFAULT ||
          e.type == Dio.DioErrorType.CONNECT_TIMEOUT) {
        // return CouponListResponse.error();
        throw NoInternetException("");
      } else if (e.response != null) {
        Dio.Response response = e.response;
        return checkForTokenError(parseCouponResponse(response));
      }
    }
  }

  ApiResponse checkForTokenError(ApiResponse apiResponse) {
    if (apiResponse.isTokenError()) {
      simples();
    }
    return apiResponse;
  }

  Future<AddCouponResponse> addCoupon(AddCouponEvent map, File image) async {
    print(baseUrl + "addcoupon:" + map.toMap().toString());
    Dio.FormData formData = null;
    if (image != null) {
      String fileName = basename(image.path);
      print("File base name: $fileName");

      formData = FormData.fromMap({
        "coupon_code": map.couponCodeValue,
        "start_date": map.startDateValue,
        "end_date": map.endDateValue,
        "description": map.descValue,
        "coupon_image":
            await MultipartFile.fromFile(image.path, filename: fileName)
      });
    } else {
      formData = FormData.fromMap({
        "coupon_code": map.couponCodeValue,
        "start_date": map.startDateValue,
        "end_date": map.endDateValue,
        "description": map.descValue,
      });
    }

    try {
      Dio.Response response = await dio.post(baseUrl + "addcoupon",
          data: formData, options: Dio.Options(headers: getCommonHeaders()));
      print("We got Some message :: ${response.data.toString()}");
      return parseAddCouponResponse(response);
    } on Dio.DioError catch (e) {
      if (e.type == Dio.DioErrorType.RECEIVE_TIMEOUT ||
          e.type == Dio.DioErrorType.DEFAULT ||
          e.type == Dio.DioErrorType.CONNECT_TIMEOUT) {
        // return AddCouponResponse.error();
        throw NoInternetException("");
      } else if (e.response != null) {
        Dio.Response response = e.response;
        return checkForTokenError(parseAddCouponResponse(response));
      }
    }
  }

  Future<EditCouponResponse> editCoupon(EditCouponEvent map, File image) async {
    print(baseUrl + "editcoupon:" + map.toString());
    String fileName;
    if (image != null) {
      fileName = basename(image.path);
      print("File base name: $fileName");
    }
    Dio.FormData formData = FormData.fromMap({
      "coupon_code": map.couponCodeValue,
      "start_date": map.startDateValue,
      "end_date": map.endDateValue,
      "description": map.descValue,
      "id": map.id,
      if (image != null)
        "coupon_image":
            await MultipartFile.fromFile(image.path, filename: fileName)
    });

    try {
      Dio.Response response = await dio.post(baseUrl + "editcoupon",
          data: formData, options: Dio.Options(headers: getCommonHeaders()));
      print("We got Some message :: ${response.data.toString()}");
      return parseEditCouponResponse(response);
    } on Dio.DioError catch (e) {
      if (e.type == Dio.DioErrorType.RECEIVE_TIMEOUT ||
          e.type == Dio.DioErrorType.DEFAULT ||
          e.type == Dio.DioErrorType.CONNECT_TIMEOUT) {
        // return EditCouponResponse.error();
        throw NoInternetException("");
      } else if (e.response != null) {
        Dio.Response response = e.response;
        return checkForTokenError(parseEditCouponResponse(response));
      }
    }
  }

  Future<UpdateProfileResponse> updateProfile(
      UpdatePofileEvent map, File logo, File banner) async {
    print(baseUrl + "vendorprofile:" + map.toString());
    String logoFileName;
    String bannerFileName;
    if (logo != null) {
      logoFileName = basename(logo.path);
      print("logoFileName File base name: $logoFileName");
    }
    if (banner != null) {
      bannerFileName = basename(banner.path);
      print("bannerFileName File base name: $bannerFileName");
    }
    Dio.FormData formData = FormData.fromMap({
      "name": map.name,
      "address": map.name,
      "map_lat": map.map_lat,
      "map_log": map.map_log,
      "phone_number": map.phone_number,
      "email": map.email,
      "website": map.website,
      "about": map.about,
      if (logo != null)
        "logo": await MultipartFile.fromFile(logo.path, filename: logoFileName),
      if (banner != null)
        "banner":
            await MultipartFile.fromFile(banner.path, filename: bannerFileName),
    });

    try {
      Dio.Response response = await dio.post(baseUrl + "vendorprofile",
          data: formData, options: Dio.Options(headers: getCommonHeaders()));
      print("We got Some message :: ${response.data.toString()}");
      return parseUpdateProfileResponse(response);
    } on Dio.DioError catch (e) {
      print("we got dio vendorprofile : " + e.type.toString());
      if (e.type == Dio.DioErrorType.RECEIVE_TIMEOUT ||
          e.type == Dio.DioErrorType.DEFAULT ||
          e.type == Dio.DioErrorType.CONNECT_TIMEOUT) {
        throw NoInternetException("");
        // return UpdateProfileResponse.error();
      } else if (e.response != null) {
        Dio.Response response = e.response;
        return checkForTokenError(parseUpdateProfileResponse(response));
      }
    }
  }

  Future<DeleteCouponResponse> deleteCoupon(Map map) async {
    print(baseUrl + "deletecoupon:" + map.toString());
    Dio.FormData formData = new Dio.FormData.fromMap(map);
    try {
      Dio.Response response = await dio.post(baseUrl + "deletecoupon",
          data: formData, options: Dio.Options(headers: getCommonHeaders()));
      return parseDeleteCouponResponse(response);
    } on Dio.DioError catch (e) {
      if (e.type == Dio.DioErrorType.RECEIVE_TIMEOUT ||
          e.type == Dio.DioErrorType.DEFAULT ||
          e.type == Dio.DioErrorType.CONNECT_TIMEOUT) {
        // return DeleteCouponResponse.error();
        throw NoInternetException("");
      } else if (e.response != null) {
        Dio.Response response = e.response;
        return checkForTokenError(parseDeleteCouponResponse(response));
      }
    }
  }

  Future<GetProfileResponse> getProfile() async {
    print(baseUrl + "getvendorprofile");
    try {
      Dio.Response response = await dio.post(baseUrl + "getvendorprofile",
          options: Dio.Options(headers: getCommonHeaders()));
      return parseGetProfileResponse(response);
    } on Dio.DioError catch (e) {
      print("we got dio error : " + e.type.toString());
      if (e.type == Dio.DioErrorType.RECEIVE_TIMEOUT ||
          e.type == Dio.DioErrorType.DEFAULT ||
          e.type == Dio.DioErrorType.CONNECT_TIMEOUT) {
        // return GetProfileResponse.error();
        throw NoInternetException("");
      } else if (e.response != null) {
        Dio.Response response = e.response;
        return checkForTokenError(parseGetProfileResponse(response));
      }
    }
  }

  Map<String, String> getCommonHeaders() => {"token": token};

  SearchResponse parseResponse(http.Response response) {
    final responseString = jsonDecode(response.body);

    if (response.statusCode == successCode) {
      return SearchResponse.fromJson(responseString);
    } else {
      throw Exception('failed to load players');
    }
  }

  LoginResponse parseLoginResponse(Dio.Response response) {
    print("LoginResponse :: ${response.data}");
    final responseString = (response.data);
    return LoginResponse.fromJson(
        responseString, response.statusCode != successCode);
  }

  CouponListResponse parseCouponResponse(Dio.Response response) {
    final responseString = (response.data);
    return CouponListResponse.fromJson(
        responseString, response.statusCode != successCode);
  }

  AddCouponResponse parseAddCouponResponse(Dio.Response response) {
    final responseString = (response.data);
    return AddCouponResponse.fromJson(
        responseString, response.statusCode != successCode);
  }

  EditCouponResponse parseEditCouponResponse(Dio.Response response) {
    final responseString = (response.data);
    return EditCouponResponse.fromJson(
        responseString, response.statusCode != successCode);
  }

  UpdateProfileResponse parseUpdateProfileResponse(Dio.Response response) {
    final responseString = (response.data);
    return UpdateProfileResponse.fromJson(
        responseString, response.statusCode != successCode);
  }

  DeleteCouponResponse parseDeleteCouponResponse(Dio.Response response) {
    final responseString = (response.data);
    return DeleteCouponResponse.fromJson(
        responseString, response.statusCode != successCode);
  }

  GetProfileResponse parseGetProfileResponse(Dio.Response response) {
    final responseString = (response.data);
    return GetProfileResponse.fromJson(
        responseString, response.statusCode != successCode);
  }

  dynamic errorInterceptor(DioError dioError) {
    print("we are getting error : " + dioError.response.statusCode.toString());
    if (dioError.response.statusCode == 401) {
      // UnauthorizedException exception = UnauthorizedException(dioError);
      throw DioError(error: "Dio can't establish new connection after closed.");
      // exception.message
      // navigatorKey.currentState.pushNamedAndRemoveUntil(
      //   "/login", (Route<dynamic> route) => false);
      // print("let's call onRevoke  and ${simples == null}");
      // simples();
    }
    return dioError;
  }
}

class UnauthorizedException extends DioError {
  Dio.DioError dioError;

  UnauthorizedException(this.dioError) : super() {}
}
