import 'package:freud_ai/screens/steps/model/step_counter_goal_model.dart';

///Main Abstract Chat Event
abstract class StepsEvent {}

class ScheduleStepCounterTask extends StepsEvent {}

class StepCounterGoalAddOrUpdateEvent extends StepsEvent {
  StepCounterGoalModel? stepCounterGoalModel;

  StepCounterGoalAddOrUpdateEvent({this.stepCounterGoalModel});
}

class GetPedometerStepValueEvent extends StepsEvent {}


class GetStepCounterGoalHistoryEvent extends StepsEvent{}


class GetTodayCurrentStepValueEvent extends StepsEvent{}