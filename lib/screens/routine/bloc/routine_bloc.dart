import 'package:bloc/bloc.dart';
import 'package:freud_ai/configs/database/database_helper.dart';
import 'package:freud_ai/screens/routine/bloc/routine_event.dart';
import 'package:freud_ai/screens/routine/bloc/routine_state.dart';
import 'package:freud_ai/screens/routine/data/daily_routine_planner_data_resource.dart';
import 'package:freud_ai/screens/routine/model/day_daily_routine_planner_model.dart';
import 'package:freud_ai/screens/routine/model/tags_model.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqlite_api.dart';

class RoutineBloc extends Bloc<RoutinePlannerEvent, RoutinePlannerState> {
  RoutineBloc() : super(RoutinePlannerState.initial()) {
    /// new implementation

    /// get list of all daily routine planner task
    on<GetDailyRoutineTaskListEvent>(_getDailyRoutineTaskList);

    /// add daily routine task
    on<AddDailyRoutineTaskEvent>(_addDailyRoutineTask);

    /// filter daily routine task based on date
    on<GetSingleDailyRoutineTaskByDataEvent>(
      _getSingleDailyRoutineTaskByDataEvent,
    );

    /// add the routines tasks in database after onboarding
    on<AddRoutinePlanToDatabaseAfterOnboardingEvent>(
      _routinePlannerAddedToAfterOnboardingDatabase,
    );

    /// create the routine after onboarding
    on<RoutinePlannerCreatingAfterOnboardingEvent>(
      _routinePlannerCreatingAfterOnboardingEvent,
    );

    /// mark as complete or un complete
    on<MarkAsCompleteOrUnCompleteTheRoutineTaskEvent>(
      _markAsCompleteOrUnCompleteTheRoutineTaskEvent,
    );

    /// update or delete routine task
    on<UpdateOrDeleteRoutineTaskEvent>(
      _updateOrDeleteRoutineTaskEvent,
    );

    /// add new tag
    on<AddRoutinePlannerTagEvent>(_addNewTagInRoutinePlan);

    /// get the list of routine task tags
    on<GetRoutinePlanTagEvent>(_getRoutinePlanTagEvent);

    /// delete specific routine based on dayID and routine task common id
    on<DeleteSpecificRoutineTaskEvent>(_deleteSpecificRoutineTaskEvent);
  }

  /// mark the routine task either complete or in complete
  _deleteSpecificRoutineTaskEvent(
    DeleteSpecificRoutineTaskEvent event,
    Emitter<RoutinePlannerState> emit,
  ) async {
    Database database = await databaseHelper.database;

    emit(
      state.copyWith(
        status: RoutinePlannerStatus.loading,
        dailyRoutinePlannerList: [],
      ),
    );

    await DailyRoutinePlannerDataResource(database)
        .deleteRoutineTaskBYDayIdAndTaskRoutineCommonId(
      commonId: event.commonId,
      routinePlans: event.routinePlans,
    );

    add(GetDailyRoutineTaskListEvent(dayId: event.dayId));
  }

  /// mark the routine task either complete or in complete
  _markAsCompleteOrUnCompleteTheRoutineTaskEvent(
    MarkAsCompleteOrUnCompleteTheRoutineTaskEvent event,
    Emitter<RoutinePlannerState> emit,
  ) async {
    Database database = await databaseHelper.database;

    await DailyRoutinePlannerDataResource(database)
        .routineTaskMarkAsCompleteOrUnComplete(
      dayId: event.dayId,
      routineTaskModel: event.routineTaskModel,
    );

    add(GetDailyRoutineTaskListEvent(dayId: event.dayId));

    // Emit an additional event for fetching the filtered data
    // add(GetSingleDailyRoutineTaskByDataEvent(
    //   filterDate: event.dayId,
    // ));
  }

  /// mark the routine task either complete or in complete
  _updateOrDeleteRoutineTaskEvent(
    UpdateOrDeleteRoutineTaskEvent event,
    Emitter<RoutinePlannerState> emit,
  ) async {
    Database database = await databaseHelper.database;

    await DailyRoutinePlannerDataResource(database)
        .updateOrDeleteRoutinePlanner(
      dayId: event.dayId,
      updatedRoutineTaskModel: event.updateRoutineTaskModel,
    );

    add(GetDailyRoutineTaskListEvent(dayId: event.dayId));

    // Emit an additional event for fetching the filtered data
    // add(GetSingleDailyRoutineTaskByDataEvent(
    //   filterDate: event.dayId,
    // ));
  }

  ///  get the list of GetDailyRoutineTaskListEvent
  _getDailyRoutineTaskList(
    GetDailyRoutineTaskListEvent event,
    Emitter<RoutinePlannerState> emit,
  ) async {
    Database database = await databaseHelper.database;

    emit(
      state.copyWith(
        status: RoutinePlannerStatus.loading,
        dailyRoutinePlannerList: [],
      ),
    );
    var list =
        await DailyRoutinePlannerDataResource(database).getDailyRoutinePlan();
    emit(state.copyWith(
      // status: RoutinePlannerStatus.loaded,
      dailyRoutinePlannerList: list ?? [],
    ));


    // log("daily routine planner list length: ${state.dailyRoutinePlannerList.toString()}");


    // Emit an additional event for fetching the filtered data
    if (event.dayId == null) {
      add(GetSingleDailyRoutineTaskByDataEvent(
        filterDate: DateFormat('d MMMM y').format(DateTime.now()),
      ));
    } else {
      add(GetSingleDailyRoutineTaskByDataEvent(
        filterDate: event.dayId,
      ));
    }
  }

  /// add routine task to database
  _addDailyRoutineTask(
    AddDailyRoutineTaskEvent event,
    Emitter<RoutinePlannerState> emit,
  ) async {
    emit(state.copyWith(status: RoutinePlannerStatus.loading));

    Database database = await databaseHelper.database;
    await DailyRoutinePlannerDataResource(database)
        .addDailyRoutinePlan(event.dailyRoutinePlannerModel!);


    add(GetDailyRoutineTaskListEvent());
  }

  _getSingleDailyRoutineTaskByDataEvent(
    GetSingleDailyRoutineTaskByDataEvent event,
    Emitter<RoutinePlannerState> emit,
  ) async {
    if (state.dailyRoutinePlannerList!.isNotEmpty) {
      var filterData = state.dailyRoutinePlannerList?.firstWhere(
        (element) => element.dayId == event.filterDate,
        orElse: () => DayDailyRoutinePlannerModel(
          dayId: "", // Adjust according to your model's requirements
          routineTaskModelList: [], // Empty list or default tasks
        ),
      );

      // log("filter data: ${filterData?.toJson()}");

      emit(state.copyWith(
        status: RoutinePlannerStatus.loaded,
        filterDailyRoutineByDate: filterData,
      ));
    }
  }

  ///This  method  will call when we are creating the  routine planner
  _routinePlannerCreatingAfterOnboardingEvent(
    RoutinePlannerCreatingAfterOnboardingEvent event,
    Emitter<RoutinePlannerState> emit,
  ) async {
    Database database = await databaseHelper.database;

    await DailyRoutinePlannerDataResource(database).createPlanForDailyRoutine();
  }

  ///This  method  will call when get the response and we save in database here
  _routinePlannerAddedToAfterOnboardingDatabase(
    AddRoutinePlanToDatabaseAfterOnboardingEvent event,
    Emitter<RoutinePlannerState> emit,
  ) async {
    Database database = await databaseHelper.database;

    await DailyRoutinePlannerDataResource(database)
        .addRoutinePlannerToDatabaseFromOnboarding(event.routinePlan!);
  }

  /// add new tag
  _addNewTagInRoutinePlan(AddRoutinePlannerTagEvent event,
      Emitter<RoutinePlannerState> emit) async {
    emit(state.copyWith(status: RoutinePlannerStatus.loading));

    Database database = await databaseHelper.database;

    List<TagsModel>? listOfTags =
        await DailyRoutinePlannerDataResource(database)
            .addNewTagInTagsList(event.tagsModel);

    emit(state.copyWith(
        status: RoutinePlannerStatus.loaded, listOfTags: listOfTags));
  }

  ///Here We will get  the  Routine Plan from the database
  _getRoutinePlanTagEvent(
    GetRoutinePlanTagEvent event,
    Emitter<RoutinePlannerState> emit,
  ) async {
    Database database = await databaseHelper.database;

    emit(state.copyWith(status: RoutinePlannerStatus.loading));

    List<TagsModel>? routineTagsList =
        await DailyRoutinePlannerDataResource(database).getRoutineTags();

    emit(state.copyWith(
      listOfTags: routineTagsList,
      status: RoutinePlannerStatus.loaded,
    ));
  }
}
