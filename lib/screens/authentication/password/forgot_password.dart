import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/screens/authentication/password/otp_verification_dialog.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 52),
            forgotPasswordHeader(),
            forgotPasswordView("forgot_password.svg", "Use 2FA"),
            forgotPasswordView("forgot_password.svg", "Password"),
            forgotPasswordView(
                "google_authenticator.svg", "Google Authenticator"),
            _buildForgotButton()
          ],
        ),
      ),
    );
  }

  ///Login Button
  Widget _buildForgotButton() {
    return CommonWidgets().customButton(
        text: "Send password",
        icon: "assets/signin/white_lock.svg",
        showIcon: true,
        callBack: () => showOTPVerificationDialog());
  }

  showOTPVerificationDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return const ShowOTPAlertDialog();
      },
    );
  }

  ///forgotPassword header
  forgotPasswordHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonWidgets().backButton(),
        30.height,
        CommonWidgets().makeDynamicText(
            text: "Forgot Password",
            size: 16,
            weight: FontWeight.bold,
            color: AppTheme.cT!.appColorDark),
        30.height,
        CommonWidgets().makeDynamicText(
            text:
                "Select contact details where you want to reset your passwrod",
            size: 14,
            color: AppTheme.cT!.appColorDark),
      ],
    );
  }

  ///Forgot password Views
  Widget forgotPasswordView(String iconName, String text) {
    return Container(
      height: 110,
      alignment: Alignment.center,
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.symmetric(vertical: 20.h),
      padding: EdgeInsets.all(10.w),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1.w, color: const Color(0xFF9BB067)),
          borderRadius: BorderRadius.circular(30.w),
        ),
        shadows: [
          BoxShadow(
            color: const Color(0x3F9BB068),
            blurRadius: 0,
            offset: const Offset(0, 0),
            spreadRadius: 4.w,
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 96,
            height: 96,
            child: SvgPicture.asset("assets/signin/$iconName"),
          ),
          CommonWidgets().makeDynamicText(
              text: text,
              size: 18,
              weight: FontWeight.bold,
              align: TextAlign.center,
              color: AppTheme.cT!.appColorDark),
        ],
      ),
    );
  }
}
