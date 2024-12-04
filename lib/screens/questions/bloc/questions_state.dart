import 'package:freud_ai/screens/questions/model/question_summary_model.dart';

///For Now not using this ... but in future
enum QuestionStatus { initial, loading, loaded, error }

abstract class QuestionState {
  QuestionStatus questionStatus = QuestionStatus.initial;
}


///Question Initial State
class QuestionInitialState extends QuestionState {}


///Goal Completion state,
class GoalCompletionState extends QuestionState {
  final List<QuestionSummaryModel> listOfQuestionSummaryModel;
  GoalCompletionState({required this.listOfQuestionSummaryModel});
}


///Answer Updated Event, when user press continue button
class AnswersUpdatedState extends QuestionState {
  final List<QuestionSummaryModel> listOfQuestionSummaryModel;
  AnswersUpdatedState({required this.listOfQuestionSummaryModel});

}



///Answer Selected Event
class AnswerSelectedState extends QuestionState {
  QuestionSummaryModel questionSummaryModel;

  AnswerSelectedState({required this.questionSummaryModel});
}




