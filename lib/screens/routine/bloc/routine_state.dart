import 'package:equatable/equatable.dart';
import 'package:freud_ai/screens/routine/model/day_daily_routine_planner_model.dart';
import 'package:freud_ai/screens/routine/model/tags_model.dart';

enum RoutinePlannerStatus { initial, loading, loaded, error }

class RoutinePlannerState extends Equatable {
  final RoutinePlannerStatus? status;
  final List<DayDailyRoutinePlannerModel>? dailyRoutinePlannerList;
  final DayDailyRoutinePlannerModel? filterDailyRoutineByDate;
  final List<TagsModel>? listOfTags;

  ///Routine planner constructor state
  const RoutinePlannerState({
    this.status,
    this.listOfTags,
    this.dailyRoutinePlannerList,
    this.filterDailyRoutineByDate,
  });

  ///Routine Planner initial State
  static RoutinePlannerState initial() => const RoutinePlannerState(
        status: RoutinePlannerStatus.initial,
        listOfTags: [],
        dailyRoutinePlannerList: [],
        filterDailyRoutineByDate: null,
      );

  ///Routine Planner Copy with function
  RoutinePlannerState copyWith(
          {RoutinePlannerStatus? status,
          String? selectedTag,
          List<TagsModel>? listOfTags,
          List<DayDailyRoutinePlannerModel>? dailyRoutinePlannerList,
          DayDailyRoutinePlannerModel? filterDailyRoutineByDate}) =>
      RoutinePlannerState(
        status: status ?? this.status,
        listOfTags: listOfTags ?? this.listOfTags,
        dailyRoutinePlannerList:
            dailyRoutinePlannerList ?? this.dailyRoutinePlannerList,
        filterDailyRoutineByDate:
            filterDailyRoutineByDate ?? this.filterDailyRoutineByDate,
      );

  @override
  List<Object?> get props => [
        status,
        listOfTags,
        dailyRoutinePlannerList,
        filterDailyRoutineByDate,
      ];
}
