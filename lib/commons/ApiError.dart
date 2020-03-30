import 'package:vendor/commons/KeyConstant.dart';

abstract class ApiError {
  bool isTokenError();

  bool checkTokenError(List<String> generalError) {
    bool isToken = false;
    if (generalError == null) {
      isToken = false;
    }
    isToken = (generalError.contains(KeyConstant.TOKEN_INVALID));
    print("we are getting token $isToken");
    return isToken;
  }

  String getCommonError() {
    return null;
  }
}
