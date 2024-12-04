import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:freud_ai/configs/database/database_helper.dart';
import 'package:freud_ai/managers/preference_manager.dart';
import 'package:freud_ai/screens/steps/bloc/steps_event.dart';
import 'package:freud_ai/screens/steps/bloc/steps_state.dart';
import 'package:freud_ai/screens/steps/data/step_counter_goal_data_resource.dart';
import 'package:freud_ai/screens/steps/model/step_counter_goal_model.dart';
import 'package:freud_ai/screens/steps/step_counter_background_service/step_counter_background_service.dart';
import 'package:pedometer/pedometer.dart';
import 'package:workmanager/workmanager.dart';

class StepsBloc extends Bloc<StepsEvent, StepsState> {
  // CompleteStepsOverview? completeStepsOverview;

  /// new logic bloc
  StepCounterGoalModel? stepCounterGoalModelLastEntry;
  List<StepCounterGoalModel>? listOfStepCounterGoalModel;
  Stream<StepCount>? _stepCountStream;
  int pedometerStep = 0;
  int todayCurrentStepValue = 0;

  StepsBloc() : super(StepsInitialState()) {


    /// new step counter logic
    on<StepCounterGoalAddOrUpdateEvent>(_addOrUpdateStepsEventFunction);

    on<GetPedometerStepValueEvent>(_getPedometerStepValueEvent);

    on<GetStepCounterGoalHistoryEvent>(_getStepCounterGoalHistoryEvent);

    on<GetTodayCurrentStepValueEvent>(_getTodayCurrentStepValueEvent);
  }

  /// calculate the today current step value
  _getTodayCurrentStepValueEvent(
    GetTodayCurrentStepValueEvent event,
    Emitter<StepsState> emit,
  ) async {
    emit(CurrentTodayStepsState(
      status: CurrentTodayStepValueCalculationStatus.inProgress,
      todayCurrentStepValue: 0,
    ));

    /// check if stepCounterGoalModelLastEntry must not be null
    if (stepCounterGoalModelLastEntry != null) {
      int dayStartStepValue =
          stepCounterGoalModelLastEntry?.dayStartStepValue ?? 0;

      todayCurrentStepValue = pedometerStep - dayStartStepValue;

      emit(
        CurrentTodayStepsState(
          status: CurrentTodayStepValueCalculationStatus.loaded,
          todayCurrentStepValue: todayCurrentStepValue,
        ),
      );
    }
  }

  /// add or update step  counter goal
  _addOrUpdateStepsEventFunction(
    StepCounterGoalAddOrUpdateEvent event,
    Emitter<StepsState> emit,
  ) async {

    stepCounterGoalModelLastEntry = event.stepCounterGoalModel;

    emit(StepsCounterGoalLoadedState(
      stepCounterGoalModelLastEntry: stepCounterGoalModelLastEntry,
      listOfStepCounterGoalModel: [],
      status: AddStepsGoalsStatus.inProgress,
    ));

    final database = await databaseHelper.database;

    // stepCounterGoalModel = event.stepCounterGoalModel;

    int dataInsertStatus =
        await StepCounterGoalDataResource(database).addOrUpdateStepCounterGoal(
      stepCounterGoalModel: event.stepCounterGoalModel,
    );

    listOfStepCounterGoalModel = await StepCounterGoalDataResource(database)
        .getStepsCounterGoalHistory();

    stepCounterGoalModelLastEntry = listOfStepCounterGoalModel!.last;


    if (dataInsertStatus == 1) {
      emit(StepsCounterGoalLoadedState(
        stepCounterGoalModelLastEntry: stepCounterGoalModelLastEntry,
        listOfStepCounterGoalModel: listOfStepCounterGoalModel,
        status: AddStepsGoalsStatus.loaded,
      ));
      // initializeStepCounterBackgroundService();
      Workmanager().initialize(callbackInitializeStepCounterBackgroundServiceDispatcher, isInDebugMode: true);
      Workmanager().registerPeriodicTask(
        "task-identifier",
        "simpleTask",
        frequency: const Duration(minutes: 15),
      );
    } else {
      emit(StepsCounterGoalLoadedState(
        stepCounterGoalModelLastEntry: stepCounterGoalModelLastEntry,
        listOfStepCounterGoalModel: listOfStepCounterGoalModel,
        status: AddStepsGoalsStatus.error,
      ));
    }
  }

  /// get the value of pedometer
  _getPedometerStepValueEvent(
    GetPedometerStepValueEvent event,
    Emitter<StepsState> emit,
  ) async {

    /// Using a Completer to wait for the first pedometer update
    Completer<void> pedometerUpdated = Completer<void>();

    _stepCountStream = Pedometer.stepCountStream;

    _stepCountStream?.listen((event) async {
      pedometerStep = event.steps;
      if (pedometerStep != 0 &&
          event.steps > PreferenceManager().getSharedPedometerStep) {
        PreferenceManager().setSharedPedometerStep = event.steps;
      }
      add(GetTodayCurrentStepValueEvent());
    }).onError((error) {
      log("background service pedometer listen error: $error");
    });

    /// Wait for the first pedometer update
    await pedometerUpdated.future;


    // _stepCountStream?.listen((event) async {
    //   pedometerStep = event.steps;
    //   if(pedometerStep != 0){
    //     PreferenceManager().setSharedPedometerStep = event.steps;
    //   }
    // }).onError((error) {
    //   log("error: $error");
    // });

    if(pedometerStep == 0){
      pedometerStep = PreferenceManager().getSharedPedometerStep;
    }

    log("shared preference pedometer step: ${PreferenceManager().getSharedPedometerStep}");
  }

  /// get the list of step counter goal history
  _getStepCounterGoalHistoryEvent(
    GetStepCounterGoalHistoryEvent event,
    Emitter<StepsState> emit,
  ) async {
    emit(StepsCounterGoalLoadedState(
      stepCounterGoalModelLastEntry: stepCounterGoalModelLastEntry,
      listOfStepCounterGoalModel: [],
      status: AddStepsGoalsStatus.inProgress,
    ));

    final database = await databaseHelper.database;

    listOfStepCounterGoalModel = await StepCounterGoalDataResource(database)
        .getStepsCounterGoalHistory();

    log("step counter goal history: $listOfStepCounterGoalModel");

    stepCounterGoalModelLastEntry = listOfStepCounterGoalModel?.last;

    emit(StepsCounterGoalLoadedState(
      stepCounterGoalModelLastEntry: stepCounterGoalModelLastEntry,
      listOfStepCounterGoalModel: listOfStepCounterGoalModel,
      status: AddStepsGoalsStatus.loaded,
    ));
  }
}
