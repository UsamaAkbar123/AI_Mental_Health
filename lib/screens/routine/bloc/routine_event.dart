import 'package:freud_ai/screens/routine/model/day_daily_routine_planner_model.dart';
import 'package:freud_ai/screens/routine/model/tags_model.dart';

abstract class RoutinePlannerEvent {}

/// add new daily routine task
class AddDailyRoutineTaskEvent extends RoutinePlannerEvent {
  final DayDailyRoutinePlannerModel? dailyRoutinePlannerModel;

  AddDailyRoutineTaskEvent({this.dailyRoutinePlannerModel});
}

/// delete specific routine based on dayID and routine task common id event
class DeleteSpecificRoutineTaskEvent extends RoutinePlannerEvent {
  final String commonId;
  final List<DayDailyRoutinePlannerModel> routinePlans;
  final String dayId;

  DeleteSpecificRoutineTaskEvent({
    required this.commonId,
    required this.routinePlans,
    required this.dayId,
  });
}

/// get the all daily routine task
class GetDailyRoutineTaskListEvent extends RoutinePlannerEvent {
  final String? dayId;

  GetDailyRoutineTaskListEvent({this.dayId});
}

/// get single daily routine task based on date
class GetSingleDailyRoutineTaskByDataEvent extends RoutinePlannerEvent {
  final String? filterDate;

  GetSingleDailyRoutineTaskByDataEvent({
    this.filterDate,
  });
}

/// create the routine plan after user onboarding
class RoutinePlannerCreatingAfterOnboardingEvent extends RoutinePlannerEvent {}


/// add the routine planes tasks to database after onboarding
class AddRoutinePlanToDatabaseAfterOnboardingEvent extends RoutinePlannerEvent {

  final List<RoutineTaskModel>? routinePlan;

  AddRoutinePlanToDatabaseAfterOnboardingEvent({this.routinePlan});

}

/// mark as complete or un complete the routine task event
class MarkAsCompleteOrUnCompleteTheRoutineTaskEvent
    extends RoutinePlannerEvent {
  final String dayId;
  final RoutineTaskModel routineTaskModel;

  MarkAsCompleteOrUnCompleteTheRoutineTaskEvent({
    required this.dayId,
    required this.routineTaskModel,
  });
}


/// add tag event
class AddRoutinePlannerTagEvent extends RoutinePlannerEvent {
  TagsModel tagsModel;

  AddRoutinePlannerTagEvent(this.tagsModel);

}


/// get tag list
class GetRoutinePlanTagEvent extends RoutinePlannerEvent {}


/// update or delete routine task event
class UpdateOrDeleteRoutineTaskEvent extends RoutinePlannerEvent{
  final String dayId;
  final RoutineTaskModel updateRoutineTaskModel;

  UpdateOrDeleteRoutineTaskEvent({
    required this.dayId,
    required this.updateRoutineTaskModel,
  });
}
