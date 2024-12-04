import 'package:freud_ai/screens/steps/model/step_counter_goal_model.dart';

class WeekModel {
  final String weekRange;
  final List<WeekViewModel> listOfWeekViewModel;

  WeekModel({
    required this.weekRange,
    required this.listOfWeekViewModel,
  });
}

class WeekViewModel {
  final String day;
  final StepCounterGoalModel stepCounterGoalModel;

  WeekViewModel({
    required this.day,
    required this.stepCounterGoalModel,
  });
}