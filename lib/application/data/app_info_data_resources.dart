import 'dart:developer';

import 'package:freud_ai/application/app_info_model.dart';
import 'package:freud_ai/configs/constants/constants.dart';
import 'package:freud_ai/configs/database/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class AppInfoDataResources {
  Database database;

  AppInfoDataResources(this.database);

  /// Here we will get the Complete app info
  Future<CompleteAppInfoModel?> getAppInfo() async {

    if ((await databaseHelper.isTableExist(Constants.completeAppInfoTableName))) {

      List<Map<String, dynamic>> results = await database.query(Constants.completeAppInfoTableName);

      if (results.isNotEmpty) {
        log("NotEmptyCalling :: ${results.toString()}");
        CompleteAppInfoModel completeAppInfoModel = CompleteAppInfoModel.fromJson(results.first);
        log("NotEmptyCalling :: ${completeAppInfoModel.isStepCounterGoalSet}");
        return completeAppInfoModel;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  ///Here we will insert or Update AppInfo
  Future<void> insertOrUpdateAppInfo(CompleteAppInfoModel appInfoModel) async {

    await createTableQuery();



    try {
      int? count = Sqflite.firstIntValue(await database.rawQuery(
        'SELECT COUNT(*) FROM ${Constants.completeAppInfoTableName} WHERE id = 1',
      ));

      if (count != null && count > 0) {
        await database.update(
          Constants.completeAppInfoTableName,
          appInfoModel.toJson(),
          where: 'id = 1',
        );

        log("CompleteAppInfoModelCheckValues 2:: ${appInfoModel.isStepCounterGoalSet}");

      } else {
        await database.insert(
          Constants.completeAppInfoTableName,
          appInfoModel.toJson(),
        );

        log("CompleteAppInfoModelCheckValues 3:: ${appInfoModel.isStepCounterGoalSet}");


      }
    } catch (e, st) {
      log("Error in insertOrUpdateStepGoal: $e  :: $st");
    }
  }

  ///Create Table
  createTableQuery() async {
    const String colId = 'id';
    const String colStepCounterGoalSet = 'isStepCounterGoalSet';
    const String colBMISetupComplete = 'isBMISetupComplete';
    const String colRoutinePlannerCreated = 'isRoutinePlannerCreated';
    const String colConversationStated = 'isConversationStated';
    const String colSleepQualityAdded = 'isSleepQualityAdded';
    const String colMoodTrackerStarted = 'isMoodTrackerStarted';
    const String isPersonalInformationSet = 'isPersonalInformationSet';

    if (!(await databaseHelper
        .isTableExist(Constants.completeAppInfoTableName))) {
      try {
        await database.execute('''
    CREATE TABLE ${Constants.completeAppInfoTableName} (
      $colId INTEGER PRIMARY KEY AUTOINCREMENT,
      $colStepCounterGoalSet INTEGER,
      $colBMISetupComplete INTEGER,
      $colRoutinePlannerCreated INTEGER,
      $colConversationStated INTEGER,
      $colSleepQualityAdded INTEGER,
      $colMoodTrackerStarted INTEGER,
      $isPersonalInformationSet INTEGER
    )
  ''');
      } catch (e) {
        ///TODO IMPLEMENTATION
      }
    }
  }
}
