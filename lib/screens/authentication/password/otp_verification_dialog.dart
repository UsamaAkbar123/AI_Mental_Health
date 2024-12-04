import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/extensions.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';

class ShowOTPAlertDialog extends StatefulWidget {
  const ShowOTPAlertDialog({super.key});

  @override
  State<ShowOTPAlertDialog> createState() => _ShowOTPAlertDialogState();
}

class _ShowOTPAlertDialogState extends State<ShowOTPAlertDialog> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(15.w),
            decoration: ShapeDecoration(
              color: AppTheme.cT!.whiteColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.w),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset("assets/signin/otp_verification.svg"),
                30.height,
                CommonWidgets().makeDynamicText(
                    text: "We’ve Sent Verification Code to ****-****-***24",
                    size: 18,
                    weight: FontWeight.bold,
                    color: AppTheme.cT!.appColorDark),
                30.height,
                CommonWidgets().makeDynamicText(
                    text:
                        "Didn’t receive the link? Then re-send the password below! 🔑",
                    size: 14,
                    color: AppTheme.cT!.appColorDark),
                30.height,
                _buildForgotButton()
              ],
            ),
          ),
          20.height,
          SvgPicture.asset("assets/signin/dialog_cross.svg").goBack(),
        ],
      ),
    );
  }

  ///Login Button
  Widget _buildForgotButton() {
    return CommonWidgets().customButton(
        text: "Re-Send Password",
        icon: "assets/signin/white_lock.svg",
        showIcon: true,
        callBack: () => null);
  }
}
