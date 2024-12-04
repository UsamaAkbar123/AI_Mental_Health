import 'package:freud_ai/screens/steps/model/step_counter_goal_model.dart';

class YearViewModel {
  final String month;
  final String year;
  final List<StepCounterGoalModel> listOfStepCounterMode;

  YearViewModel({
    required this.month,
    required this.year,
    required this.listOfStepCounterMode,
  });
}