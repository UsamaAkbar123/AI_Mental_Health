import 'package:freud_ai/configs/constants/constants.dart';
import 'package:freud_ai/configs/database/database_helper.dart';
import 'package:freud_ai/screens/ai_therapy/screens/conversations/model/conversations_model.dart';
import 'package:sqflite/sqlite_api.dart';

class ChatDataResources {
  Database database;

  ChatDataResources(this.database);

  ///This Method Will Call Only when user start Chat first time
  Future<ConversationsModel?> createRecentTableAndAddFirstMessage({ConversationsModel? model, tableName}) async {
    await createChatTable(tableName);

    /// Insert data into the table
    await database.insert(tableName, model!.toJson());

    return await getRecentMessage(tableName: tableName);

  }





  Future<ConversationsModel?> getRecentMessage({String? tableName}) async {
    List<Map<String, dynamic>> results = await database.query(
      tableName!,
      orderBy: 'timestamp DESC', // replace 'timestamp_column_name' with your actual timestamp column name
      limit: 1, // Retrieve only the latest message
    );

    if (results.isNotEmpty) {
      // Assuming your model has a factory method named fromJson
      return ConversationsModel.fromJson(results.first);
    } else {
      return null; // No recent messages found
    }
  }














  ///This Method will call only when user Delete the Chat
  Future<void> createTrashTableAndAddChat(
      {ConversationsModel? model, tableName}) async {
    await createChatTable(tableName);

    /// Insert data into the table
    await database.insert(tableName, model!.toJson());
  }

  ///This Method will call when user start chat after first message
  Future<void> addChatToTrash({ConversationsModel? model, tableName}) async {
    /// Retrieve existing chat history from the database
    ConversationsModel? existingChatHistory = await getChatHistory(tableName);

    /// Update the database record with the modified chat history
    await updateChatHistory(tableName, existingChatHistory!);
  }

  /// Create the table if not exists
  Future<void> createChatTable(String tableName) async {
    if (!(await databaseHelper.isTableExist(tableName))) {
      await database.execute('''
      CREATE TABLE $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        chatTitle TEXT,
        chatLogo TEXT,
        aiTherapyIcon TEXT,
        botSystemPrompt TEXT,
        totalChatCount TEXT,
        userMoodInChat TEXT,
        chatType TEXT,
        timestamp TEXT,
        isFavorite INTEGER,
        listOfChat TEXT
      )
    ''');
    }
  }


  ///This Method will call when user start chat after first message
  Future<void> addChatMessageToDatabase({ConversationsModel? model, tableName}) async {
    /// Retrieve existing chat history from the database


    /// Update the database record with the modified chat history
    await updateChatHistory(tableName, model!);


  }





  /// Here we will get the ChatHistory
  Future<ConversationsModel?> getChatHistory(String tableName) async {
    if ((await databaseHelper.isTableExist(tableName))) {
      List<Map<String, dynamic>> results = await database.query(tableName);
      if (results.isNotEmpty) {
        return ConversationsModel.fromJson(results.last);
      }
      return null;
    } else {
      return null;
    }
  }

  ///Here  we will Update the Chat History
  Future<void> updateChatHistory(
      String tableName, ConversationsModel chatHistory) async {
    await database.update(
      tableName,
      chatHistory.toJson(),
      where: 'id = ?',
      whereArgs: [chatHistory.id],
    );
  }

  ///Get The Conversation List (Chat History)
  Future<List<ConversationsModel>> getChatHistoryList(
      {String? tableName}) async {
    if ((await databaseHelper.isTableExist(tableName!))) {
      List<Map<String, dynamic>> results = await database.query(tableName);
      List<ConversationsModel> chatHistoryList = [];

      for (var result in results) {
        chatHistoryList.add(ConversationsModel.fromJson(result));
      }

      return chatHistoryList;
    } else {
      return [];
    }
  }

  /// Delete the Conversation
  Future<void> deleteTheConversation(
      {String? tableName,
      ConversationsModel? chatHistoryModel,
    required bool isFromRecent,
    required bool isDeleteChatPermanently,
  }) async {
    await database.delete(
      tableName!,
      where: 'id = ?',
      whereArgs: [chatHistoryModel!.id],
    );

    /// Is From Recent
    if (isFromRecent) {
      await createTrashTableAndAddChat(
        model: chatHistoryModel,
        tableName: Constants.trashTableName,
      );
    }

    if (isDeleteChatPermanently == false) {
      await createRecentTableAndAddFirstMessage(
        model: chatHistoryModel,
        tableName: Constants.chatTableName,
      );
    }
  }
}
