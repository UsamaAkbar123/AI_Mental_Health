import 'package:equatable/equatable.dart';
import 'package:freud_ai/screens/ai_therapy/screens/conversations/model/conversations_model.dart';

enum ConversationStatus { initial, loading, loaded, error }

class ConversationState extends Equatable {
  final ConversationStatus? status;
  final List<ConversationsModel>? listOfChatHistoryModel;
  final List<ConversationsModel>? listOfTrashChatHistory;

  const ConversationState(
      {this.listOfChatHistoryModel, this.listOfTrashChatHistory, this.status});

  ///Conversation State for initial data
  static ConversationState initial() => const ConversationState(
      status: ConversationStatus.initial,
      listOfTrashChatHistory: [],
      listOfChatHistoryModel: []);

  /// This method will only change the copy with method.
  ConversationState copyWith(
      {ConversationStatus? status,
      List<ConversationsModel>? listOfChatHistoryModel,
      List<ConversationsModel>? listOfTrashChatHistory}) {
    return ConversationState(
      status: status ?? this.status,
      listOfChatHistoryModel:
          listOfChatHistoryModel ?? this.listOfChatHistoryModel,
      listOfTrashChatHistory:
          listOfTrashChatHistory ?? this.listOfTrashChatHistory,
    );
  }

  ///Props Functions
  @override
  List<Object?> get props => [listOfChatHistoryModel, listOfTrashChatHistory];
}
