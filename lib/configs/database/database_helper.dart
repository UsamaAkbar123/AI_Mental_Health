import 'dart:developer';

import 'package:freud_ai/configs/constants/constants.dart';
import 'package:freud_ai/screens/ai_therapy/screens/conversations/model/conversations_model.dart';
import 'package:freud_ai/screens/questions/model/question_summary_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final DatabaseHelper databaseHelper = DatabaseHelper.instance;

class DatabaseHelper {
  static const _databaseName = "mentalHealthDatabase.db";
  static const _databaseVersion = 1;

  static const columnGoals = 'selectedGoal';
  static const columnQuestions = 'question';
  static const columnFeatureNames = 'featureName';
  static const columnAnswersList = 'answersList';

  /// Make this a singleton class
  DatabaseHelper._privateConstructor();


  static final DatabaseHelper _instance = DatabaseHelper._privateConstructor();



  static DatabaseHelper get instance => _instance;




  /// Only have a single app-wide reference to the database
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }




  /// This opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);

    return await openDatabase(path, version: _databaseVersion,
        onCreate: (db, version) async {
      await db.execute('''
          CREATE TABLE IF NOT EXISTS ${Constants.goalTableName} (
            $columnGoals TEXT ,
            $columnFeatureNames TEXT ,
            $columnQuestions TEXT ,
            $columnAnswersList TEXT
          )
      ''');
    });
  }





  /// Create the instance of the database
  createTheInstanceOfDatabase() async {
    await _instance.database;
  }



  ///Here we will check the table Exist or not
  Future<bool> isTableExist(String tableName) async {
    var result = await _database!.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name='$tableName'",
    );
    return result.isNotEmpty;
  }





  /// Insert Questions
  Future<void> insertQuestions({List<QuestionSummaryModel>? questions, tableName}) async {
    await _database!.transaction((transaction) async {
      for (QuestionSummaryModel question in questions!) {
        Map<String, dynamic> questionMap = question.toJson();
        await transaction.insert(tableName, questionMap);
      }
    });
  }





  /// Get the List of Questions
  Future<List<ConversationsModel>> getQuestions(String tableName) async {
    List<Map<String, dynamic>> results = await _database!.query(Constants.goalTableName);
    List<ConversationsModel> questions = results.map((result) {
      return ConversationsModel.fromJson(result);
    }).toList();

    return questions;

  }





  /// Print database content
  printDataBase() async {
    List<ConversationsModel> fetchedQuestions =
        await databaseHelper.getQuestions(Constants.chatTableName);

    log("==================================  Database Print ===========================");


    databaseHelper.isTableExist(Constants.chatTableName);


    log(fetchedQuestions.toString());

    log("==================================  Database Print ===========================");
  }
}
