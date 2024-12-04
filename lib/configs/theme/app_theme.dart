import 'package:flutter/material.dart';

import 'app_core_theme.dart';

class AppTheme {
  /// Init The AppCore Theme
  static AppCoreTheme? cT;

  static init(BuildContext context) {
    cT = isDark(context) ? dark : light;
  }

  ///Check The App Theme
  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  ///App Core Theme
  static final _core = AppCoreTheme(
    redColor: const Color(0xffDE0303),
    orangeColor: const Color(0xFFED7E1C),
    orangeDark: const Color(0xFFC96100),
    orangeColor50: const Color(0xFFF6A360),
    orangeColorLight: const Color(0xFFFFEEE2),
    blueColor: const Color(0xFF7DB9E8),
    blueColorLight: const Color(0xFFC9E7FF),
    purpleColor: const Color(0xFFA694F5),
    purpleShadow: const Color(0x26A18FFF),
    scaffoldLight: const Color(0xFFF7F4F2),
    appColorDark: const Color(0xFF251404),
    appColorLight: const Color(0xFF4F3422),
    greenColor: const Color(0xFF9BB168),
    greenColor50: const Color(0xFFB4C48D),
    lightGreenColor: const Color(0xFFE5EAD7),
    greyColor: const Color(0xFF736B66),
    lightGrey: const Color(0xFFC9C7C5),
    lightGrey50: const Color(0xFFE1E1E0),
    yellowColor: const Color(0xFFFFBD1A),
    lightYellowColor: const Color(0xFFFFF6E4),
    brownColor: const Color(0xFF926247),
    brownColor50: const Color(0xFFD6C2B8),
    lightBrownColor: const Color(0xFFE8DDD9),
    brownShadow: const Color(0x3F926247),
    appShadow: const Color(0x3FFFFFFF),
    whiteColor: Colors.white,
  );

  ///App Core Light theme
  static AppCoreTheme light = _core.copyWith(
    orangeColor: const Color(0xFFED7E1C),
  );

  ///App Core Dark Theme
  static AppCoreTheme dark = _core.copyWith(
    orangeColor: const Color(0xFFED7E1C),
  );
}
