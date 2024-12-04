import 'dart:math' as math;

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/configs/constants/constants.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_core_theme.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/routes/routes.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibration/vibration.dart';

class CommonWidgets {
  /// custom dialog box
  Future<bool?> customDialogBox(BuildContext context) async {
    bool ? isConfirm;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm"),
          content: const Text(
            "Are you sure you want to delete this item?",
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                isConfirm = false;
                Navigator.of(context).pop(false);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                isConfirm = true;
                Navigator.of(context).pop(true);
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
    return isConfirm;
  }

  ///Make Grey Text with dynamic size and weight
  Widget makeDynamicText(
      {String? text,
      double? size,
      FontWeight? weight,
      Color? color,
      int? lines,
      double? letterSpacing,
      TextAlign? align}) {
    return Text(
      text ?? "",
      maxLines: lines ?? 2000,
      textAlign: align ?? TextAlign.start,
      overflow: TextOverflow.ellipsis,
      style: commonTextStyle(color, size, weight, letterSpacing: letterSpacing),
    );
  }

  ///
  Widget backButton({Function? backButton, borderColor}) {
    Color color = borderColor ?? AppTheme.cT!.appColorLight;

    return Container(
      width: 48.w,
      height: 48.h,
      margin: EdgeInsets.symmetric(horizontal: 5.w),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
          border: Border.all(width: 1.w, color: color)),
      child: SizedBox(
          width: 24.w,
          height: 24.h,
          child: IconButton(
            icon: SvgPicture.asset(
              "assets/common/back_icon.svg",
              colorFilter: ColorFilter.mode(
                color,
                BlendMode.srcIn,
              ),
            ),
            onPressed: () {
              if (backButton != null) {
                backButton();
              } else {
                Navigate.pop();
              }
            },
          )),
    );
  }

  /// Custom AppBar
  Widget customAppBar({
    Function? callBack,
    borderColor,
    text,
    actionIcon,
    actionWidget,
    showBackButton,
  }) {
    Color color = borderColor ?? AppTheme.cT!.appColorLight;

    return Row(
      children: [
    showBackButton == null || showBackButton
            ? Container(
                width: 48.w,
                height: 48.h,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                  border: Border.all(
                    width: 1.w,
                    color: color,
                  ),
                ),
                child: SizedBox(
                    width: 24.w,
                    height: 24.h,
                  child: IconButton(
                    icon: SvgPicture.asset("assets/common/back_icon.svg",
                      colorFilter: ColorFilter.mode(
                        color,
                        BlendMode.srcIn,
                      ),
                    ),
                    onPressed: () {
                      if (callBack != null) {
                        callBack.call();
                      } else {
                        Navigate.pop();
                      }
                    },
                  ),
                ),
              )
            : const SizedBox(),
        10.width,
        makeDynamicText(
          text: text ?? "",
          size: 26,
          weight: FontWeight.w800,
          color: color,
        ),
        const Spacer(),
        actionIcon != null
            ? SizedBox(
                width: 32.w,
                height: 32.h,
                child: IconButton(
                  icon: SvgPicture.asset("assets/$actionIcon",
                    colorFilter: ColorFilter.mode(
                      color,
                      BlendMode.srcIn,
                    ),
                    fit: BoxFit.cover,
                      width: 32.w,
                    height: 32.h,
                  ),
                  onPressed: () {
                    callBack!.call();
                  },
                ),
              )
            : actionWidget ?? const SizedBox()
      ],
    );
  }

  ///Make Grey Text with dynamic size and weight
  Widget makeDynamicTextSpan(
      {String? text1,
      String? text2,
      String? text3,
      String? text4,
      double? size1,
      double? size2,
      FontWeight? weight1,
      FontWeight? weight2,
      Color? color1,
      Color? color2,
      Color? color3,
      Color? color4,
      int? lines,
      double? letterSpacing,
      bool? showUnderLine1,
      bool? showUnderLine2,
      bool? showUnderLine3,
      VoidCallback? onText2Click,
      VoidCallback? onText3Click,
      TextAlign? align}) {
    return RichText(
      textAlign: align ?? TextAlign.start,
      text: TextSpan(
        text: text1,
        style: commonTextStyle(color1, size1, weight1,
            letterSpacing: letterSpacing, showUnderLine: showUnderLine1),
        children: [
          TextSpan(
            text: text2,
            style: commonTextStyle(color2, size2 ?? size1, weight2 ?? weight1,
                showUnderLine: showUnderLine2, letterSpacing: letterSpacing),
            recognizer: onText2Click != null
                ? (TapGestureRecognizer()..onTap = onText2Click)
                : null,
          ),
          TextSpan(
            text: text3 ?? "",
            style: commonTextStyle(color3, size1, weight1,
                letterSpacing: letterSpacing, showUnderLine: showUnderLine3),
            recognizer: onText3Click != null
                ? (TapGestureRecognizer()..onTap = onText3Click)
                : null,
          ),
          TextSpan(
            text: text4 ?? "",
            style: commonTextStyle(color4, size1, weight1,
                letterSpacing: letterSpacing, showUnderLine: showUnderLine3),
            recognizer: onText3Click != null
                ? (TapGestureRecognizer()..onTap = onText3Click)
                : null,
          ),
        ],
      ),
    );
  }


  ///Common TextStyle
  TextStyle commonTextStyle(color, double? size, weight,
      {showUnderLine, letterSpacing}) {
    return TextStyle(
        color: color ?? AppCoreTheme().appColorLight,
        fontSize: size!.w,
        decoration: showUnderLine != null && showUnderLine
            ? TextDecoration.underline
            : TextDecoration.none,
        fontFamily: 'Urbanist',
        fontWeight: weight ?? FontWeight.normal,
        letterSpacing: letterSpacing ?? -0.03);
  }

  ///This Method to call to show the SnackBar message
  void showSnackBar(BuildContext context, String message) {

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    SnackBar snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(milliseconds: 800),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  ///Gradient rounded button
  Widget customButton(
      {String? text,
      Function? callBack,
      bool? showIcon,
      String? icon,
      Color? iconColor,
      buttonColor}) {
    return GestureDetector(
      onTap: () {
        CommonWidgets().addVibration();

        if(callBack!=null){
          callBack();
        }

      },
      child: Container(
          height: 52.h,
          decoration: BoxDecoration(
            color: buttonColor ?? AppTheme.cT!.appColorLight,
            borderRadius: BorderRadius.circular(30.w),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              text != null
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: makeDynamicText(
                          size: 18,
                          text: text,
                          weight: FontWeight.w800,
                          color: AppTheme.cT!.whiteColor),
                    )
                  : const SizedBox(),
              showIcon != null
                  ? SvgPicture.asset(
                      icon ?? "assets/common/forward_arrow.svg",
                      colorFilter: ColorFilter.mode(
                        iconColor ?? Colors.transparent,
                        BlendMode.srcIn,
                      ),
                    )
                  : const SizedBox(),
            ],
          )),
    );
  }

  ///make a border
  Widget makeBorder() {
    return Container(
      height: 1.h,
      width: double.infinity,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(40.w)),
    );
  }

  ///Custom Radio Button
  Widget customRadioButton(bool isSelected,{color}) {
    return Container(
      height: 18.h,
      width: 18.w,
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected
              ? color?? AppTheme.cT!.whiteColor!
              : AppTheme.cT!.appColorDark!,
          width: 2.0.w,
        ),
      ),
      child: Container(
        height: 16.h,
        width: 16.w,
        decoration: BoxDecoration(
          color: color??AppTheme.cT!.whiteColor,
          shape: BoxShape.circle,
        ),
      ),
    );
  }


  ///
  Widget makeDot({color, double? size, margin}) {
    return Container(
      width: size ?? 5.w,
      height: size ?? 5.h,
      margin: EdgeInsets.only(right: margin ?? 5.w),
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  ///Green BoxShadow
  List<BoxShadow> boxShadow() {
    return [
      BoxShadow(
        color: AppTheme.cT!.brownShadow!,
        blurRadius: 0,
        offset: const Offset(0, 0),
        spreadRadius: 4.w,
      )
    ];
  }

  ///Rounded Shape of circle bottom
  Widget roundShapeCircle() {
    return Container(
      width: 960.w,
      height: 960.h,
      decoration: BoxDecoration(
        color: AppTheme.cT!.whiteColor,
        shape: BoxShape.circle,
      ),
    );
  }

  ///Doted Line
  Widget dotedLine() {
    return DottedLine(
      direction: Axis.horizontal,
      alignment: WrapAlignment.center,
      lineLength: double.infinity,
      lineThickness: 1.0.w,
      dashLength: 4.0,
      dashColor: AppTheme.cT!.lightGrey!,
      dashRadius: 0.0,
      dashGapLength: 4.0,
      dashGapColor: Colors.transparent,
      dashGapRadius: 0.0,
    );
  }

  /// Get the Random Color
  Color returnRandomColor() {
    return Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
        .withOpacity(0.1);
  }

  ///Insight button to view full health
  Widget ovalButton({BuildContext? context, IconData? iconData, callBack}) {
    return GestureDetector(
      onTap: () {
        CommonWidgets().vibrate();
        if (callBack != null) {
          callBack();
        }
      },
      child: Container(
        width: 80.w,
        height: 80.h,
        decoration: BoxDecoration(
          color: AppTheme.cT!.appColorLight,
          shape: BoxShape.circle,
        ),
        child: Icon(iconData, color: AppTheme.cT!.whiteColor),
      ),
    );
  }

  ///Above the ListViewBuilder Text
  Widget listViewAboveRow({context, text1, text2, callBack}) {
    return GestureDetector(

      onTap: () {
        CommonWidgets().vibrate();
        if (callBack != null) {
          callBack();
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        width: MediaQuery.sizeOf(context).width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CommonWidgets().makeDynamicText(
                text: text1,
                size: 16,
                weight: FontWeight.w800,
                color: AppTheme.cT!.appColorDark),
            CommonWidgets().makeDynamicText(
                text: text2,
                size: 16,
                weight: FontWeight.w800,
                color: AppTheme.cT!.greenColor),
          ],
        ),
      ),
    );
  }

  ///List of Shadows
  List<BoxShadow> listOfBoxShadow() {
    return [
      const BoxShadow(
        color: Color(0x0CFE814B),
        blurRadius: 0,
        offset: Offset(0, 0),
        spreadRadius: 0,
      ),
      BoxShadow(
        color: const Color(0x0CFE814B),
        blurRadius: 15.w,
        offset: const Offset(0, 7),
        spreadRadius: 0,
      ),
      BoxShadow(
        color: const Color(0x0AFE814B),
        blurRadius: 28.w,
        offset: const Offset(0, 28),
        spreadRadius: 0,
      ),
      BoxShadow(
        color: const Color(0x07FE814B),
        blurRadius: 37.w,
        offset: const Offset(0, 62),
        spreadRadius: 0,
      ),
      BoxShadow(
        color: const Color(0x02FE814B),
        blurRadius: 44.w,
        offset: const Offset(0, 110),
        spreadRadius: 0,
      ),
      BoxShadow(
        color: const Color(0x00FE814B),
        blurRadius: 48.w,
        offset: const Offset(0, 172),
        spreadRadius: 0,
      )
    ];
  }

  ///Split Date Format
  Map<String, dynamic> splitDateFormat(String date) {
    RegExp regex = RegExp(r'([a-zA-Z]+) (\d{1,2})');
    Match? match = regex.firstMatch(date);

    if (match != null) {
      String month = match.group(1)!; // Month name
      String day = match.group(2)!; // Day

      return {"month": month, "day": day};
    } else {
      return {};
    }
  }






  ///hide Keyboard value
  void hideSoftInputKeyboard(BuildContext context) {
    final FocusScopeNode currentScope = FocusScope.of(context);
    if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
      FocusManager.instance.primaryFocus!.unfocus();
    }
  }






  ///Date Range Days
  String getTheDateRangeDays(Map<String,String> dateRange){
    final startingDate =
        DateFormat('d MMMM y').parse(dateRange["startingDate"]!);
    final endingDate = DateFormat('d MMMM y').parse(dateRange["endingDate"]!);

    /// Calculate the difference in days
    final differenceInDays = endingDate.difference(startingDate).inDays;

    /// Add 1 to include both the starting and ending dates in the count
    return (differenceInDays + 1).toString();
  }



  ///Open Privacy and other URLs
  void launchUrls(String openUrl) async {
    final url = Uri.parse(openUrl);

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ///
    }
  }


  ///Share the Video to other platforms using this method
  Future<void> shareAppUrl() async {
    await Share.share(Constants.playStoreUrl);
  }



  ///
  void vibrate(){
    //Vibration.vibrate(duration: 1000);
  }


  ///
  Future<void> addVibration() async {
    final obj = await Vibration.hasAmplitudeControl();
    if (obj == false) {
      Vibration.vibrate(duration: 20, amplitude: 4);
    } else {
      Vibration.vibrate(duration: 500, intensities: [500, 1000], amplitude: 30);
    }
  }
}
