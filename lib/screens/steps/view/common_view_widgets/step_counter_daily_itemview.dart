import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/extensions.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/routes/routes.dart';
import 'package:freud_ai/screens/steps/bloc/steps_bloc.dart';
import 'package:freud_ai/screens/steps/model/step_counter_goal_model.dart';
import 'package:freud_ai/screens/steps/statistics/views/total_steps_graph.dart';

class StepsDailyItemView extends StatefulWidget {
  final bool? isFromMain;
  final StepCounterGoalModel? counterModel;

  /// isFirstStepGoalEntryIndex variable is used for today step calculation value,
  /// because today current step values are calculating from pedometer value
  final bool ? isFirstStepGoalEntryIndex;
  final String ? dayName;

  const StepsDailyItemView({
    super.key,
    this.isFromMain,
    this.counterModel,
    this.isFirstStepGoalEntryIndex,
    this.dayName,
  });

  @override
  State<StepsDailyItemView> createState() => _StepsDailyItemViewState();
}

class _StepsDailyItemViewState extends State<StepsDailyItemView> {
  double percentage = 0;
  double stepPercentageValue = 0;
  double distancePercentageValue = 0;
  double caloriesPercentageValue = 0;
  int currentSteps = 0;
  double currentDistance = 0;
  double currentCalories = 0;
  late StepsBloc stepsBloc;

  final double stepLength = 0.8; // average step length in meters
  final double caloricBurnRate =
      0.04; // average caloric burn rate per step in kcal
  final double caloriesPerKm = 50.0; // average calories burned per km

  @override
  void initState() {
    stepsBloc = BlocProvider.of<StepsBloc>(context, listen: false);
    calculateStepPercentageAndPercentageValue();
    calculateCaloriesAndDistancePercentage();
    super.initState();
  }

  void calculateCaloriesAndDistancePercentage() {
    int steps = currentSteps;
    double goalDistance = widget.counterModel?.goalDistance ?? 0.0;
    double goalCalories = widget.counterModel?.goalCalories ?? 0.0;

    if (steps > 0) {
      currentDistance = (steps * stepLength) / 1000;
      currentCalories = currentDistance * caloriesPerKm;
      distancePercentageValue = currentDistance / goalDistance;
      caloriesPercentageValue = currentCalories / goalCalories;
    } else {
      distancePercentageValue = 0.0;
      distancePercentageValue = 0.0;
    }
  }

  void calculateStepPercentageAndPercentageValue() {
    int goalSteps = widget.counterModel?.goalStep ?? 0;
    int pedometerSteps = widget.isFirstStepGoalEntryIndex == true ? stepsBloc.pedometerStep : widget.counterModel?.dayEndStepValue ?? 0;
    int dayStartStepValue = widget.counterModel?.dayStartStepValue ?? 0;
    currentSteps = pedometerSteps - dayStartStepValue;
    percentage = (currentSteps / goalSteps) * 100;
    stepPercentageValue = currentSteps / goalSteps;

    if (percentage > 100) {
      percentage = 100;
    }

    if (stepPercentageValue > 1.0) {
      stepPercentageValue = stepPercentageValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        CommonWidgets().vibrate();
        Navigate.pushNamed(TotalStepsGraph(
          currentStep: currentSteps,
          currentCalories: currentCalories,
          currentDistance: currentDistance,
          stepPercentageValue: stepPercentageValue,
          caloriesPercentageValue: caloriesPercentageValue,
          distancePercentageValue: distancePercentageValue,
        ));
      },
      child: Column(
        children: [
         widget.dayName != null ? Align(
            alignment: Alignment.centerLeft,
            child: CommonWidgets().makeDynamicText(
              text: widget.dayName ?? "",
              size: 17,
              weight: FontWeight.w700,
              // color: AppTheme.cT!.appColorLight,
              color: const Color(0xff736B66),
            ),
          ): const SizedBox(),
          12.height,
          Container(
              margin: EdgeInsets.symmetric(vertical: 5.h),
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: widget.isFromMain!
                    ? AppTheme.cT!.scaffoldLight
                    : AppTheme.cT!.whiteColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22.w),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: !widget.isFromMain!
                            ? AppTheme.cT!.scaffoldLight
                            : AppTheme.cT!.whiteColor,
                        borderRadius: BorderRadius.circular(12.w)),
                    child: CommonWidgets().makeDynamicTextSpan(
                        text1:
                            '${CommonWidgets().splitDateFormat(widget.counterModel!.timeStamp!)["month"]}\n',
                        text2:
                            '${CommonWidgets().splitDateFormat(widget.counterModel!.timeStamp!)["day"]}',
                        size1: 18,
                        size2: 16,
                        weight2: FontWeight.w600,
                        weight1: FontWeight.w800,
                        align: TextAlign.center,
                        color1: AppTheme.cT!.brownColor50,
                        color2: AppTheme.cT!.appColorLight),
                  ),
                  12.width,
                  Expanded(
                    child: SizedBox(
                      height: 40.h,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonWidgets().makeDynamicText(
                            text: "${currentSteps.toString()} steps",
                            size: 16,
                            weight: FontWeight.w700,
                            // color: AppTheme.cT!.appColorLight,
                            color: const Color(0xff736B66),
                          ),
                          5.height,
                          stepsCounterLinearProgress(),
                        ],
                      ),
                    ),
                  ),
                  10.width,
                  stepsCounterProgress()
                ],
              )),
        ],
      ),
    );
  }

  ///Sleep Progress
  Widget stepsCounterProgress() {
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
                  text1: "${percentage.toInt()}%",
                  size1: 14,
                  align: TextAlign.center,
                  weight1: FontWeight.w800,
                  color1: AppTheme.cT!.appColorDark)
              .centralized()
        ],
      ),
    );
  }

  ///
  Widget stepsCounterLinearProgress() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// steps progress
            stepsCounterProgressView(
              color: AppTheme.cT!.blueColor,
              // value: counterModel!.stepsPercentage,
              value: stepPercentageValue.toString(),
            ),

            /// calories progress
            stepsCounterProgressView(
              color: AppTheme.cT!.orangeColor,
              value: caloriesPercentageValue.toString(),
            ),

            /// distance progress
            stepsCounterProgressView(
              color: AppTheme.cT!.purpleColor,
              value: distancePercentageValue.toString(),
            ),
          ],
        ),
      ),
    );
  }

  ///
  Widget stepsCounterProgressView({color, value}) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(right: 2.w),
        child: LinearProgressIndicator(
          value: double.parse(value), // Set the progress value (0.0 to 1.0)
          backgroundColor: Colors.grey[300], // Set the inactive color
          borderRadius: BorderRadius.circular(10.w),
          valueColor:
              AlwaysStoppedAnimation<Color>(color), // Set the active color
        ),
      ),
    );
  }
}
