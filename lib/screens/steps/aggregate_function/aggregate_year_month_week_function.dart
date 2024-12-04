import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freud_ai/screens/steps/bloc/steps_bloc.dart';
import 'package:freud_ai/screens/steps/model/step_counter_goal_model.dart';
import 'package:freud_ai/screens/steps/model/step_report_model/month_report_model.dart';
import 'package:freud_ai/screens/steps/model/step_report_model/week_report_model.dart';
import 'package:freud_ai/screens/steps/model/step_report_model/year_report_model.dart';
import 'package:intl/intl.dart';

class AggregateYearMonthWeekFunction {
  /// aggregate function by week
  List<WeekModel> groupStepsByWeek(List<StepCounterGoalModel> steps) {
    List<WeekModel> weeklyData = [];
    Map<String, List<StepCounterGoalModel>> groupedByWeek = {};

    for (var step in steps) {
      DateTime date = DateFormat('MM/dd/yyyy').parse(step.todayDateId!);
      DateTime startOfWeek = date
          .subtract(Duration(days: date.weekday - 1)); // Monday of that week
      DateTime endOfWeek =
          startOfWeek.add(const Duration(days: 6)); // Sunday of that week
      // String weekKey =
      //     '${DateFormat('MMMM').format(startOfWeek)} - ${DateFormat('MMMM').format(endOfWeek)}';
      String weekKey = '${startOfWeek.day} ${DateFormat('MMMM').format(startOfWeek)} - ${endOfWeek.day} ${DateFormat('MMMM').format(endOfWeek)}';

      if (!groupedByWeek.containsKey(weekKey)) {
        groupedByWeek[weekKey] = [];
      }
      groupedByWeek[weekKey]!.add(step);
    }

    groupedByWeek.forEach((weekKey, weekSteps) {
      List<WeekViewModel> weekViewModels = weekSteps.map((step) {
        return WeekViewModel(
          day: DateFormat('EEEE')
              .format(DateFormat('MM/dd/yyyy').parse(step.todayDateId!)),
          stepCounterGoalModel: step,
        );
      }).toList();

      weeklyData.add(WeekModel(
        weekRange: weekKey,
        listOfWeekViewModel: weekViewModels,
      ));
    });

    return weeklyData;
  }

  /// aggregate function by month
  List<MonthModel> aggregateByMonth(List<StepCounterGoalModel> steps) {
    List<WeekModel> weeklyData = groupStepsByWeek(steps);
    Map<String, List<MonthViewModel>> groupedByMonth = {};

    for (var week in weeklyData) {
      DateTime date =
          DateFormat('dd MMMM').parse(week.weekRange.split(' - ')[0]);
      String monthKey = DateFormat('MMMM yyyy').format(date);

      if (!groupedByMonth.containsKey(monthKey)) {
        groupedByMonth[monthKey] = [];
      }
      groupedByMonth[monthKey]!.add(MonthViewModel(
        weekRange: week.weekRange,
        listOfStepCounterMode: week.listOfWeekViewModel
            .map((e) => e.stepCounterGoalModel)
            .toList(),
      ));
    }

    List<MonthModel> monthlyData = groupedByMonth.entries.map((entry) {
      return MonthModel(
        monthName: entry.key,
        listOfMonthViewModel: entry.value,
      );
    }).toList();

    return monthlyData;
  }

  /// aggregate function by year
  List<YearViewModel> aggregateByYear(List<StepCounterGoalModel> steps) {
    List<MonthModel> monthlyData = aggregateByMonth(steps);
    Map<String, List<StepCounterGoalModel>> groupedByYear = {};

    for (var month in monthlyData) {
      DateTime date = DateFormat('MMMM yyyy').parse(month.monthName);
      String yearKey = DateFormat('yyyy').format(date);

      for (var week in month.listOfMonthViewModel) {
        if (!groupedByYear.containsKey(yearKey)) {
          groupedByYear[yearKey] = [];
        }
        groupedByYear[yearKey]!.addAll(week.listOfStepCounterMode);
      }
    }

    List<YearViewModel> yearlyData = groupedByYear.entries.expand((entry) {
      Map<String, List<StepCounterGoalModel>> groupedByMonth = {};

      for (var step in entry.value) {
        DateTime date = DateFormat('MM/dd/yyyy').parse(step.todayDateId!);
        String monthKey = DateFormat('MMMM').format(date);

        if (!groupedByMonth.containsKey(monthKey)) {
          groupedByMonth[monthKey] = [];
        }
        groupedByMonth[monthKey]!.add(step);
      }

      return groupedByMonth.entries.map((monthEntry) {
        return YearViewModel(
          month: monthEntry.key,
          year: entry.key,
          listOfStepCounterMode: monthEntry.value,
        );
      }).toList();
    }).toList();

    return yearlyData;
  }


  Map<String, dynamic> calculateProgressAndTotalSteps(List<StepCounterGoalModel> dataSet,BuildContext context) {
    double totalGoalSteps = 0;
    double totalSteps = 0;
    int dayEndStepValue = 0;

    for (StepCounterGoalModel data in dataSet) {
      totalGoalSteps += data.goalStep ?? 0;
      if(data.todayDateId == DateFormat('MM/dd/yyyy').format(DateTime.now())){
        dayEndStepValue = context.read<StepsBloc>().pedometerStep;
      }else{
        dayEndStepValue = data.dayEndStepValue ?? 0;
      }

      int dayStartStepValue = data.dayStartStepValue ?? 0;
      int dayTotalSteps = dayEndStepValue - dayStartStepValue;
      totalSteps += dayTotalSteps;
    }

    double percentage = totalSteps / totalGoalSteps;
    double progress = percentage * 100;

    return {
      "percentage": percentage,
      "progress": progress,
      "totalSteps": totalSteps,
      "totalGoalSteps": totalGoalSteps
    };
  }


}
