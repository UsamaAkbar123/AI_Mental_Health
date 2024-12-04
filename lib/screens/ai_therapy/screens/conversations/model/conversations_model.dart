import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:freud_ai/screens/ai_therapy/screens/inbox/model/chat_model.dart';

class ConversationsModel extends Equatable {
  final int? id;
  final String? chatTitle;
  final String? chatLogo;
  final String? aiTherapyIcon;
  final String? totalChatCount;
  final String? userMoodInChat;
  final String? chatType;
  final String? timeStamp;
  final bool? isFavorite;
  final String? botSystemPrompt;
  final List<ChatInboxModel>? listOfChat;

  const ConversationsModel({
    this.id,
    this.chatTitle,
    this.chatLogo,
    this.aiTherapyIcon,
    this.totalChatCount,
    this.userMoodInChat,
    this.chatType,
    this.timeStamp,
    this.isFavorite,
    this.botSystemPrompt,
    this.listOfChat,
  });

  factory ConversationsModel.fromJson(Map<String, dynamic> json) {
    return ConversationsModel(
      id: json['id'],
      chatTitle: json['chatTitle'],
      chatLogo: json['chatLogo'],
      aiTherapyIcon: json['aiTherapyIcon'],
      totalChatCount: json['totalChatCount'],
      userMoodInChat: json['userMoodInChat'],
      chatType: json['chatType'],
      timeStamp: json['timeStamp'],
      botSystemPrompt: json['botSystemPrompt'],
      isFavorite: json['isFavorite'] == "1" ? true : false,
      listOfChat: json['listOfChat'] != null
          ? List<ChatInboxModel>.from(jsonDecode(json['listOfChat'])
              .map((e) => ChatInboxModel.fromJson(e)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatTitle': chatTitle,
      'chatLogo': chatLogo,
      'aiTherapyIcon': aiTherapyIcon,
      'totalChatCount': totalChatCount,
      'userMoodInChat': userMoodInChat,
      'chatType': chatType,
      'timeStamp': timeStamp,
      'botSystemPrompt': botSystemPrompt,
      'isFavorite': isFavorite! ? "1" : "0",
      'listOfChat': jsonEncode(listOfChat),
    };
  }

  ConversationsModel copyWith({
    int? id,
    String? chatTitle,
    String? chatLogo,
    String? aiTherapyIcon,
    String? totalChatCount,
    String? userMoodInChat,
    String? chatType,
    String? timeStamp,
    bool? isFavorite,
    String? botSystemPrompt,
    List<ChatInboxModel>? listOfChat,
  }) {
    return ConversationsModel(
      id: id ?? this.id,
      chatTitle: chatTitle ?? this.chatTitle,
      chatLogo: chatLogo ?? this.chatLogo,
      aiTherapyIcon: aiTherapyIcon ?? this.aiTherapyIcon,
      totalChatCount: totalChatCount ?? this.totalChatCount,
      userMoodInChat: userMoodInChat ?? this.userMoodInChat,
      chatType: chatType ?? this.chatType,
      timeStamp: timeStamp ?? this.timeStamp,
      isFavorite: isFavorite ?? this.isFavorite,
      listOfChat: listOfChat ?? this.listOfChat,
      botSystemPrompt: botSystemPrompt ?? this.botSystemPrompt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        chatTitle,
        chatLogo,
        aiTherapyIcon,
        totalChatCount,
        userMoodInChat,
        chatType,
        timeStamp,
        isFavorite,
        listOfChat,
        botSystemPrompt
      ];
}