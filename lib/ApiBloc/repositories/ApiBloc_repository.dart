import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:klik_deals/ApiBloc/models/SearchResponse.dart';

import '../ApiBloc_provider.dart';

class ApiBlocRepository {
  final ApiBlocProvider _apiBlocProvider = ApiBlocProvider();

  ApiBlocRepository();

  void test(bool isError) {
    this._apiBlocProvider.test(isError);
  }

  String baseUrl = "https://developers.zomato.com/api/v2.1/";
  String key = "753aa59220ffd0cd2804ea892deaa693";
  final successCode = 200;

  Future<SearchResponse> searchRestaurant(String query, int count) async {
    final response = await http.get(
        baseUrl + "search?q=" + query + "&count=$count",
        headers: getCommonHeaders());
    return parseResponse(response);
  }

  Future<SearchResponse> login(String email, String pass) async {
    final response = await http.get(
      //TODO need to change as per API
        baseUrl + " Need to change",
        headers: getCommonHeaders());
    return parseResponse(response);
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
}
