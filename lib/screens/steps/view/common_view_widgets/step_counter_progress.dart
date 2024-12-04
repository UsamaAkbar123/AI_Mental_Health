import 'package:flutter/material.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/extensions.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';

class StepCounterProgress extends StatelessWidget {
  final double stepPercentageValue;
  final double stepProgress;

  const StepCounterProgress({
    super.key,
    required this.stepPercentageValue,
    required this.stepProgress,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      width: 40.h,
      child: Stack(
        children: [
          SizedBox(
            height: 40.h,
            width: 40.h,
            child: CircularProgressIndicator(
              value: stepPercentageValue,
              backgroundColor: AppTheme.cT!.greyColor?.withOpacity(0.4),
              valueColor:
              AlwaysStoppedAnimation<Color>(AppTheme.cT!.blueColor!),
              strokeWidth: 6.w,
              strokeCap: StrokeCap.round,
            ),
          ),
          CommonWidgets()
              .makeDynamicTextSpan(
              text1: "${stepProgress.toInt()}%",
              size1: 14,
              align: TextAlign.center,
              weight1: FontWeight.w800,
              color1: AppTheme.cT!.appColorDark)
              .centralized()
        ],
      ),
    );
  }
}
