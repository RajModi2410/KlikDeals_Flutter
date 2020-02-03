import 'dart:convert';

import 'package:dio/dio.dart' as Dio;
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:klik_deals/ApiBloc/models/CouponListResponse.dart';
import 'package:klik_deals/ApiBloc/models/LoginResponse.dart';
import 'package:klik_deals/ApiBloc/models/SearchResponse.dart';

import '../ApiBloc_provider.dart';

class ApiBlocRepository {
  final ApiBlocProvider _apiBlocProvider = ApiBlocProvider();
  var dio = Dio.Dio();

  ApiBlocRepository() {
    dio.interceptors.add(LogInterceptor(responseBody: true));
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
      if (e.response != null) {
        Dio.Response response = e.response;
        return parseLoginResponse(response);
      }
    }
  }

  Future<CouponListResponse> coupon(Map map) async {
    print(baseUrl + "listcouponbyvendor:" + map.toString());
    Dio.FormData formData = new Dio.FormData.fromMap(map);
    try {
      Dio.Response response = await dio.post(baseUrl + "listcouponbyvendor",
          data: map, options: Dio.Options(headers: getCommonHeaders()));
      // final response = await http.post(
      //     baseUrl + "listcouponbyvendor",
      //     headers: getCommonHeaders());
      return parseCouponResponse(response);
    } on Dio.DioError catch (e) {
      if (e.response != null) {
        Dio.Response response = e.response;
        return parseCouponResponse(response);
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
    return LoginResponse.fromJson(responseString,response.statusCode != successCode);
  }

  CouponListResponse parseCouponResponse(Dio.Response response) {
    print("Coupon Response :: ${response.data}");
    final responseString = (response.data);

    if (response.statusCode == successCode) {
      return CouponListResponse.fromJson(responseString, false);
    } else {
      return CouponListResponse.fromJson(responseString, true);
    }
  }
}
