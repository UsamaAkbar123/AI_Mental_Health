import 'package:flutter/material.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/screens/steps/view/common_view_widgets/step_counter_linear_progress_widget.dart';
import 'package:freud_ai/screens/steps/view/common_view_widgets/step_counter_progress.dart';

class StepCounterYearlyOrMonthItemView extends StatelessWidget {
  final String monthOrWeekRangeName;
  final double totalMonthOrWeekRangeSteps;
  final double stepProgress;
  final double stepPercentageValue;

  const StepCounterYearlyOrMonthItemView({
    super.key,
    required this.monthOrWeekRangeName,
    required this.totalMonthOrWeekRangeSteps,
    required this.stepProgress,
    required this.stepPercentageValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: CommonWidgets().makeDynamicText(
              text: monthOrWeekRangeName,
              size: 17,
              weight: FontWeight.w700,
              // color: AppTheme.cT!.appColorLight,
            color: const Color(0xff736B66),
          ),
        ),
        10.height,
        Container(
          // margin: EdgeInsets.symmetric(vertical: 5.h),
            height: 68.h,
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: AppTheme.cT!.whiteColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22.w),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40.h,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonWidgets().makeDynamicText(
                          text:
                              "${totalMonthOrWeekRangeSteps.toInt().toString()} steps",
                          size: 16,
                          weight: FontWeight.w600,
                          // color: AppTheme.cT!.appColorLight,
                          color: const Color(0xff736B66),
                        ),
                        5.height,
                        StepCounterLinearProgressWidget(
                          stepPercentageValue: stepPercentageValue,
                        ),
                      ],
                    ),
                  ),
                ),
                10.width,
                StepCounterProgress(
                  stepPercentageValue: stepPercentageValue,
                  stepProgress: stepProgress,
                ),
              ],
            )),
      ],
    );
  }
}