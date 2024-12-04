import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/extensions.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';

class MentalHealthGraph extends StatelessWidget {
  final double progress;

  const MentalHealthGraph({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DashedCircularProgressBar.square(
          dimensions: 350,
          progress: progress,
          maxProgress: 100,
          sweepAngle: 360,
          foregroundColor: AppTheme.cT!.lightGreenColor!,
          backgroundColor: AppTheme.cT!.greenColor50!,
          foregroundStrokeWidth: 7,
          backgroundStrokeWidth: 7,
          foregroundGapSize: 12,
          backgroundGapSize: 12,
          backgroundDashSize: 60,
          foregroundDashSize: 60,
          animation: false,
        ),
        CommonWidgets()
            .makeDynamicTextSpan(
            text1: '$progress%\n',
            text2: 'Healthy',
            size1: 12,
            weight1: FontWeight.w800,
            weight2: FontWeight.normal,
            align: TextAlign.center,
            color1: AppTheme.cT!.whiteColor,
            color2: AppTheme.cT!.lightGreenColor)
            .centralized()
      ],
    );
  }
}
