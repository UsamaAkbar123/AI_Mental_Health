import 'package:flutter/material.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/screens/Widgets/cliper.dart';
import 'package:lottie/lottie.dart';

class NotificationsDetailPage extends StatefulWidget {
  const NotificationsDetailPage({super.key});

  @override
  State<NotificationsDetailPage> createState() =>
      _NotificationsDetailPageState();
}

class _NotificationsDetailPageState extends State<NotificationsDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppTheme.cT!.whiteColor,
      body: SizedBox(
        height: MediaQuery.sizeOf(context).height,
        child: Stack(
          children: [
            ClipPath(
              clipper: ClipperClass(),
              child: Container(
                height: MediaQuery.sizeOf(context).height / 1.8.h,
                width: MediaQuery.sizeOf(context).width,
                color: AppTheme.cT!.brownColor,
                child: Lottie.asset("assets/ai/out_of_token.json",
                    fit: BoxFit.fill),
              ),
            ),
            bottomContainer(),
            Padding(
              padding: EdgeInsets.only(top: 50.h, left: 20.w),
              child: CommonWidgets().backButton(),
            )
          ],
        ),
      ),
    );
  }

  /// Bottom Navigation Container
  Widget bottomContainer() {
    return Positioned(
      right: 0,
      left: 0,
      top: MediaQuery.sizeOf(context).height / 1.8.h,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CommonWidgets().makeDynamicTextSpan(
              text1: "22.1",
              text2: "!",
              color2: AppTheme.cT!.brownColor,
              size1: 52,
              color1: AppTheme.cT!.appColorLight,
              weight1: FontWeight.w800),
          20.height,
          CommonWidgets().makeDynamicText(
              text: "BMI Score Since january",
              size: 26,
              align: TextAlign.center,
              weight: FontWeight.bold,
              color: AppTheme.cT!.appColorLight),
          10.height,
          CommonWidgets().makeDynamicText(
              text:
                  "Congrats! You have kept your BMI\nscore normal for five months.",
              size: 16,
              align: TextAlign.center,
              color: AppTheme.cT!.greyColor),
          20.height,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: CommonWidgets().customButton(
                text: "Let's meditate",
                showIcon: true,
                iconColor: AppTheme.cT!.whiteColor,
                buttonColor: AppTheme.cT!.appColorLight,
                callBack: () => null),
          )
        ],
      ),
    );
  }
}
