import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/configs/constants/assets.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/extensions.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/screens/Widgets/textfield/build_text_field.dart';

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({super.key});

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: 12.w),
      backgroundColor: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(16.w),
            margin: EdgeInsets.only(top: 30.h),
            decoration: ShapeDecoration(
              color: AppTheme.cT!.whiteColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.w),
              ),
            ),
            child: Column(
              children: [
                SvgPicture.asset("assets/signin/otp_verification.svg",fit: BoxFit.cover),
                30.height,
                _buildEmailView(heading: "Old Password",hint: "Enter your password...",prefixIcon: AssetsItems.lock),
                30.height,
                _buildEmailView(heading: "New Password",hint: "Enter your password...",prefixIcon: AssetsItems.lock),
                30.height,
                CommonWidgets().customButton(
                    text: "Save Settings",
                    icon: AssetsItems.tick,
                    showIcon: true,
                    callBack: () => null)
              ],
            ),
          ),
          20.height,
          SvgPicture.asset("assets/signin/dialog_cross.svg").goBack(),
        ],
      ),
    );
  }



  ///Email Text field
  Widget _buildEmailView({heading, hint,prefixIcon,suffixIcon}) {
    return CustomTextField(
      hintName: hint,
      headingName: heading,
      startIcon: prefixIcon,
      endIcon: suffixIcon,
      fieldType: "text",
      backgroundColor: AppTheme.cT!.scaffoldLight,
    );
  }


}
