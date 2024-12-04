import 'dart:developer';

import 'package:freud_ai/application/bloc/app_info_bloc.dart';
import 'package:freud_ai/application/bloc/app_info_event.dart';
import 'package:freud_ai/configs/constants/constants.dart';
import 'package:freud_ai/configs/database/database_helper.dart';
import 'package:freud_ai/screens/sleep/model/sleep_model.dart';
import 'package:sqflite/sqlite_api.dart';

class SleepDataResources {
  Database database;

  SleepDataResources(this.database);

  /// Add sleep to the Database
  Future<void> addSleepToTheDatabase(SleepModel model) async {
    AppInfoBloc appInfoBloc = AppInfoBloc();

    createSleepTable();

    int? alreadySavedId = await checkIfSleepAlreadyAdded(model);


    log("PrintedDataId :: $alreadySavedId");


    try {
      if (alreadySavedId != null) {

       /// print("printedTimeStampUpdate:: ${model.toString()}");

        await database.update(
          Constants.sleepTableName,
          model.toJson(),
          where: 'id = ?',
          whereArgs: [alreadySavedId],
        );
      } else {

       /// print("printedTimeStampInsert :: ${model.toString()}");

        await database.insert(Constants.sleepTableName, model.toJson());

        Constants.completeAppInfoModel =
            Constants.completeAppInfoModel!.copyWith(isSleepQualityAdded: true);

        appInfoBloc.add(UpdateAppInfoEvent(Constants.completeAppInfoModel!));

      }
    } catch (e, st) {
      log("Error in addSleepToTheDatabase: $e :: $st");
    }
  }

  /// Get stored sleeps
  Future<List<SleepModel>?> getStoredSleeps() async {
    if (await databaseHelper.isTableExist(Constants.sleepTableName)) {
      List<Map<String, dynamic>> results =
          await database.query(Constants.sleepTableName);

      if (results.isNotEmpty) {
        List<SleepModel> sleeps = results.map((result) {
          return SleepModel.fromJson(result);
        }).toList();

        return sleeps;
      }
    } else {
      return null;
    }
    return null;
  }

  /// Create Sleep Table
  void createSleepTable() async {
    const String tableName = Constants.sleepTableName;
    const String columnId = 'id';
    const String sleepAt = 'sleepAt';
    const String wokeUpAt = 'wokeUpAt';
    const String graceSleepPeriod = 'graceSleepPeriod';
    const String selectedDaysList = 'selectedDaysList';
    const String isRepeatDaily = 'isRepeatDaily';
    const String autoSetAlarm = 'autoSetAlarm';
    const String saveDateTime = 'saveDateTime';

    try {
      await database.execute('''
        CREATE TABLE IF NOT EXISTS $tableName (
          $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
          $sleepAt TEXT,
          $wokeUpAt TEXT,
          $graceSleepPeriod TEXT,
          $selectedDaysList TEXT,
          $isRepeatDaily INTEGER,
          $autoSetAlarm INTEGER,
          $saveDateTime TEXT
        )
      ''');
    } catch (e, st) {
      log("Error in createSleepTable: $e , $st");
    }
  }

  /// Checks if the BMI data for a particular date is already added to the database.
  Future<int?> checkIfSleepAlreadyAdded(SleepModel bmiModel) async {
    SleepModel? listOfBMIs = await getStoredSleepSchedule();

    if (listOfBMIs != null) {
      return listOfBMIs.id;
    }

    return null;
  }

  /// Here we will get the stored sleep schedule data from the database.
  Future<SleepModel?> getStoredSleepSchedule() async {
    if (await databaseHelper.isTableExist(Constants.sleepTableName)) {
      List<Map<String, dynamic>> results =
          await database.query(Constants.sleepTableName);

      if (results.isNotEmpty) {

        /// Assuming there's only one entry, so fetch the first one
        Map<String, dynamic> result = results.first;
        return SleepModel.fromJson(result);
      }
    }
    return null;
  }
}
