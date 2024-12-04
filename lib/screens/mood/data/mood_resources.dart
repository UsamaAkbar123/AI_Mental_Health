import 'dart:developer';

import 'package:freud_ai/application/bloc/app_info_bloc.dart';
import 'package:freud_ai/application/bloc/app_info_event.dart';
import 'package:freud_ai/configs/constants/constants.dart';
import 'package:freud_ai/configs/database/database_helper.dart';
import 'package:freud_ai/screens/mood/model/mood_model.dart';
import 'package:sqflite/sqlite_api.dart';


class MoodDataResources {

  Database database;

  MoodDataResources(this.database);


  ///Add Mood to The Database
  Future<void> addMoodToTheDatabase(MoodModel model) async {
    AppInfoBloc appInfoBloc = AppInfoBloc();

    createMoodTable();

    int? alreadySavedId = await checkIfMoodAlreadyExist(model);

    try {
      if (alreadySavedId != null) {
        await database.update(
          Constants.moodTableName,
          model.toJson(),
          where: 'id = ?',
          whereArgs: [alreadySavedId],
        );
      } else {
        await database.insert(Constants.moodTableName, model.toJson());

        Constants.completeAppInfoModel = Constants.completeAppInfoModel!
            .copyWith(isMoodTrackerStarted: true);

        appInfoBloc.add(UpdateAppInfoEvent(Constants.completeAppInfoModel!));
      }
    } catch (e, st) {
      log("Error in addBMIToTheDatabase: $e  :: $st");
    }
  }


  /// delete mood by id
  Future<void> deleteMoodBYId(String id) async{
    // Delete the item from the database.
    try{
      await database.delete(
        Constants.moodTableName, // Table name
        where: 'moodTimeStamp = ?', // Condition for deletion
        whereArgs: [id], // Arguments to the condition
      );
    }catch(e){
      log("exception of deleting mood: $e");
    }
  }

  /// Checks if the Mood data for a particular date is already added to the database.
  Future<int?> checkIfMoodAlreadyExist(MoodModel bmiModel) async {
    List<MoodModel>? listOfBMIs = await getStoredMoods();

    if (listOfBMIs != null) {
      if (bmiModel.moodTimeStamp == listOfBMIs.last.moodTimeStamp) {
        return listOfBMIs.last.id!;
      }
    }

    return null;
  }

  /// Here we will get the Mood history
  Future<List<MoodModel>?> getStoredMoods() async {
    if ((await databaseHelper.isTableExist(Constants.moodTableName))) {
      List<Map<String, dynamic>> results =
      await database.query(Constants.moodTableName);

      if (results.isNotEmpty) {

        List<MoodModel> questions = results.map((result) {
          return MoodModel.fromJson(result);
        }).toList();

        return questions;
      }
    } else {
      return null;
    }
    return null;
  }






  ///Create Mood Table
  void createMoodTable() async {
    const String tableName = Constants.moodTableName;
    const String columnId = 'id';
    const String moodName = 'moodName';
    const String moodEmoji = 'moodEmoji';
    const String moodDate = 'moodDate';
    const String moodTimeStamp = 'moodTimeStamp';
    const String moodQuotation = 'moodQuotation';

    try {
      await database.execute('''
        CREATE TABLE IF NOT EXISTS $tableName (
          $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
          $moodName TEXT,
          $moodEmoji TEXT,
          $moodDate TEXT,
          $moodTimeStamp TEXT,
          $moodQuotation TEXT
        )
      ''');

    } catch (e, st) {
      log("Error in createMoodTable: $e , $st");
    }
  }

}
