import 'package:flutter/material.dart';
import 'package:freud_ai/configs/constants/assets.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/extensions.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:lottie/lottie.dart';

class EmptyChatBot extends StatelessWidget {

  const EmptyChatBot({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(AssetsItems.emptyChatJson).centralized(),
        CommonWidgets().makeDynamicText(
          text: "Limited Knowledge",
          size: 30,
          color: AppTheme.cT!.appColorLight,
          weight: FontWeight.w800,
        ),
        const SizedBox(height: 10),
        CommonWidgets().makeDynamicText(
          text: "man being is perfect. So is chatbots.",
          size: 16,
          weight: FontWeight.w500,
          color: AppTheme.cT!.greyColor,
        ),
      ],
    );
  }
}
