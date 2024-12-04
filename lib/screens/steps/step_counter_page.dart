import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/extensions.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/routes/routes.dart';
import 'package:freud_ai/screens/Widgets/cliper.dart';
import 'package:freud_ai/screens/steps/bloc/steps_bloc.dart';
import 'package:freud_ai/screens/steps/bloc/steps_state.dart';
import 'package:freud_ai/screens/steps/model/step_counter_goal_model.dart';
import 'package:freud_ai/screens/steps/statistics/steps_statistics_page.dart';
import 'package:freud_ai/screens/steps/view/add_steps_schedule.dart';
import 'package:freud_ai/screens/steps/view/common_view_widgets/step_counter_daily_itemview.dart';

class StepCounterPage extends StatelessWidget {
  const StepCounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.cT!.whiteColor,
      body: BlocBuilder<StepsBloc, StepsState>(
        builder: (context, state) {
          int pedometerStep = context.read<StepsBloc>().pedometerStep;

          if (state is StepsCounterGoalLoadedState &&
              state.status == AddStepsGoalsStatus.loaded) {
            int dayStartPedometerStep =
                state.stepCounterGoalModelLastEntry?.dayStartStepValue ?? 0;

            return StepCounterBody(
              stepsCounter: (pedometerStep - dayStartPedometerStep).toString(),
              listOfStepsHistory: state.listOfStepCounterGoalModel,
            );
          } else {
            return const StepCounterBody(
              stepsCounter: "0",
              listOfStepsHistory: [],
            );
          }
        },
      ),
    );
  }
}

class StepCounterBody extends StatelessWidget {
  final String stepsCounter;
  final List<StepCounterGoalModel>? listOfStepsHistory;

  const StepCounterBody({
    super.key,
    required this.stepsCounter,
    this.listOfStepsHistory,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  ClipPath(
                    clipper: ClipperClass(),
                    child: SizedBox(
                      height: MediaQuery.sizeOf(context).height / 2.h,
                      width: MediaQuery.sizeOf(context).width,
                      child: SvgPicture.asset(
                          "assets/steps/step_counter_bg.svg",
                          fit: BoxFit.cover),
                    ),
                  ),
                  StepCalculator(
                    stepCounterValue: stepsCounter,
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: CommonWidgets().ovalButton(
                      iconData: Icons.add,
                      callBack: () {
                        Navigate.pushNamed(const AddStepsGoals());
                      },
                    ),
                  ),
                ],
              ),
              StepOverViewHistory(
                listOfStepCounterModel:
                    listOfStepsHistory?.reversed.toList() ?? [],
              ),
            ],
          ),
        ),

        ///step counter AppBar
        Padding(
          padding: EdgeInsets.only(left: 12.w, right: 12.w, top: 50.h),
          child: CommonWidgets().customAppBar(
            borderColor: AppTheme.cT!.whiteColor!,
            text: "Step Counter",
          ),
        ),
      ],
    );
  }
}

class StepCalculator extends StatelessWidget {
  final String stepCounterValue;

  const StepCalculator({
    super.key,
    required this.stepCounterValue,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      bottom: 0,
      left: 0,
      right: 0,
      child: CommonWidgets()
          .makeDynamicTextSpan(
              text1: '$stepCounterValue\n',
              text2: "Steps",
              size1: 82,
              size2: 22,
              weight2: FontWeight.w400,
              weight1: FontWeight.bold,
              align: TextAlign.center,
              color1: AppTheme.cT!.whiteColor,
              color2: AppTheme.cT!.whiteColor)
          .centralized(),
    );
  }
}

class StepOverViewHistory extends StatelessWidget {
  final List<StepCounterGoalModel> listOfStepCounterModel;

  const StepOverViewHistory({
    super.key,
    required this.listOfStepCounterModel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CommonWidgets().listViewAboveRow(
          context: context,
          text1: "Steps Overview",
          text2: "See All",
          callBack: () => Navigate.pushNamed(const StepsStatistics()),
        ),
        10.height,
        ListView.builder(
          itemCount: listOfStepCounterModel.length < 4
              ? listOfStepCounterModel.length
              : 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          itemBuilder: (context, index) {
            StepCounterGoalModel counterModel = listOfStepCounterModel[index];

            return StepsDailyItemView(
              isFromMain: true,
              counterModel: counterModel,
              isFirstStepGoalEntryIndex: index == 0 ? true : false,
            );
          },
        )
      ],
    );
  }
}
