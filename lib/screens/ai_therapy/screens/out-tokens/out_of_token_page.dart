import 'package:flutter/material.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/screens/Widgets/cliper.dart';
import 'package:lottie/lottie.dart';

class OutOfTokenPage extends StatefulWidget {
  const OutOfTokenPage({super.key});

  @override
  State<OutOfTokenPage> createState() => _OutOfTokenPageState();
}

class _OutOfTokenPageState extends State<OutOfTokenPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        height: MediaQuery.sizeOf(context).height,
        child: Stack(
          children: [
            ClipPath(
              clipper: ClipperClass(),
              child: Container(
                height: MediaQuery.sizeOf(context).height / 1.5.h,
                width: MediaQuery.sizeOf(context).width,
                color: AppTheme.cT!.brownColor,
                child: Lottie.asset("assets/ai/out_of_token.json",
                    fit: BoxFit.fill),
              ),
            ),
            bottomContainer(),
            Padding(
              padding: const EdgeInsets.only(top: 50, left: 20),
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
      bottom: 60,
      right: 0,
      left: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          20.height,
          CommonWidgets().makeDynamicText(
              text: "Oops, Out of Token!",
              size: 32,
              align: TextAlign.center,
              weight: FontWeight.bold,
              color: AppTheme.cT!.appColorLight),
          10.height,
          CommonWidgets().makeDynamicText(
              text: "Upgrade to Premium Version for unlimited AI Therapy.",
              size: 14,
              align: TextAlign.center,
              color: AppTheme.cT!.greyColor),
          20.height,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: CommonWidgets().customButton(
                text: "Go Pro Now!",
                icon: "assets/home/pro.svg",
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
