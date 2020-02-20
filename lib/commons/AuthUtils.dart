import 'package:shared_preferences/shared_preferences.dart';

class AuthUtils {
  static final String authTokenKey = 'token';
  static String getToken(SharedPreferences prefs) {
    return prefs.getString(authTokenKey);
  }
}