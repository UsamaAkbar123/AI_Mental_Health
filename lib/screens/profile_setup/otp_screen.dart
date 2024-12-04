import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/routes/routes.dart';
import 'package:freud_ai/screens/Widgets/textfield/build_text_field.dart';
import 'package:freud_ai/screens/profile_setup/verify_otp.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.cT!.lightGreenColor,
      body: SizedBox(
        height: MediaQuery.sizeOf(context).height,
        child: Stack(
          children: [
            Positioned(
                top: 0, child: SvgPicture.asset("assets/profile/otp_bg.svg")),
            Positioned(
                top: 120.h,
                child: SvgPicture.asset("assets/profile/otp_image.svg")),
            otpView(),
            appBarWidget(),
          ],
        ),
      ),
    );
  }

  ///AppBar
  Widget appBarWidget() {
    return Container(
      margin: EdgeInsets.only(top: 50.h, left: 12.w, right: 12.w),
      child: Row(
        children: [
          CommonWidgets().backButton(borderColor: AppTheme.cT!.appColorLight),
          10.width,
          CommonWidgets().makeDynamicText(
              text: "Profile Setup",
              size: 28,
              weight: FontWeight.w600,
              color: AppTheme.cT!.appColorLight)
        ],
      ),
    );
  }



  ///OTP View
  Widget otpView() {
    return Positioned(
      bottom: 0,
      child: Stack(
        children: [
          SvgPicture.asset(
            "assets/common/round_bg.svg",
            alignment: Alignment.center,
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height / 2,
          ),
          SizedBox(
            width: MediaQuery.sizeOf(context).width,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  50.height,
                  CommonWidgets().makeDynamicText(
                      text: "OTP Verification",
                      size: 28,
                      align: TextAlign.center,
                      weight: FontWeight.w600,
                      color: AppTheme.cT!.appColorLight),
                  CommonWidgets().makeDynamicText(
                      text:
                          "We will send a one time SMS message. Carrier\nrates may apply.",
                      size: 14,
                      lines: 100,
                      align: TextAlign.center,
                      weight: FontWeight.w400,
                      color: AppTheme.cT!.greyColor),
                  30.height,
                  const CustomTextField(
                    headingName: '',
                    startIcon: "profile/account.svg",
                    endIcon: "common/arrow_down.svg",
                    hintName: "+92393939939",
                  ),
                  30.height,
                  CommonWidgets().customButton(
                      text: 'Send OTP',
                      showIcon: true,
                      callBack: () => Navigate.pushNamed(const VerifyOTP()))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
