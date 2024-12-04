import 'package:freud_ai/screens/steps/model/step_counter_goal_model.dart';

class MonthModel {
  final String monthName;
  final List<MonthViewModel> listOfMonthViewModel;

  MonthModel({
    required this.monthName,
    required this.listOfMonthViewModel,
  });
}

class MonthViewModel {
  final String weekRange;
  final List<StepCounterGoalModel> listOfStepCounterMode;

  MonthViewModel({
    required this.weekRange,
    required this.listOfStepCounterMode,
  });
}