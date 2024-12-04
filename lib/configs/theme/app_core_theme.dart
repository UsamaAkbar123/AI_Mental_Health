import 'package:flutter/material.dart';

class AppCoreTheme {
  Color? appColor;
  Color? appColorLight;
  Color? appColorDark;

  Color? appBlackColor;
  Color? appBlackColorLight;

  Color? orangeColor;
  Color? orangeColor50;
  Color? scaffoldLight;

  Color? whiteColor;
  Color? greenColor;
  Color? greenColor50;
  Color? lightGreenColor;
  Color? greyColor;
  Color? lightGrey;
  Color? lightGrey50;
  Color? purpleColor;
  Color? purpleShadow;
  Color ? redColor;

  Color? shadow;
  Color? lightBrownColor;
  Color? brownColor;
  Color? yellowColor;
  Color? brownColor50;
  Color? blueColor;
  Color? blueColorLight;
  Color? lightYellowColor;
  Color? orangeColorLight;
  Color? brownShadow;
  Color? appShadow;
  Color? orangeDark;

  AppCoreTheme({
    this.appColor,
    this.appColorLight,
    this.appColorDark,
    this.appBlackColor,
    this.appBlackColorLight,
    this.orangeColor,
    this.scaffoldLight,
    this.whiteColor,
    this.redColor,
    this.greenColor,
    this.greyColor,
    this.shadow,
    this.lightGreenColor,
    this.greenColor50,
    this.lightBrownColor,
    this.purpleColor,
    this.lightGrey,
    this.lightGrey50,
    this.purpleShadow,
    this.yellowColor,
    this.brownColor,
    this.brownColor50,
    this.blueColor,
    this.blueColorLight,
    this.lightYellowColor,
    this.orangeColorLight,
    this.brownShadow,
    this.appShadow,
    this.orangeDark,
    this.orangeColor50,
  });

  AppCoreTheme copyWith({
    Color? appColor,
    Color? appColorLight,
    Color? appColorDark,
    Color? appBlackColor,
    Color? appBlackColorLight,
    Color? appBlackColorDark,
    Color? orangeColor,
    Color? scaffoldLight,
    Color? whiteColor,
    Color? greenColor,
    Color? greyColor,
    Color? shadow,
    Color? shadowSub,
    Color? upsellCard,
    Color? lightGreenColor,
    Color? hotelChipRefundable,
    Color? hotelChipAirportTransfer,
    Color? lightBrownColor,
    Color? lightGrey,
    Color? lightGrey50,
    Color? greenColor50,
    Color? purpleColor,
    Color? purpleShadow,
    Color? yellowColor,
    Color? brownColor,
    Color? brownColor50,
    Color? blueColor,
    Color? blueColorLight,
    Color? lightYellowColor,
    Color? orangeColorLight,
    Color? brownShadow,
    Color? appShadow,
    Color? orangeDark,
    Color? orangeColor50,
    Color ? redColor,
  }) {
    return AppCoreTheme(
      appColor: appColor ?? this.appColor,
      appColorLight: appColorLight ?? this.appColorLight,
      appColorDark: appColorDark ?? this.appColorDark,
      appBlackColor: appBlackColor ?? this.appBlackColor,
      appBlackColorLight: appBlackColorLight ?? this.appBlackColorLight,
      orangeColor: orangeColor ?? this.orangeColor,
      scaffoldLight: scaffoldLight ?? this.scaffoldLight,
      whiteColor: whiteColor ?? this.whiteColor,
      redColor: redColor ?? this.redColor,
      greenColor: greenColor ?? this.greenColor,
      greyColor: greyColor ?? this.greyColor,
      shadow: shadow ?? this.shadow,
      lightGreenColor: lightGreenColor ?? this.lightGreenColor,
      lightBrownColor: shadowSub ?? this.lightBrownColor,
      lightGrey: lightGrey ?? this.lightGrey,
      lightGrey50: lightGrey50 ?? this.lightGrey50,
      greenColor50: greenColor50 ?? this.greenColor50,
      purpleColor: purpleColor ?? this.purpleColor,
      purpleShadow: purpleShadow ?? this.purpleShadow,
      yellowColor: yellowColor ?? this.yellowColor,
      brownColor: brownColor ?? this.brownColor,
      brownColor50: brownColor50 ?? this.brownColor50,
      blueColor: brownColor50 ?? this.blueColor,
      blueColorLight: brownColor50 ?? this.blueColorLight,
      lightYellowColor: lightYellowColor ?? this.lightYellowColor,
      orangeColorLight: orangeColorLight ?? this.orangeColorLight,
      brownShadow: brownShadow ?? this.brownShadow,
      appShadow: appShadow ?? this.appShadow,
      orangeDark: orangeDark ?? this.orangeDark,
      orangeColor50: orangeColor50 ?? this.orangeColor50,
    );
  }
}
