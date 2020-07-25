import 'dart:math';

class Dimensions {
  static double fontSize8 = 8;
  static double fontSize10 = 10;
  static double fontSize11 = 11;
  static double fontSize12 = 12;
  static double fontSize14 = 14;
  static double fontSize16 = 16;
  static double fontSize18 = 18;
  static double fontSize20 = 20;
  static double fontSize22 = 22;

  static double getCellHeight(double mediaHeight, double mediaWidth) {
    //Top padding + top header + header bottom padding + description 3 lines + desc. top padding
    //+ empty text + top of button padding + button + 16px for safety
    double heights = 8 + 18 + 2 + (fontSize14 * 3) + 2 + fontSize10 + 2 +
        fontSize16 + 24;
    double recommendedHeight = mediaWidth * (9 / 16);
    return max(heights, recommendedHeight);
  }

}
