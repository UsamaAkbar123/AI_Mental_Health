import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/screens/Widgets/animated_row.dart';
import 'package:freud_ai/screens/bmi/bloc/bmi_bloc.dart';
import 'package:freud_ai/screens/bmi/bloc/bmi_state.dart';
import 'package:freud_ai/screens/home/view/today_health_metrics/model/health_metrics_model.dart';
import 'package:freud_ai/screens/home/view/today_health_metrics/view/mental_health_metrics_itemview.dart';
import 'package:freud_ai/screens/mood/bloc/mood_bloc.dart';
import 'package:freud_ai/screens/mood/bloc/mood_state.dart';
import 'package:freud_ai/screens/steps/bloc/steps_bloc.dart';
import 'package:freud_ai/screens/steps/bloc/steps_state.dart';

class TodayHealthMetricsView extends StatelessWidget {
  const TodayHealthMetricsView({super.key});


  @override
  Widget build(BuildContext context) {

    HealthMetricsModel stepsCounterModel = HealthMetricsModel(
        emoji: "assets/steps/steps.svg",
        subText: '0',
        name: 'Step Counter',
        backgroundColor: AppTheme.cT!.blueColor,
        graph: "steps/steps_graph.svg");


    HealthMetricsModel bmiScoreModel =  HealthMetricsModel(
        emoji: "assets/bmi/calender.svg",
        subText: '0',
        name: 'BMI Score',
        backgroundColor: AppTheme.cT!.orangeColor,
        graph: "bmi/bmi_graph.svg");


    HealthMetricsModel moodModel =  HealthMetricsModel(
        emoji: "assets/home/mood.svg",
        subText: 'Sad',
        name: 'Mood',
        backgroundColor: AppTheme.cT!.yellowColor,
        graph: "home/mood_graph.svg");

    // HealthMetricsModel sleepHoursModel  =HealthMetricsModel(
    //     emoji: "assets/home/sleep_hours.svg",
    //     subText: '0',
    //     name: 'Sleep Hours',
    //     backgroundColor: AppTheme.cT!.purpleColor,
    //     graph: "home/sleep_graph.svg");
    //
    //
    // HealthMetricsModel mentalHealthModel  = HealthMetricsModel(
    //     emoji: "assets/home/heart.svg",
    //     subText: '',
    //     name: 'Mental Health',
    //     backgroundColor: AppTheme.cT!.greenColor,
    //     graph: "home/mood_graph.svg");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: CommonWidgets().makeDynamicText(
              text: "Today's Health Metrics",
              size: 16,
              weight: FontWeight.w800,
              color: AppTheme.cT!.appColorDark),
        ),
        10.height,
        SizedBox(
          height: MediaQuery.sizeOf(context).height / 5.h,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,

            physics: const BouncingScrollPhysics(),

            child: AnimatedRowWrapper(children: [
              12.width,

              BlocBuilder<StepsBloc, StepsState>(builder: (context, state) {
                if (state is StepsCounterGoalLoadedState &&
                    state.status == AddStepsGoalsStatus.loaded) {
                  int pedometerStep = context.read<StepsBloc>().pedometerStep;
                  int dayStartPedometerStep =
                      state.stepCounterGoalModelLastEntry?.dayStartStepValue ?? 0;
                  stepsCounterModel.subText =
                      (pedometerStep - dayStartPedometerStep).toString();
                }

                // if (state is CurrentTodayStepsState &&
                //     state.status ==
                //         CurrentTodayStepValueCalculationStatus.loaded) {
                //   if (state.todayCurrentStepValue >= 0) {
                //     stepsCounterModel.subText =
                //         state.todayCurrentStepValue.toString();
                //   }
                // }else{
                //   stepsCounterModel.subText =
                //       "loading...";
                // }

                return MentalHealthMetricsItemView(
                  healthMetricsModel: stepsCounterModel,
                );
              }),

              BlocBuilder<BMIBloc, BMIState>(builder: (context, state) {
                if (state.status == BMIStateStatus.loaded) {
                  if(state.bmiModelList!.isNotEmpty){
                    bmiScoreModel.subText = state.bmiModelList!.last.bmiScore;
                  }

                }
                return MentalHealthMetricsItemView(
                  healthMetricsModel: bmiScoreModel,
                );
              }),
              BlocBuilder<MoodBloc, MoodState>(
                builder: (context, state) {
                  if (state.status == MoodStateStatus.loaded) {
                    if (state.moodModelList!.isNotEmpty) {
                      moodModel.emoji = state.moodModelList!.last.moodEmoji;
                      moodModel.subText =
                          getLastWord(state.moodModelList?.last.moodName ?? "");
                    }
                  }
                  return MentalHealthMetricsItemView(
                    healthMetricsModel: moodModel,
                  );
                },
              ),
              // MentalHealthMetricsItemView(healthMetricsModel: sleepHoursModel),
              // MentalHealthMetricsItemView(healthMetricsModel: mentalHealthModel),
            ]),
          ),
        )
      ],
    );
  }

  String getLastWord(String input) {
    List<String> words = input.split(' ');
    return words.isNotEmpty ? words.last : '';
  }
}
