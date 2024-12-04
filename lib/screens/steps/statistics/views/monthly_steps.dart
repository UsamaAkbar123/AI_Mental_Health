import 'package:flutter/material.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/screens/calender/show_events_calender.dart';
import 'package:freud_ai/screens/steps/aggregate_function/aggregate_year_month_week_function.dart';
import 'package:freud_ai/screens/steps/model/step_counter_goal_model.dart';
import 'package:freud_ai/screens/steps/model/step_report_model/month_report_model.dart';
import 'package:freud_ai/screens/steps/view/common_view_widgets/step_counter_yearly_or_month_item_view_widget.dart';

class MonthlyStepsView extends StatelessWidget {
  final List<StepCounterGoalModel>? listOfStepCounterModel;
  final List<MonthModel> monthlyData;

  const MonthlyStepsView({
    super.key,
    required this.listOfStepCounterModel,
    required this.monthlyData,
  });

  static AggregateYearMonthWeekFunction aggregateYearMonthWeekFunction =
      AggregateYearMonthWeekFunction();

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: monthlyData.length,
      itemBuilder: (context, outerIndex) {
        List<MonthViewModel> listOfMonthView =
            monthlyData[outerIndex].listOfMonthViewModel;
        return SingleChildScrollView(
          child: Column(
            children: [
              16.height,
              SizedBox(
                height: 300.h,
                child: ShowEventsCalender(
                  listOfStepCounterModel: listOfStepCounterModel!,
                ),
              ),
              15.height,
              ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: listOfMonthView.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, innerIndex) {
                  Map<String, dynamic> result = aggregateYearMonthWeekFunction
                      .calculateProgressAndTotalSteps(
                    listOfMonthView[innerIndex].listOfStepCounterMode,
                    context,
                  );
                  return StepCounterYearlyOrMonthItemView(
                    monthOrWeekRangeName: listOfMonthView[innerIndex].weekRange,
                    totalMonthOrWeekRangeSteps: result["totalSteps"],
                    stepProgress:
                        result["totalSteps"] < result["totalGoalSteps"]
                            ? result["progress"]
                            : 100,
                    stepPercentageValue:
                        result["totalSteps"] < result["totalGoalSteps"]
                            ? result["percentage"]
                            : 1.0,
                  );
                },
          ),
            ],
          ),
        );
      },
    );
  }
}
