import 'dart:developer';

import 'package:freud_ai/application/bloc/app_info_bloc.dart';
import 'package:freud_ai/application/bloc/app_info_event.dart';
import 'package:freud_ai/configs/constants/constants.dart';
import 'package:freud_ai/configs/database/database_helper.dart';
import 'package:freud_ai/screens/bmi/model/bmi_model.dart';
import 'package:sqflite/sqlite_api.dart';

class BMIDataResources {
  Database database;

  BMIDataResources(this.database);

  /// Here we will get the stored BMI data from the database.
  Future<List<AddBMIModel>?> getStoredBMIs() async {
    if (await databaseHelper.isTableExist(Constants.bmiTableName)) {
      List<Map<String, dynamic>> results =
      await database.query(Constants.bmiTableName);

      if (results.isNotEmpty) {
        List<AddBMIModel> bmiList = results.map((result) {

          return AddBMIModel.fromJson(result);
        }).toList();

        return bmiList;
      }
    } else {
      return null;
    }
    return null;
  }


  /// delete bmi by id
  Future<void> deleteBmiBYId(String id) async{
    // Delete the item from the database.
    await database.delete(
      Constants.bmiTableName, // Table name
      where: 'bmiTimeStamp = ?', // Condition for deletion
      whereArgs: [id], // Arguments to the condition
    );
  }




  /// In this method we will add BMI data to the database.
  Future<void> addBMIToTheDatabase(AddBMIModel model) async {
    AppInfoBloc appInfoBloc = AppInfoBloc();


    await _createBMITable();


    int? alreadySavedId = await checkIsBMIAlreadyAdded(model);



    try {
      if (alreadySavedId !=null) {
        await database.update(
          Constants.bmiTableName,
          model.toJson(),
          where: 'id = ?',
          whereArgs: [alreadySavedId],
        );
      } else {
        await database.insert(Constants.bmiTableName, model.toJson());
        Constants.completeAppInfoModel = Constants.completeAppInfoModel!
            .copyWith(isBMISetupComplete: true);

        appInfoBloc.add(UpdateAppInfoEvent(Constants.completeAppInfoModel!));
      }
    } catch (e, st) {
      log("Error in addBMIToTheDatabase: $e  :: $st");
    }
  }





  /// Checks if the BMI data for a particular date is already added to the database.
  Future<int?> checkIsBMIAlreadyAdded(AddBMIModel bmiModel) async {
    List<AddBMIModel>? listOfBMIs = await getStoredBMIs();

    if (listOfBMIs != null) {
      if (bmiModel.dateBMI == listOfBMIs.last.dateBMI) {

        return listOfBMIs.last.id!;
      }
    }

    return null;
  }





  /// Creates the BMI table if it doesn't exist.
  Future<void> _createBMITable() async {
    const String tableName = Constants.bmiTableName;

    /// Define column names
    const String columnId = 'id';
    const String bmiHeight = 'bmiHeight';
    const String bmiWeight = 'bmiWeight';
    const String heightSymbol = 'heightSymbol';
    const String weightSymbol = 'weightSymbol';
    const String bmiScore = 'bmiScore';
    const String dateBMI = 'dateBMI';
    const String bmiStatus = 'bmiStatus';
    const String bmiTimeStamp = 'bmiTimeStamp';




    try {
      await database.execute('''
        CREATE TABLE IF NOT EXISTS $tableName (
          $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
          $bmiHeight TEXT,
          $bmiWeight TEXT,
          $heightSymbol TEXT,
          $weightSymbol TEXT,
          $bmiScore TEXT,
          $dateBMI TEXT,
          $bmiStatus TEXT,
          $bmiTimeStamp TEXT
        )
      ''');
    } catch (e, st) {
      log("Error in createBMITable: $e , $st");
    }
  }
}
