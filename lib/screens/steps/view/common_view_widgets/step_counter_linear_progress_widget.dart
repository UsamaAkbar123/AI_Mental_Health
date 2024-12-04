import 'package:flutter/material.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';

class StepCounterLinearProgressWidget extends StatelessWidget {
  final double stepPercentageValue;

  const StepCounterLinearProgressWidget({
    super.key,
    required this.stepPercentageValue,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// steps progress
            StepsCounterProgressView(
              value: stepPercentageValue,
              color: AppTheme.cT!.blueColor ?? Colors.transparent,
            ),

            /// calories progress
            StepsCounterProgressView(
              value: stepPercentageValue,
              color: AppTheme.cT!.orangeColor ?? Colors.transparent,
            ),

            /// distance progress
            StepsCounterProgressView(
              value: stepPercentageValue,
              color: AppTheme.cT!.purpleColor ?? Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}

class StepsCounterProgressView extends StatelessWidget {
  final double value;
  final Color color;

  const StepsCounterProgressView({
    super.key,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(right: 2.w),
        child: LinearProgressIndicator(
          value: value, // Set the progress value (0.0 to 1.0)
          backgroundColor: Colors.grey[300], // Set the inactive color
          borderRadius: BorderRadius.circular(10.w),
          valueColor:
              AlwaysStoppedAnimation<Color>(color), // Set the active color
        ),
      ),
    );
  }
}
