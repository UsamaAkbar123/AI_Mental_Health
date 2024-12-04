import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:freud_ai/configs/constants/constants.dart';
import 'package:freud_ai/configs/database/database_helper.dart';
import 'package:freud_ai/screens/steps/model/step_counter_goal_model.dart';
import 'package:intl/intl.dart';
import 'package:pedometer/pedometer.dart';
import 'package:sqflite/sqflite.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackInitializeStepCounterBackgroundServiceDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await backgroundServiceFunction();

    return Future.value(true);
  });
}

/// android background service callback
@pragma('vm:entry-point')
Future<void> backgroundServiceFunction() async {
  /// Ensure that plugin services are initialized so they can be used in the isolate
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize Pedometer
  Stream<StepCount> pedometer = Pedometer.stepCountStream;

  /// today step counter goal model
  StepCounterGoalModel? todayStepCounterGoalModel;

  /// previous day step counter goal model
  StepCounterGoalModel? previousDayStepCounterGoalModel;

  /// pedometer steps value
  int pedometerStepValue = 0;

  /// end day step value
  int endDayStepValue = 0;

  todayStepCounterGoalModel = await isTodayStepGoalEntryExist(
    todayDateId: DateFormat('MM/dd/yyyy').format(DateTime.now()),
  );
  if (todayStepCounterGoalModel != null)  {
    /// Using a Completer to wait for the first pedometer update
    Completer<void> pedometerUpdated = Completer<void>();

    pedometer.listen((event) async {
      pedometerStepValue = event.steps;
      if (!pedometerUpdated.isCompleted) {
        pedometerUpdated.complete();
      }
    }).onError((error) {
      log("background service pedometer listen error: $error");
    });

    /// Wait for the first pedometer update
    await pedometerUpdated.future;

    /// get the value of end dat step value
    endDayStepValue = todayStepCounterGoalModel.dayEndStepValue ?? 0;

    log("pedometer bg step value: $pedometerStepValue");
    log("day end bg step value: $endDayStepValue");

    if (pedometerStepValue > endDayStepValue) {
      todayStepCounterGoalModel = todayStepCounterGoalModel.copyWith(
        todayDateId: todayStepCounterGoalModel.todayDateId,
        goalStep: todayStepCounterGoalModel.goalStep,
        goalCalories: todayStepCounterGoalModel.goalCalories,
        goalDistance: todayStepCounterGoalModel.goalDistance,
        dayStartStepValue: todayStepCounterGoalModel.dayStartStepValue,
        dayEndStepValue: pedometerStepValue,
        dayTotalSteps: todayStepCounterGoalModel.dayTotalSteps,
        timeStamp: todayStepCounterGoalModel.timeStamp,
      );
      await updateDayEndStepValue(
        stepCounterGoalModel: todayStepCounterGoalModel,
      );
    }
  } else {
    previousDayStepCounterGoalModel = await getPreviousDayStepCounterEntry(
      todayDateId: DateFormat('MM/dd/yyyy').format(
        DateTime.now().subtract(const Duration(days: 1)),
      ),
    );
    if (previousDayStepCounterGoalModel != null) {
      /// Using a Completer to wait for the first pedometer update
      Completer<void> pedometerUpdated = Completer<void>();

      pedometer.listen((event) async {
        pedometerStepValue = event.steps;
        if (!pedometerUpdated.isCompleted) {
          pedometerUpdated.complete();
        }
      }).onError((error) {
        log("background service pedometer listen error: $error");
      });

      /// Wait for the first pedometer update
      await pedometerUpdated.future;

      /// get the value of end dat step value
      endDayStepValue = previousDayStepCounterGoalModel.dayEndStepValue ?? 0;

      /// add new step goal for today in database
      previousDayStepCounterGoalModel =
          previousDayStepCounterGoalModel.copyWith(
        todayDateId: DateFormat('MM/dd/yyyy').format(DateTime.now()),
        goalStep: previousDayStepCounterGoalModel.goalStep,
        goalCalories: previousDayStepCounterGoalModel.goalCalories,
        goalDistance: previousDayStepCounterGoalModel.goalDistance,
        // dayStartStepValue: previousDayStepCounterGoalModel.dayEndStepValue,
        dayStartStepValue: pedometerStepValue == 0 ? previousDayStepCounterGoalModel.dayEndStepValue : pedometerStepValue,
        dayEndStepValue: 0,
        dayTotalSteps: 0,
        timeStamp: DateFormat('MMM dd').format(DateTime.now()),
      );
      await addTodayStepCounterGoal(
        stepCounterGoalModel: previousDayStepCounterGoalModel,
      );

      /// after this check if previous day end steps values are less the pedometers steps values
      /// then update the previous step count day end value, with pedometers steps values

      if (pedometerStepValue > endDayStepValue && pedometerStepValue != 0) {
        previousDayStepCounterGoalModel =
            previousDayStepCounterGoalModel.copyWith(
          todayDateId: previousDayStepCounterGoalModel.todayDateId,
          goalStep: previousDayStepCounterGoalModel.goalStep,
          goalCalories: previousDayStepCounterGoalModel.goalCalories,
          goalDistance: previousDayStepCounterGoalModel.goalDistance,
          dayStartStepValue: previousDayStepCounterGoalModel.dayStartStepValue,
          dayEndStepValue: pedometerStepValue,
          dayTotalSteps: previousDayStepCounterGoalModel.dayTotalSteps,
          timeStamp: previousDayStepCounterGoalModel.timeStamp,
        );
        await updateDayEndStepValue(
          stepCounterGoalModel: previousDayStepCounterGoalModel,
        );
      }
    }
  }
}

/// initialize the step counter background service
Future<void> initializeStepCounterBackgroundService() async {
  bool isRunning = await isStepCounterBackgroundAlreadyRunning();
  final service = FlutterBackgroundService();

  if (isRunning) {
    service.invoke("stop");
  }

  service.configure(
    iosConfiguration: IosConfiguration(
        onForeground: onStart,
        onBackground: onIosBackground,
      ),
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: true,
      isForegroundMode: true,
      autoStartOnBoot: true,
    ),
  );

    service.startService();
}

/// android background service callback
@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  /// Ensure that plugin services are initialized so they can be used in the isolate
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize Pedometer
  Stream<StepCount> pedometer = Pedometer.stepCountStream;

  /// today step counter goal model
  StepCounterGoalModel? todayStepCounterGoalModel;

  /// previous day step counter goal model
  StepCounterGoalModel? previousDayStepCounterGoalModel;

  /// pedometer steps value
  int pedometerStepValue = 0;

  /// end day step value
  int endDayStepValue = 0;

  while (true) {
    todayStepCounterGoalModel = await isTodayStepGoalEntryExist(
      todayDateId: DateFormat('MM/dd/yyyy').format(DateTime.now()),
    );
    if (todayStepCounterGoalModel != null) {
      pedometer.listen((event) async {
        pedometerStepValue = event.steps;
      }).onError((error) {
        log("background service pedometer listen error: $error");
      });

      /// get the value of end dat step value
      endDayStepValue = todayStepCounterGoalModel.dayEndStepValue ?? 0;

      log("pedometer bg step value: $pedometerStepValue");
      log("day end bg step value: $endDayStepValue");

      if (pedometerStepValue > endDayStepValue) {
        todayStepCounterGoalModel = todayStepCounterGoalModel.copyWith(
          todayDateId: todayStepCounterGoalModel.todayDateId,
          goalStep: todayStepCounterGoalModel.goalStep,
          goalCalories: todayStepCounterGoalModel.goalCalories,
          goalDistance: todayStepCounterGoalModel.goalDistance,
          dayStartStepValue: todayStepCounterGoalModel.dayStartStepValue,
          dayEndStepValue: pedometerStepValue,
          dayTotalSteps: todayStepCounterGoalModel.dayTotalSteps,
          timeStamp: todayStepCounterGoalModel.timeStamp,
        );
        await updateDayEndStepValue(
          stepCounterGoalModel: todayStepCounterGoalModel,
        );
      }
    } else {
      previousDayStepCounterGoalModel = await getPreviousDayStepCounterEntry(
        todayDateId: DateFormat('MM/dd/yyyy').format(
          DateTime.now().subtract(const Duration(days: 1)),
        ),
      );
      if (previousDayStepCounterGoalModel != null) {
        previousDayStepCounterGoalModel =
            previousDayStepCounterGoalModel.copyWith(
          todayDateId: DateFormat('MM/dd/yyyy').format(DateTime.now()),
          goalStep: previousDayStepCounterGoalModel.goalStep,
          goalCalories: previousDayStepCounterGoalModel.goalCalories,
          goalDistance: previousDayStepCounterGoalModel.goalDistance,
          dayStartStepValue: previousDayStepCounterGoalModel.dayEndStepValue,
          dayEndStepValue: 0,
          dayTotalSteps: 0,
          timeStamp: DateFormat('MMM dd').format(DateTime.now()),
        );
        await addTodayStepCounterGoal(
          stepCounterGoalModel: previousDayStepCounterGoalModel,
        );
      }
    }

    // Sleep for some time before the next iteration
    await Future.delayed(const Duration(minutes: 5));
  }
}

/// ios background service callback
@pragma('vm:entry-point')
bool onIosBackground(ServiceInstance service) {
  WidgetsFlutterBinding.ensureInitialized();
  return true;
}

/// check today step goal entry exist or not
@pragma('vm:entry-point')
Future<StepCounterGoalModel?> isTodayStepGoalEntryExist({
  required String todayDateId,
}) async {
  try {
    // await createStepCounterGoalTable();
    final database = await databaseHelper.database;

    int? isDataAlreadyExit = Sqflite.firstIntValue(await database.rawQuery(
        'SELECT COUNT(*) FROM ${Constants.stepCounterGoalTableName} WHERE todayDateId = ?',
        [todayDateId]));
    if (isDataAlreadyExit != null && isDataAlreadyExit > 0) {
      List<Map<String, dynamic>> results = await database.query(
        Constants.stepCounterGoalTableName,
        where: 'todayDateId = ?',
        whereArgs: [todayDateId],
      );

      if (results.isNotEmpty) {
        Map<String, dynamic> data = results.first;
        return StepCounterGoalModel.fromJson(data);
      }

      return null;
    }
    return null;
  } catch (e) {
    log("isTodayStepGoalEntryExist exception case: $e");
    return null;
  }
}

/// get previous day step counter data
@pragma('vm:entry-point')
Future<StepCounterGoalModel?> getPreviousDayStepCounterEntry({
  required String todayDateId,
}) async {
  try {
    final database = await databaseHelper.database;

    int? isDataAlreadyExit = Sqflite.firstIntValue(await database.rawQuery(
        'SELECT COUNT(*) FROM ${Constants.stepCounterGoalTableName} WHERE todayDateId = ?',
        [todayDateId]));
    if (isDataAlreadyExit != null && isDataAlreadyExit > 0) {
      List<Map<String, dynamic>> results = await database.query(
        Constants.stepCounterGoalTableName,
        where: 'todayDateId = ?',
        whereArgs: [todayDateId],
      );

      if (results.isNotEmpty) {
        Map<String, dynamic> data = results.first;
        return StepCounterGoalModel.fromJson(data);
      }

      return null;
    }
    return null;
  } catch (e) {
    log("getPreviousDayStepCounterEntry exception case: $e");
    return null;
  }
}

/// update the dayEndStepValue
@pragma('vm:entry-point')
Future<int> updateDayEndStepValue({
  required StepCounterGoalModel stepCounterGoalModel,
}) async {
  int count = -1;
  final database = await databaseHelper.database;

  try {
    count = await database.update(
      Constants.stepCounterGoalTableName,
      stepCounterGoalModel.toJson(),
      where: 'todayDateId = ?',
      whereArgs: [stepCounterGoalModel.todayDateId],
    );

    log("update data: $count");
    return count;
  } catch (e, st) {
    log("Exception in updateDayEndStepValue: $e  :: $st");
    return 0;
  }
}

/// add today step counter goal entry
@pragma('vm:entry-point')
Future<int> addTodayStepCounterGoal({
  required StepCounterGoalModel stepCounterGoalModel,
}) async {
  int count = -1;
  final database = await databaseHelper.database;

  try {
    count = await database.insert(
      Constants.stepCounterGoalTableName,
      stepCounterGoalModel.toJson(),
    );

    log("insert data: $count");
    return count;
  } catch (e, st) {
    log("Exception in updateDayEndStepValue: $e  :: $st");
    return 0;
  }
}

/// is background service is already running
@pragma('vm:entry-point')
Future<bool> isStepCounterBackgroundAlreadyRunning() async {
  final service = FlutterBackgroundService();
  return await service.isRunning();
}
