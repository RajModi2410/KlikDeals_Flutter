class KeyConstant {
  static const String ERROR_GENERAL = "error";
  static const String ERROR_LAT = "map_lat";
  static const String ERROR_LONG = "map_log";
  static const String ERROR_PHONE = "phone_number";
  static const String ERROR_BANNER = "banner";
  static const String ERROR_LOGO = "logo";

//For Vendor Login
  static const String ERROR_KEY_USER = "user";

  static const String KEY_IMAGE_1 = "KEY_IMAGE_1";

  static const String ERROR_CONNECTION_TIMEOUT =
      "Please check your connection and try again!";

  // static const String ERROR_NO_COUPON_ACTIVE = AppLocalizations.of(context).translate("error_no_coupon_active");

  static const String ERROR_NO_COUPON_HISTORY =
      "You don't have any grabbed or redeem coupon yet!";

  static const String TOKEN_INVALID = "Token is not valid.";

  static const String NO_INTERNET =
      "We are unable to complete your request. Please check your internet connection and Try again later!";

  static RegExp editReg() {
    return RegExp("[a-zA-Z0-9 _-]");
  }

  static RegExp numberReg() {
    return RegExp("[0-9]");
  }
   /* static RegExp descriptionReg() {
     return RegExp(r'^[a-zA-Z0-9_\-=@%,\.;]+$');
   }*/

  //%$*(){}[]:;''""
}
