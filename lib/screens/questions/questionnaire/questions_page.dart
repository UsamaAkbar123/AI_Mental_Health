import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freud_ai/configs/constants/constants.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/routes/routes.dart';
import 'package:freud_ai/screens/profile_setup/profile_completion.dart';
import 'package:freud_ai/screens/questions/bloc/questions_bloc.dart';
import 'package:freud_ai/screens/questions/bloc/questions_event.dart';
import 'package:freud_ai/screens/questions/bloc/questions_provider.dart';
import 'package:freud_ai/screens/questions/bloc/questions_state.dart';
import 'package:freud_ai/screens/questions/feature/feature_view.dart';
import 'package:freud_ai/screens/questions/feature/model_view_model.dart';
import 'package:freud_ai/screens/questions/questionnaire-set1/questionnaire_set1_constants.dart';
import 'package:freud_ai/screens/questions/questionnaire-set2/questionnaire_set2_constants.dart';
import 'package:freud_ai/screens/questions/questionnaire-set3/questionnaire_set3_constants.dart';
import 'package:freud_ai/screens/questions/questionnaire-set4/questionnaire_set4_constants.dart';
import 'package:freud_ai/screens/questions/questionnaire/questionnaire_page_view.dart';
import 'package:provider/provider.dart';

class QuestionnairePage extends StatelessWidget {
  final FeatureViewModel? featureViewModel;
  final GlobalKey<QuestionnairePageViewState> pageViewKey = GlobalKey();

  QuestionnairePage({
    super.key,
    this.featureViewModel,
  });

  @override
  Widget build(BuildContext context) {

    final QuestionBloc questionBloc = context.read<QuestionBloc>();

    // questionBloc.add(AnswerSelectedEvent(
    //     questionSummaryModel: questionBloc.questionSummaryModel!));

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop){
        //navigateToBackAndUpdateTheState(questionBloc, context);
      },
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 50.h,
                left: 12.w,
                right: 24.w,
                bottom: 20.h,
              ),
              child: Row(
                children: [
                  CommonWidgets().backButton(backButton: () {
                    navigateToBackAndUpdateTheState(questionBloc, context);
                  }),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: SizedBox(
                      height: 8.h,
                      child: Consumer<QuestionsProvider>(
                        builder: (context, provider, _) {
                          return LinearProgressIndicator(
                            value: provider.questionnaireProgressValue,
                            borderRadius: BorderRadius.circular(20.w),
                            backgroundColor: AppTheme.cT!.lightGreenColor,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                AppTheme.cT!.greenColor!),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: QuestionnairePageView(
                widgets: featureViewModel!.listOfWidgets!,
                key: pageViewKey,
              ),
            ),
            BlocBuilder<QuestionBloc, QuestionState>(
              builder: (context, state) {
                return SafeArea(
                  child: Padding(
                    padding: EdgeInsets.only(left: 12.w, right: 12.w, bottom: 20),
                    child: CommonWidgets().customButton(
                      showIcon: true,
                      text: "Continue",
                        callBack: () {
                          navigateToNextQuestions(
                            state,
                            questionBloc,
                            context,
                          );
                        }),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  ///Navigate to Previous Page and change the State
  navigateToBackAndUpdateTheState(QuestionBloc questionBloc, context) {
    if (questionBloc.questions.isNotEmpty) {
      questionBloc.questions.removeLast();
      questionBloc.add(AnswerSelectedEvent(
          questionSummaryModel: questionBloc.questionSummaryModel!,
        ),
      );
    }

    if(pageViewKey.currentState!.currentPage>0){
      Provider.of<QuestionsProvider>(context, listen: false)
          .decreaseQuestionnaireProgress();
    }

    pageViewKey.currentState!.goToPreviousPage();
  }

  ///Navigate To Next Question Portion
  navigateToNextQuestions(
    QuestionState state,
    QuestionBloc questionBloc,
    BuildContext context,
  ) {
    if (state is AnswerSelectedState) {
      questionBloc.add(
        AnswerUpdatedEvent(
          questionSummaryModel: state.questionSummaryModel,
        ),
      );

      Provider.of<QuestionsProvider>(context, listen: false).setQuestionnaireProgress();

      if (pageViewKey.currentState!.currentPage <
          pageViewKey.currentState!.widget.widgets.length - 1) {
        /// This will swipe the Feature Question.
        pageViewKey.currentState!.goToNextPage();

        questionBloc.add(AnswerSelectedEvent(
            questionSummaryModel: questionBloc.questionSummaryModel!));

        questionBloc.add(InitialQuestionEvent());

        /// Else if Condition swipe the complete feature.
      } else {
        questionBloc.add(InitialQuestionEvent());
        // CommonWidgets().showSnackBar(context, "select the answer");
        if (state.questionSummaryModel.selectedGoal == Constants.goal1Key) {

          goal1Navigation(featureViewModel!.parentFeatureName, questionBloc);
        } else if (state.questionSummaryModel.selectedGoal ==
            Constants.goal2Key) {
          goal2Navigation(featureViewModel!.parentFeatureName, questionBloc);
        } else if (state.questionSummaryModel.selectedGoal ==
            Constants.goal3Key) {
          goal3Navigation(featureViewModel!.parentFeatureName, questionBloc);
        } else {
          /// Goal 4 Navigation
          goal4Navigation(featureViewModel!.parentFeatureName, questionBloc);
        }
      }
    } else {
      CommonWidgets().showSnackBar(context, "Select the correct answer");
    }
  }

  /// This Will Navigate For Goal 1
  goal1Navigation(questionFromWhichFeature, QuestionBloc questionBloc) {
    /// Goal One Navigation
    if (questionFromWhichFeature == QuestionnaireSet1Constants().goalQuestionKey) {
      Navigate.pushNamed(FeatureView(
          featureViewModel: QuestionnaireSet1Constants().getFeature1Questions()));

      ///
    } else if (questionFromWhichFeature == QuestionnaireSet1Constants().questionsFeature1) {
      Navigate.pushNamed(FeatureView(
          featureViewModel: QuestionnaireSet1Constants().getFeature2Questions()));

      ///
    } else if (questionFromWhichFeature == QuestionnaireSet1Constants().questionsFeature2) {
      Navigate.pushNamed(FeatureView(
          featureViewModel: QuestionnaireSet1Constants().getFeature3Questions()));

      ///
    } else if (questionFromWhichFeature == QuestionnaireSet1Constants().questionsFeature3) {
      Navigate.pushNamed(FeatureView(
          featureViewModel: QuestionnaireSet1Constants().getFeature4Questions()));

      ///
    } else if (questionFromWhichFeature == QuestionnaireSet1Constants().questionsFeature4) {
      questionBloc.add(GoalCompletionEvent());
      Navigate.pushAndRemoveUntil(const ProfileCompletion());
    }
  }

  /// This Will Navigate For Goal 2
  goal2Navigation(questionFromWhichFeature, QuestionBloc questionBloc) {
    /// Goal 2 navigation
    if (questionFromWhichFeature == QuestionnaireSet2Constants().questionsFeature1) {
      Navigate.pushNamed(FeatureView(
          featureViewModel: QuestionnaireSet2Constants().getFeature2Questions()));

      ///
    } else if (questionFromWhichFeature == QuestionnaireSet2Constants().questionsFeature2) {
      Navigate.pushNamed(FeatureView(
          featureViewModel: QuestionnaireSet2Constants().getFeature3Questions()));

      ///
    } else if (questionFromWhichFeature == QuestionnaireSet2Constants().questionsFeature3) {
      Navigate.pushNamed(FeatureView(
          featureViewModel: QuestionnaireSet2Constants().getFeature4Questions()));

      ///
    } else if (questionFromWhichFeature == QuestionnaireSet2Constants().questionsFeature4) {
      questionBloc.add(GoalCompletionEvent());
      Navigate.pushAndRemoveUntil(const ProfileCompletion());
    }
  }

  /// This Will Navigate For Goal 3
  goal3Navigation(questionFromWhichFeature, QuestionBloc questionBloc) {
    /// Goal 3 Navigation
    if (questionFromWhichFeature == QuestionnaireSet3Constants().questionsFeature1) {
      Navigate.pushNamed(FeatureView(
          featureViewModel: QuestionnaireSet3Constants().getFeature2Questions()));

      ///
    } else if (questionFromWhichFeature == QuestionnaireSet3Constants().questionsFeature2) {
      Navigate.pushNamed(FeatureView(
          featureViewModel: QuestionnaireSet3Constants().getFeature3Questions()));

      ///
    } else if (questionFromWhichFeature == QuestionnaireSet3Constants().questionsFeature3) {
      Navigate.pushNamed(FeatureView(
          featureViewModel: QuestionnaireSet3Constants().getFeature4Questions()));

      ///
    } else if (questionFromWhichFeature == QuestionnaireSet3Constants().questionsFeature4) {
      questionBloc.add(GoalCompletionEvent());
      Navigate.pushAndRemoveUntil(const ProfileCompletion());
    }
  }

  /// This Will Navigate For Goal 4
  goal4Navigation(questionFromWhichFeature, QuestionBloc questionBloc) {
    if (questionFromWhichFeature == QuestionnaireSet4Constants().questionsFeature1) {
      Navigate.pushNamed(FeatureView(
          featureViewModel: QuestionnaireSet4Constants().getFeature2Questions()));

      ///
    } else if (questionFromWhichFeature == QuestionnaireSet4Constants().questionsFeature2) {
      Navigate.pushNamed(FeatureView(
          featureViewModel: QuestionnaireSet4Constants().getFeature3Questions()));

      ///
    } else if (questionFromWhichFeature == QuestionnaireSet4Constants().questionsFeature3) {
      Navigate.pushNamed(FeatureView(
          featureViewModel: QuestionnaireSet4Constants().getFeature4Questions()));

      ///
    } else if (questionFromWhichFeature == QuestionnaireSet4Constants().questionsFeature4) {
      questionBloc.add(GoalCompletionEvent());
      Navigate.pushAndRemoveUntil(const ProfileCompletion());
    }
  }
}
