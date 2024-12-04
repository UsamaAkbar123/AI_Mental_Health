import 'package:bloc/bloc.dart';
import 'package:freud_ai/configs/constants/constants.dart';
import 'package:freud_ai/configs/database/database_helper.dart';
import 'package:freud_ai/screens/questions/bloc/questions_event.dart';
import 'package:freud_ai/screens/questions/bloc/questions_state.dart';
import 'package:freud_ai/screens/questions/model/question_summary_model.dart';

class QuestionBloc extends Bloc<QuestionEvent, QuestionState> {

  List<QuestionSummaryModel> questions = [];
  QuestionSummaryModel? questionSummaryModel;

  QuestionBloc() : super(QuestionInitialState()) {

    on<AnswerSelectedEvent>(_answerSelected);

    on<AnswerUpdatedEvent>(_answerUpdated);

    on<GoalCompletionEvent>(_goalCompletionEvent);

    on<InitialQuestionEvent>(_initialQuestion);

  }

  ///We will Update the user Selected Answer
  void _initialQuestion(InitialQuestionEvent event, Emitter<QuestionState> emit) {
    emit(QuestionInitialState());
  }

  ///We will Update the user Selected Answer
  void _answerSelected(AnswerSelectedEvent event, Emitter<QuestionState> emit) {
    questionSummaryModel = event.questionSummaryModel;
    emit(AnswerSelectedState(questionSummaryModel: questionSummaryModel!));
  }

  ///Here we will add the Question marked as selected and save the answer in Questions List.
  void _answerUpdated(AnswerUpdatedEvent event, Emitter<QuestionState> emit) {
    if (!questions.contains(event.questionSummaryModel)) {
      questions.add(event.questionSummaryModel);
    }

    emit(AnswersUpdatedState(listOfQuestionSummaryModel: questions));

  }



  ///Goal Completion Event
  void _goalCompletionEvent(GoalCompletionEvent event, Emitter<QuestionState> emit) {

    databaseHelper.insertQuestions(questions: questions,tableName:Constants.goalTableName);

    emit(GoalCompletionState(listOfQuestionSummaryModel: questions));

  }
}
