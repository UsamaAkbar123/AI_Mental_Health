import 'package:flutter/material.dart';
import 'package:freud_ai/configs/helper/splash_factor.dart';

const fontFamily = 'Urbanist';

///App Light Theme
final themeLight = ThemeData(
  primaryColorLight: const Color(0xFF4F3422),
  brightness: Brightness.light,
  primaryColor: const Color(0xFF4F3422),
  highlightColor: Colors.black,
  canvasColor: Colors.white,
  fontFamily: fontFamily,
  splashColor: Colors.transparent,
  scaffoldBackgroundColor: const Color(0xFFF7F4F2),
  colorScheme: lightColorScheme,
  splashFactory: const NoSplashFactory(),
);

///App Dark Theme
final themeDark = ThemeData(
  brightness: Brightness.dark,
  primaryColorDark: const  Color(0xFF4F3422),
  primaryColor: const Color(0xFF4F3422),
  highlightColor: const Color(0xFFF7F4F2),
  canvasColor: Colors.white,
  fontFamily: fontFamily,
  splashColor: Colors.transparent,
  scaffoldBackgroundColor: Colors.black,
  colorScheme: darkColorScheme
);


/// Custom light color scheme
const lightColorScheme = ColorScheme(
  primary: Color(0xFF4F3422),
  secondary: Colors.black,
  surface: Colors.white,
  // background: Color(0xFFF7F4F2),
  error: Colors.red,
  onPrimary: Colors.white,
  onSecondary: Colors.white,
  onSurface: Colors.black,
  // onBackground: Colors.black,
  onError: Colors.white,
  brightness: Brightness.light,
);

/// Custom dark color scheme
final darkColorScheme = ColorScheme(
  primary: const Color(0xFF4F3422),
  secondary: const Color(0xFF4F3422),
  surface: Colors.grey[800]!,
  // background: Colors.black,
  error: Colors.red,
  onPrimary: Colors.white,
  onSecondary: Colors.white,
  onSurface: Colors.white,
  // onBackground: Colors.white,
  onError: Colors.white,
  brightness: Brightness.dark,
);

