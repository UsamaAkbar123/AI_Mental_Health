class SelectedConversationModel {
  String? selectedBot;
  String? selectedAvatar;
  String? systemPrompt;
  String? aiTherapyIcon;

  SelectedConversationModel({
    this.selectedBot,
    this.selectedAvatar,
    this.systemPrompt,
    this.aiTherapyIcon,
  });

  ///use this method to make a copy  of the previous model
  SelectedConversationModel copyWith({
    String? selectedBot,
    String? selectedAvatar,
    String? systemPrompt,
    String? aiTherapyIcon,
  }) {
    return SelectedConversationModel(
      selectedBot: selectedBot ?? this.selectedBot,
      selectedAvatar: selectedAvatar ?? this.selectedAvatar,
      systemPrompt: systemPrompt ?? this.systemPrompt,
      aiTherapyIcon: aiTherapyIcon ?? this.aiTherapyIcon,
    );
  }
}
