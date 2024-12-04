class ChatInboxModel {
  bool? isReceived;
  String? question;
  String? timeStamp;
  StringBuffer? answer;
  String? botPrompt;
  String? botName;
  String? conversationAvatar;
  String? aiTherapyIcon;

  ChatInboxModel(
      {this.answer,
      this.isReceived,
      this.question,
      this.timeStamp,
      this.botPrompt,
      this.botName,
      this.conversationAvatar,
      this.aiTherapyIcon});

  /// Convert the object to a JSON representation
  Map<String, dynamic> toJson() {
    return {
      'isReceived': isReceived! ? "1" : "0",
      'question': question,
      'message': answer?.toString(),
      'timeStamp': timeStamp,
      'botPrompt': botPrompt,
      'botName': botName,
      'conversationAvatar': conversationAvatar,
      'aiTherapyIcon': aiTherapyIcon,
      /// Convert StringBuffer to String
    };
  }

  /// Create an object from a JSON representation
  factory ChatInboxModel.fromJson(Map<String, dynamic> json) {
    return ChatInboxModel(
      isReceived: json['isReceived'] == "1" ? true : false,
      question: json['question'],
      timeStamp: json['timeStamp'],
      botPrompt: json['botPrompt'],
      botName: json['botName'],
      conversationAvatar: json['conversationAvatar'],
      aiTherapyIcon: json['aiTherapyIcon'],
      answer: json['message'] != null
          ? StringBuffer(json['message'])
          : StringBuffer(""),
    );
  }

  /// Create a copy of the object with optional modifications
  ChatInboxModel copyWith(
      {bool? isReceived,
      String? question,
      String? timeStamp,
      String? botPrompt,
      String? botName,
      String? conversationAvatar,
        String? aiTherapyIcon,
      StringBuffer? answer}) {
    return ChatInboxModel(
      isReceived: isReceived ?? this.isReceived,
      question: question ?? this.question,
      timeStamp: timeStamp ?? this.timeStamp,
      botPrompt: botPrompt ?? this.botPrompt,
      botName: botName ?? this.botName,
      conversationAvatar: conversationAvatar ?? this.conversationAvatar,
      aiTherapyIcon: aiTherapyIcon ?? this.aiTherapyIcon,
      answer: answer != null ? StringBuffer(answer.toString()) : this.answer,
    );
  }
}
