import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/extensions.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';

class LoadingScreenProgress extends StatelessWidget {
  const LoadingScreenProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          color: AppTheme.cT!.appColorDark,
          child: SvgPicture.asset("assets/splash/loading_screen_progress.svg"),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CommonWidgets().makeDynamicText(
                text: "99", size: 28, color: AppTheme.cT!.whiteColor),
            CommonWidgets().makeDynamicText(
                text: "%",
                size: 28,
                color: AppTheme.cT!.appColorLight!.withOpacity(0.9)),
          ],
        ).centralized()
      ],
    );
  }
}
