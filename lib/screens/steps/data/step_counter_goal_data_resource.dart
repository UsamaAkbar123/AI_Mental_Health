import 'dart:developer';

import 'package:freud_ai/configs/constants/constants.dart';
import 'package:freud_ai/configs/database/database_helper.dart';
import 'package:freud_ai/screens/steps/model/step_counter_goal_model.dart';
import 'package:sqflite/sqflite.dart';

class StepCounterGoalDataResource {
  Database database;

  /// constructor
  StepCounterGoalDataResource(this.database);

  /// create StepCounterGoalDataResource table
  Future<void> createStepCounterGoalTable() async {
    /// table name
    const String tableName = Constants.stepCounterGoalTableName;

    /// Define column names
    const String columnId = 'id';
    const String columnTodayDateId = 'todayDateId';
    const String columnGoalStep = 'goalStep';
    const String columnGoalCalories = 'goalCalories';
    const String columnGoalDistance = 'goalDistance';
    const String columnDayStartStepValue = 'dayStartStepValue';
    const String columnDayEndStepValue = 'dayEndStepValue';
    const String columnDayTotalSteps = 'dayTotalSteps';
    const String columnTimeStamp = 'timeStamp';

    try {
      if (!(await databaseHelper.isTableExist(
        Constants.stepCounterGoalTableName,
      ))) {
        await database.execute('''
      CREATE TABLE $tableName (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnTodayDateId TEXT,
        $columnGoalStep INTEGER,
        $columnGoalCalories DOUBLE,
        $columnGoalDistance DOUBLE,
        $columnDayStartStepValue INTEGER,
        $columnDayEndStepValue INTEGER,
        $columnDayTotalSteps INTEGER,
        $columnTimeStamp TEXT
      )
    ''');
      }
    } catch (e) {
      log("Error in createStepCounterTable: $e");
    }
  }

  /// add step counter goal function
  Future<int> addOrUpdateStepCounterGoal({
    StepCounterGoalModel? stepCounterGoalModel,
  }) async {
    int count = -1;
    await createStepCounterGoalTable();

    try {
      if(stepCounterGoalModel != null){
        int? isDataAlreadyExit = Sqflite.firstIntValue(await database.rawQuery(
            'SELECT COUNT(*) FROM ${Constants.stepCounterGoalTableName} WHERE todayDateId = ?',
            [stepCounterGoalModel.todayDateId]));

        /// if the today date is not added then add new entry in database
        /// else
        /// update the already inserted entry

        if (isDataAlreadyExit != null && isDataAlreadyExit == 0) {
          count = await database.insert(
            Constants.stepCounterGoalTableName,
            stepCounterGoalModel.toJson(),
          );

          log("insert data: $count");
          return count;
        } else {
          count = await database.update(
            Constants.stepCounterGoalTableName,
            stepCounterGoalModel.toJson(),
            where: 'todayDateId = ?',
            whereArgs: [stepCounterGoalModel.todayDateId],
          );

          log("update data: $count");
          return count;
        }
      }

      return 0;

    } catch (e, st) {
      log("Error in insertOrUpdateStepGoal: $e  :: $st");
      return 0;
    }
  }

  /// check today step goal entry exist or not
  Future<bool> isTodayStepGoalEntryExist(String todayDateId) async {
    await createStepCounterGoalTable();
    int? isDataAlreadyExit = Sqflite.firstIntValue(await database.rawQuery(
        'SELECT COUNT(*) FROM ${Constants.stepCounterGoalTableName} WHERE todayDateId = ?',
        [todayDateId]));
    if(isDataAlreadyExit != null && isDataAlreadyExit > 0){
      return true;
    }
    return false;
  }

  /// get step counter goal history
  Future<List<StepCounterGoalModel>?> getStepsCounterGoalHistory() async {
    if ((await databaseHelper.isTableExist(
      Constants.stepCounterGoalTableName,
    ))) {
      List<Map<String, dynamic>> results = await database.query(
        Constants.stepCounterGoalTableName,
      );

      if (results.isNotEmpty) {
        return results
            .map((map) => StepCounterGoalModel.fromJson(map))
            .toList();
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
}
