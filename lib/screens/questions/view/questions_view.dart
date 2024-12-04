import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/screens/Widgets/animated_column.dart';
import 'package:freud_ai/screens/questions/bloc/questions_bloc.dart';
import 'package:freud_ai/screens/questions/bloc/questions_event.dart';
import 'package:freud_ai/screens/questions/model/listed_questions_model.dart';
import 'package:freud_ai/screens/questions/model/question_summary_model.dart';
import 'package:freud_ai/screens/questions/view/grid_question_item_view.dart';
import 'package:freud_ai/screens/questions/view/linear_question_item_view.dart';
import 'package:lottie/lottie.dart';

class QuestionsView extends StatefulWidget {
  final bool? isShowGrid;
  final QuestionsModel? questionsModel;

  const QuestionsView({super.key, this.questionsModel, this.isShowGrid});

  @override
  State<QuestionsView> createState() => _QuestionsViewState();
}

class _QuestionsViewState extends State<QuestionsView> {
  QuestionBloc? questionBloc;

  @override
  void initState() {
    super.initState();

    questionBloc = context.read<QuestionBloc>();

  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedColumnWrapper(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonWidgets().makeDynamicText(
                      text: widget.questionsModel!.mainQuestion,
                      size: 26,
                      weight: FontWeight.bold,
                      align: TextAlign.start,
                      color: AppTheme.cT!.appColorLight),
                  widget.questionsModel!.isSelectMultiple != null &&
                          widget.questionsModel!.isSelectMultiple!
                      ? CommonWidgets().makeDynamicText(
                          text: "Select as many as you want",
                          size: 18,
                          weight: FontWeight.w500,
                          align: TextAlign.start,
                          color: AppTheme.cT!.lightGrey)
                      : const SizedBox(),
                  10.height,
                  widget.questionsModel!.questionAnimation != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(60.w.h),
                          child: Container(
                              width: 120.w,
                              height: 120.h,
                              color: AppTheme.cT!.whiteColor,
                              child: Lottie.asset(
                                  width: 120.w,
                                  height: 120.h,
                                  widget.questionsModel!.questionAnimation!,
                                  fit: BoxFit.fill)),
                        )
                      : const SizedBox(),
                  10.height,
                ]),
            widget.isShowGrid != null ? showGridList() : showLinearList()
          ],
        ),
      ),
    );
  }

  ///This will show the Questions List in Linearly
  Widget showLinearList() {
    return AnimationLimiter(
      child: ListView.builder(
        itemCount: widget.questionsModel!.listOfAnswers!.length,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 800),
            child: SlideAnimation(
              horizontalOffset: 20,
              curve: Curves.easeInOut,
              duration: const Duration(milliseconds: 800),
              child: FadeInAnimation(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: QuestionItemView(
                    isMultipleAllow: widget.questionsModel!.isSelectMultiple,
                    listOfAnswers: widget.questionsModel!.listOfAnswers,
                    listedQuestionsModel:
                        widget.questionsModel!.listOfAnswers![index],
                    updateList: (updatedAnswers) {
                      updateAnswerList(updatedAnswers);
                      setState(() => {});
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  ///This Will show the Questions List in GridView
  Widget showGridList() {
    return AnimationLimiter(
      child: GridView.builder(
          itemCount: widget.questionsModel!.listOfAnswers!.length,
          shrinkWrap: true,
          padding: EdgeInsets.only(top: 20.h),
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 160.h,
            crossAxisSpacing: 16.w,
            mainAxisSpacing: 16.h,
          ),
          itemBuilder: (context, index) {
            return AnimationConfiguration.staggeredGrid(
              position: index,
              duration: const Duration(milliseconds: 800),
              columnCount: 2,
              child: ScaleAnimation(
                child: FadeInAnimation(
                  child: SquaredQuestionView(
                    isMultipleAllow: widget.questionsModel!.isSelectMultiple,
                    listOfAnswers: widget.questionsModel!.listOfAnswers,
                    listedQuestionsModel:
                        widget.questionsModel!.listOfAnswers![index],
                    updateList: (updatedAnswers) {
                      updateAnswerList(updatedAnswers);
                      setState(() => {});
                    },
                  ),
                ),
              ),
            );
          }),
    );
  }

  ///In this  Function we will add  or remove the selected answers according to requirement
  void updateAnswerList(String updatedAnswer) {
    List<String> userSelectedAnswers =
        widget.questionsModel!.userSelectedAnswer ?? [];

    /// Check if the updated answer already exists in the list
    bool isAnswerExists = userSelectedAnswers.contains(updatedAnswer);

    /// If it exists, remove it; if not, add it
    if (isAnswerExists) {
      userSelectedAnswers.remove(updatedAnswer);
    } else {
      userSelectedAnswers.add(updatedAnswer);
    }

    /// Update the userSelectedAnswer property in the questionsModel
    widget.questionsModel!.userSelectedAnswer = userSelectedAnswers;

    /// Set up the answers list
    setUpTheAnswersList(widget.questionsModel!);
  }

  ///Set Up the List Answers
  setUpTheAnswersList(QuestionsModel listedQuestionsModel) {
    QuestionSummaryModel? questionSummaryModel;

    questionSummaryModel = QuestionSummaryModel(
        question: listedQuestionsModel.mainQuestion,
        selectedGoal: listedQuestionsModel.userGoal,
        featureName: listedQuestionsModel.featureName,
        answersList: widget.questionsModel!.userSelectedAnswer!);

    questionBloc!
        .add(AnswerSelectedEvent(questionSummaryModel: questionSummaryModel));

  }
}
