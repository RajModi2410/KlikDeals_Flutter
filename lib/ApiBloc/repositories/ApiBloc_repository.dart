import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:klik_deals/ApiBloc/models/LoginResponse.dart';
import 'package:klik_deals/ApiBloc/models/SearchResponse.dart';

import '../ApiBloc_provider.dart';

class ApiBlocRepository {
  final ApiBlocProvider _apiBlocProvider = ApiBlocProvider();

  ApiBlocRepository();

  void test(bool isError) {
    this._apiBlocProvider.test(isError);
  }

  String zometoUrl = "https://developers.zomato.com/api/v2.1/";
  String baseUrl = "https://wdszone.com/klikdeals/api/v1/";
  String key = "753aa59220ffd0cd2804ea892deaa693";
  final successCode = 200;

  Future<SearchResponse> searchRestaurant(String query, int count) async {
    final response = await http.get(
        baseUrl + "search?q=" + query + "&count=$count",
        headers: getCommonHeaders());
    return parseResponse(response);
  }

  Future<LoginResponse> login(Map map) async {
    print(baseUrl + "vendorlogin" + map.toString());
    final response = await http.post(
        baseUrl + "vendorlogin",
        body: map
    );
    return parseLoginResponse(response);
  }

  Map<String, String> getCommonHeaders() =>
      {"user-key": key, HttpHeaders.acceptEncodingHeader: "application/json"};

  SearchResponse parseResponse(http.Response response) {
    final responseString = jsonDecode(response.body);

    if (response.statusCode == successCode) {
      return SearchResponse.fromJson(responseString);
    } else {
      throw Exception('failed to load players');
    }
  }


  LoginResponse parseLoginResponse(http.Response response) {
    final responseString = jsonDecode(response.body);

    if (response.statusCode == successCode) {
      return LoginResponse.fromJson(responseString);
    } else {
      throw Exception('failed to load players');
    }
  }
}
