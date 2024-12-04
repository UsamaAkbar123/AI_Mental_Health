import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/configs/constants/constants.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/routes/routes.dart';
import 'package:freud_ai/screens/bmi/bmi_page.dart';
import 'package:freud_ai/screens/comming/comming_soon.dart';
import 'package:freud_ai/screens/home/view/today_health_metrics/model/health_metrics_model.dart';
import 'package:freud_ai/screens/home/view/today_health_metrics/view/mental_health_graph.dart';
import 'package:freud_ai/screens/mood/mood_tracker_page.dart';
import 'package:freud_ai/screens/sleep/sleep_page.dart';
import 'package:freud_ai/screens/steps/bloc/steps_bloc.dart';
import 'package:freud_ai/screens/steps/bloc/steps_event.dart';
import 'package:freud_ai/screens/steps/step_counter_page.dart';
import 'package:freud_ai/screens/steps/view/add_steps_schedule.dart';

class MentalHealthMetricsItemView extends StatelessWidget {
  final HealthMetricsModel? healthMetricsModel;

  const MentalHealthMetricsItemView({super.key, this.healthMetricsModel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => navigateToNextPage(context),
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(right: 12.w),
        width: MediaQuery.sizeOf(context).width / 2.7.w,
        height: MediaQuery.sizeOf(context).height / 3.5.h,
        padding: EdgeInsets.all(12.w),
        decoration: ShapeDecoration(
          color: healthMetricsModel!.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32.w),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
                children: [
                SvgPicture.asset("${healthMetricsModel!.emoji}",
                  color: healthMetricsModel?.name == "Mood" ? null : AppTheme.cT!.whiteColor,
                  height: 24.h,
                  width: 24.w,
                ),
                5.width,
                CommonWidgets().makeDynamicText(
                    text: healthMetricsModel!.name,
                    size: 16,
                    weight: FontWeight.w800,
                    color: AppTheme.cT!.whiteColor),
              ],
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: CommonWidgets().makeDynamicText(
                    text: healthMetricsModel!.subText,
                    size: 28,
                    align: TextAlign.start,
                    weight: FontWeight.w800,
                  color: AppTheme.cT!.whiteColor),
            ),
            SizedBox(
              width: 80.w,
              height: 80.h,
              child: healthMetricsModel!.subText!.isNotEmpty
                  ? SvgPicture.asset("assets/${healthMetricsModel!.graph}")
                  : const MentalHealthGraph(progress: 0),
            ),
          ],
        ),
      ),
    );
  }

  ///
  navigateToNextPage(BuildContext context) async {
    if (healthMetricsModel!.name == 'Mental Health') {
      //Navigate.pushNamed(const MentalHealthPage());
      Navigate.pushNamed(const ComingSoonScreen(title: "Mental Health"));
    } else if (healthMetricsModel!.name == 'Sleep Hours') {
      Navigate.pushNamed(const SleepPage());
      //Navigate.pushNamed(const ComingSoonScreen(title: "Sleep Hours"));
    } else if (healthMetricsModel!.name == 'Mood') {
      Navigate.pushNamed(const MoodTrackerPage());
      //Navigate.pushNamed(const ComingSoonScreen(title: "Mood Tracker"));
    } else if (healthMetricsModel!.name == 'Step Counter') {
      if (Constants.completeAppInfoModel!.isStepCounterGoalSet!) {
        await Navigate.pushNamed(const StepCounterPage()).then((value) {
          /// for real time step update on home screen card

          if (Constants.completeAppInfoModel!.isStepCounterGoalSet!) {
            BlocProvider.of<StepsBloc>(context, listen: false)
                .add(GetStepCounterGoalHistoryEvent());
          }
        });
      } else {
        Navigate.pushNamed(const AddStepsGoals());
      }

      ///
    } else if (healthMetricsModel!.name == 'BMI Score') {
      Navigate.pushNamed(const BMIPage());
    } else if (healthMetricsModel!.name == "Today’s Routine") {
      // Navigate.pushNamed(const RoutinePlannerPage());
    }
  }
}
