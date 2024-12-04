import 'package:freud_ai/screens/steps/model/step_counter_goal_model.dart';

enum AddStepsGoalsStatus { inProgress, loaded, success, error }

enum CurrentTodayStepValueCalculationStatus {inProgress, loaded}

///Steps State
abstract class StepsState {}


/// initial state
class StepsInitialState extends StepsState {}

/// today current steps
class CurrentTodayStepsState extends StepsState {
  int todayCurrentStepValue;
  CurrentTodayStepValueCalculationStatus status;

  CurrentTodayStepsState({
    required this.status,
    required this.todayCurrentStepValue,
  });
}

/// new step logic
class StepsCounterGoalLoadedState extends StepsState {
  AddStepsGoalsStatus? status;
  StepCounterGoalModel? stepCounterGoalModelLastEntry;
  List<StepCounterGoalModel>? listOfStepCounterGoalModel;

  StepsCounterGoalLoadedState({
    this.stepCounterGoalModelLastEntry,
    this.status,
    this.listOfStepCounterGoalModel,
  });
}
