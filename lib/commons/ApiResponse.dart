import 'package:klik_deals/commons/AppExceptions.dart';

abstract class ApiResponse {
  ApiStatus apiStatus;

  ApiResponse(this.apiStatus);

  ApiResponse.error(bool isError) {
    apiStatus = isError ? ApiStatus.ERROR : ApiStatus.COMPLETED;
  }

  ApiResponse.network() {
    apiStatus = ApiStatus.NETWORK_ERROR;
    throw NoInternetException("No Internet connection");
  }

  @override
  String toString() {
    return "Status : $apiStatus";
  }

  bool isTokenError();
}

enum ApiStatus { LOADING, COMPLETED, ERROR, NETWORK_ERROR }
