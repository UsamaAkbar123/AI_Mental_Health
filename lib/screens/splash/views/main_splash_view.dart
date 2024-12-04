import 'package:flutter/material.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/extensions.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:lottie/lottie.dart';

class MainSplashScreen extends StatelessWidget {
  const MainSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {

    App.init(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset("assets/common/splash1.json", width: 120.w, height: 120)
            .centralized(),
        CommonWidgets().makeDynamicText(
            text: "Mental Health",
            color: AppTheme.cT!.appColorLight,
            weight: FontWeight.w800,
            size: 42)
      ],
    );
  }
}

