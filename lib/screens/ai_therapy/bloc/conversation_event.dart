import 'package:equatable/equatable.dart';
import 'package:freud_ai/screens/ai_therapy/screens/conversations/model/conversations_model.dart';

///Main Abstract Chat Event
abstract class ConversationEvent extends Equatable {}

///Add Message Event
class ChatSendMessageEvent extends ConversationEvent {
  final ConversationsModel? conversationsModel;

  ChatSendMessageEvent({required this.conversationsModel});

  @override
  List<Object?> get props => [conversationsModel];
}



///Create Chat Event
class ChatCreateTableEvent extends ConversationEvent {
  final ConversationsModel conversationsModel;

  ChatCreateTableEvent({required this.conversationsModel});

  @override
  List<Object?> get props => [conversationsModel];
}

///Delete Recent Conversation
class DeleteConversationEvent extends ConversationEvent {
  final ConversationsModel chatModel;

  DeleteConversationEvent({required this.chatModel});

  @override
  List<Object?> get props => [chatModel];
}

///Delete Trash Conversation
class DeleteTrashConversationEvent extends ConversationEvent {
  final bool isDeleteChatPermanently;
  final ConversationsModel chatModel;

  DeleteTrashConversationEvent({
    required this.chatModel,
    required this.isDeleteChatPermanently,
  });

  @override
  List<Object?> get props => [chatModel];
}

///Here we will get all  the conversation
class GetConversationEvent extends ConversationEvent {
  @override
  List<Object?> get props => throw UnimplementedError();
}
