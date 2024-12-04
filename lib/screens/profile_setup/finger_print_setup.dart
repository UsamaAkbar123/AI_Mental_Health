import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/routes/routes.dart';
import 'package:freud_ai/screens/profile_setup/notification_setup.dart';

class FingerPrintSetup extends StatefulWidget {
  const FingerPrintSetup({super.key});

  @override
  FingerPrintSetupState createState() => FingerPrintSetupState();
}

class FingerPrintSetupState extends State<FingerPrintSetup> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          children: [
            appBarWidget(),
            50.height,
            SvgPicture.asset("assets/profile/finger_print.svg"),
            30.height,
            CommonWidgets().makeDynamicText(
                text: "Fingerprint Setup",
                size: 28,
                weight: FontWeight.w600,
                color: AppTheme.cT!.appColorLight),
            10.height,
            CommonWidgets().makeDynamicText(
                text:
                    "Scan your biometric fingerprint to make your account more secure. 🔑",
                size: 16,
                align: TextAlign.center,
                weight: FontWeight.w400,
                color: AppTheme.cT!.greyColor),
            50.height,
            CommonWidgets().customButton(
                text: "continue",
                showIcon: true,
                callBack: () => Navigate.pushNamed(const NotificationSetup())),
          ],
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
              text: "Finger Print Setup",
              size: 28,
              weight: FontWeight.w600,
              color: AppTheme.cT!.appColorLight)
        ],
      ),
    );
  }
}
