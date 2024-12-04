import 'package:freud_ai/application/bloc/app_info_bloc.dart';
import 'package:freud_ai/application/bloc/app_info_event.dart';
import 'package:freud_ai/configs/constants/constants.dart';
import 'package:freud_ai/configs/database/database_helper.dart';
import 'package:freud_ai/screens/personal_information/model/personal_information_model.dart';
import 'package:sqflite/sqlite_api.dart';

class PersonalInformationDataResources {
  Database database;

  PersonalInformationDataResources(this.database);

  /// Here we will get the stored personal information from the database.
  Future<PersonalInformationModel?> getStoredPersonalInformation() async {
    if (await databaseHelper.isTableExist(Constants.personalInformationTableName)) {

      List<Map<String, dynamic>> results =
      await database.query(Constants.personalInformationTableName);

      if (results.isNotEmpty) {
        /// Assuming you're only interested in the first row
        return PersonalInformationModel.fromJson(results.first);
      }


    }
    return null;
  }

  /// Update personal information in the database.
  Future<void> updatePersonalInformation(PersonalInformationModel updatedInfo) async {
    await database.update(
      Constants.personalInformationTableName,
      updatedInfo.toJson(),
      where: 'id = ?',
      whereArgs: [1], // Assuming you're updating the first row
    );
  }

  /// Add new personal information to the database.
  Future<void> addPersonalInformation(PersonalInformationModel newInfo) async {

    await _createTable();


    AppInfoBloc appInfoBloc = AppInfoBloc();

    Constants.completeAppInfoModel = Constants.completeAppInfoModel!
        .copyWith(isPersonalInformationSet: true);


    appInfoBloc.add(UpdateAppInfoEvent(Constants.completeAppInfoModel!));

    await database.insert(
      Constants.personalInformationTableName,
      newInfo.toJson(),
    );
  }



  ///Create Table
  Future<void> _createTable() async {
    await database.execute('''
      CREATE TABLE IF NOT EXISTS ${Constants.personalInformationTableName} (
        id INTEGER PRIMARY KEY,
        name TEXT,
        gender TEXT,
        dateOfBirth TEXT,
        dateOfBirthStamp TEXT,
        selectedAvatar TEXT
      )
    ''');
  }
}
