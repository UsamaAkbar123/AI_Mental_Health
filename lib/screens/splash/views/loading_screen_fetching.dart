import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/extensions.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';

class LoadingScreenInteractive extends StatelessWidget {
  const LoadingScreenInteractive({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          color: AppTheme.cT!.greenColor,
          child: SvgPicture.asset("assets/splash/fetching_screen_img.svg",
              fit: BoxFit.cover),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 10),
              child: CommonWidgets().makeDynamicText(
                  text: "Fetching Data...",
                  size: 32,
                  color: AppTheme.cT!.whiteColor,
                  weight: FontWeight.bold),
            ),
            10.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset("assets/splash/shake_screen.svg",
                    fit: BoxFit.cover),
                const SizedBox(width: 5),
                CommonWidgets().makeDynamicText(
                    text: "Shake screen to interact!",
                    size: 16,
                    color: AppTheme.cT!.whiteColor),
              ],
            ),
          ],
        ).centralized()
      ],
    );
  }
}
