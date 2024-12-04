import 'package:bloc/bloc.dart';
import 'package:freud_ai/configs/constants/constants.dart';
import 'package:freud_ai/configs/database/database_helper.dart';
import 'package:freud_ai/screens/ai_therapy/bloc/conversation_event.dart';
import 'package:freud_ai/screens/ai_therapy/bloc/conversation_state.dart';
import 'package:freud_ai/screens/ai_therapy/data/data_resource.dart';
import 'package:freud_ai/screens/ai_therapy/screens/conversations/model/conversations_model.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  int? currentChatId;
  List<ConversationsModel> listOfChatHistoryModel = [];
  List<ConversationsModel> listOfTrashChatHistory = [];

  ConversationBloc() : super(ConversationState.initial()) {
    on<ChatSendMessageEvent>(_onSendMessage);
    on<ChatCreateTableEvent>(_onCreateChatEvent);
    on<GetConversationEvent>(_getConversationEvent);
    on<DeleteTrashConversationEvent>(_deleteTrashConversation);
    on<DeleteConversationEvent>(_deleteConversation);
  }

  ///This message will call when send message press
  void _onSendMessage(
      ChatSendMessageEvent event, Emitter<ConversationState> emit) async {
    final database = await databaseHelper.database;

    await ChatDataResources(database).addChatMessageToDatabase(
        model: event.conversationsModel!, tableName: Constants.chatTableName);
  }

  /// This Message will call when user Create Chat Model
  _onCreateChatEvent(
      ChatCreateTableEvent event, Emitter<ConversationState> emit) async {
    final database = await databaseHelper.database;

    ConversationsModel? conversationsModel = await ChatDataResources(database)
        .createRecentTableAndAddFirstMessage(
            model: event.conversationsModel,
            tableName: Constants.chatTableName);

    currentChatId = conversationsModel!.id;
  }

  /// This Message will call when user Create Chat Model
  _deleteConversation(
      DeleteConversationEvent event, Emitter<ConversationState> emit) async {
    final database = await databaseHelper.database;

    await ChatDataResources(database).deleteTheConversation(
        tableName: Constants.chatTableName,
        chatHistoryModel: event.chatModel,
      isFromRecent: true,
      isDeleteChatPermanently: true,
    );

    listOfChatHistoryModel.remove(event.chatModel);
    listOfTrashChatHistory.add(event.chatModel);


    emit(state.copyWith(
        status: ConversationStatus.loaded,
        listOfChatHistoryModel:
            List<ConversationsModel>.from(listOfChatHistoryModel),
        listOfTrashChatHistory:
            List<ConversationsModel>.from(listOfTrashChatHistory)));

    add(GetConversationEvent());
  }

  /// This Message will call when user Create Chat Model
  _deleteTrashConversation(DeleteTrashConversationEvent event,
      Emitter<ConversationState> emit) async {
    final database = await databaseHelper.database;

    await ChatDataResources(database).deleteTheConversation(
        tableName: Constants.trashTableName,
        chatHistoryModel: event.chatModel,
      isFromRecent: false,
      isDeleteChatPermanently: event.isDeleteChatPermanently,
    );

    listOfTrashChatHistory.remove(event.chatModel);

    emit(state.copyWith(
        status: ConversationStatus.loaded,
        listOfChatHistoryModel:
            List<ConversationsModel>.from(listOfChatHistoryModel),
        listOfTrashChatHistory:
            List<ConversationsModel>.from(listOfTrashChatHistory)));

    add(GetConversationEvent());
  }

  /// Get the conversation Event
  _getConversationEvent(GetConversationEvent getConversationEvent,
      Emitter<ConversationState> emit) async {
    emit(state.copyWith(status: ConversationStatus.loading));

    final database = await databaseHelper.database;

    List<ConversationsModel> chatHistoryModelList =
        await ChatDataResources(database)
            .getChatHistoryList(tableName: Constants.chatTableName);

    List<ConversationsModel> chatTrashModelList =
        await ChatDataResources(database)
            .getChatHistoryList(tableName: Constants.trashTableName);

    listOfChatHistoryModel = chatHistoryModelList;
    listOfTrashChatHistory = chatTrashModelList;

    emit(state.copyWith(
        status: ConversationStatus.loaded,
        listOfChatHistoryModel:
            List<ConversationsModel>.from(listOfChatHistoryModel),
        listOfTrashChatHistory:
            List<ConversationsModel>.from(listOfTrashChatHistory)));
  }
}