import 'package:freud_ai/screens/questions/model/question_summary_model.dart';

abstract class QuestionEvent {}


///Answer Selected Event
class AnswerSelectedEvent extends QuestionEvent {
  final QuestionSummaryModel questionSummaryModel;
  AnswerSelectedEvent({required this.questionSummaryModel});
}


///Answer Updated Event
class AnswerUpdatedEvent extends QuestionEvent {
  final QuestionSummaryModel questionSummaryModel;
  AnswerUpdatedEvent({required this.questionSummaryModel});
}

/// Initial question state event
class InitialQuestionEvent extends QuestionEvent {}

///Goal Completion Event
class GoalCompletionEvent extends QuestionEvent {}
