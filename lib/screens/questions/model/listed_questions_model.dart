class QuestionsModel {
  String? userGoal;
  String? mainQuestion;
  String? featureName;
  String? questionAnimation;
  bool? isSelectMultiple;
  List<String>? userSelectedAnswer;
  List<QuestionsModelList>? listOfAnswers;

  QuestionsModel(
      {this.mainQuestion,
      this.userSelectedAnswer,
      this.listOfAnswers,
      this.featureName,
      this.userGoal,
      this.isSelectMultiple,
      this.questionAnimation});
}

class QuestionsModelList {
  String? itemIcon;
  bool? isSelected;
  String? itemSubText;
  String? questionText;
  String? questionSubText;

  QuestionsModelList(
      {this.itemIcon,
      this.itemSubText,
      this.questionSubText,
      this.isSelected,
      this.questionText});
}
