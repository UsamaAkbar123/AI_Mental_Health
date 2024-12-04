import 'package:flutter/material.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/routes/routes.dart';
import 'package:freud_ai/screens/profile_setup/finger_print_setup.dart';
import 'package:freud_ai/screens/profile_setup/view/otp_view.dart';

class VerifyOTP extends StatefulWidget {
  const VerifyOTP({super.key});

  @override
  VerifyOTPState createState() => VerifyOTPState();
}

class VerifyOTPState extends State<VerifyOTP> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              appBarWidget(),
              50.height,
              CommonWidgets().makeDynamicText(
                  text: "Enter 4 digit OTP Code",
                  size: 28,
                  weight: FontWeight.w600,
                  color: AppTheme.cT!.appColorLight),
              10.height,
              CommonWidgets().makeDynamicText(
                  text:
                      "Scan your biometric fingerprint to make your account more secure.",
                  size: 16,
                  align: TextAlign.center,
                  weight: FontWeight.w400,
                  color: AppTheme.cT!.greyColor),
              50.height,
              const OTPView(),
              50.height,
              CommonWidgets().customButton(
                  text: "continue",
                  showIcon: true,
                  callBack: () => Navigate.pushNamed(const FingerPrintSetup())),
              50.height,
              CommonWidgets().makeDynamicTextSpan(
                  text1: "Didn't receive the otp? ",
                  text2: "Resend it",
                  size1: 12,
                  showUnderLine2: true,
                  align: TextAlign.center,
                  color2: AppTheme.cT!.orangeColor,
                  color1: AppTheme.cT!.greyColor)
            ],
          ),
        ),
      ),
    );
  }

  ///AppBar
  Widget appBarWidget() {
    return Container(
      margin: EdgeInsets.only(top: 50.h),
      child: Row(
        children: [
          CommonWidgets().backButton(borderColor: AppTheme.cT!.appColorLight),
          10.width,
          CommonWidgets().makeDynamicText(
              text: "OTP Setup",
              size: 28,
              weight: FontWeight.w600,
              color: AppTheme.cT!.appColorLight)
        ],
      ),
    );
  }
}
