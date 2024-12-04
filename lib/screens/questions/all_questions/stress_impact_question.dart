import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/configs/constants/assets.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/screens/Widgets/animated_column.dart';
import 'package:freud_ai/screens/questions/bloc/questions_bloc.dart';
import 'package:freud_ai/screens/questions/bloc/questions_event.dart';
import 'package:freud_ai/screens/questions/model/listed_questions_model.dart';
import 'package:freud_ai/screens/questions/model/question_summary_model.dart';

class StressImpactQuestion extends StatefulWidget {
  final QuestionsModel? questionsModel;

  const StressImpactQuestion({super.key, this.questionsModel});

  @override
  State<StressImpactQuestion> createState() => _StressImpactQuestionState();
}

class _StressImpactQuestionState extends State<StressImpactQuestion> with AutomaticKeepAliveClientMixin{
  final List<String> emojis = [
    "assets/assessment/emoji5.svg",
    "assets/assessment/emoji1.svg",
    "assets/assessment/emoji2.svg",
    "assets/assessment/emoji3.svg",
    "assets/assessment/emoji4.svg",
  ];

  final List<String> topEmojiList = [
    AssetsItems.highlyDistractibleEmoji,
    AssetsItems.veryDistractibleEmoji,
    AssetsItems.moderateDistractibleEmoji,
    AssetsItems.slightlyDistractibleEmoji,
    AssetsItems.notDistractibleEmoji,
  ];

  int selectedIndex = 2;
  String? selectedMoodText;

  QuestionBloc? questionBloc;
  QuestionSummaryModel? questionSummaryModel;

  @override
  void initState() {
    super.initState();
    questionBloc = context.read<QuestionBloc>();

    questionSummaryModel = QuestionSummaryModel(
        question: widget.questionsModel!.mainQuestion,
        selectedGoal: widget.questionsModel!.userGoal,
        featureName: widget.questionsModel!.featureName,
        answersList: [widget.questionsModel!.listOfAnswers![2].questionText!]);

    questionBloc!
        .add(AnswerSelectedEvent(questionSummaryModel: questionSummaryModel!));

    selectedMoodText = widget.questionsModel!.listOfAnswers![2].questionText;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            AnimatedColumnWrapper(children: [
              CommonWidgets().makeDynamicText(
                  text: widget.questionsModel!.mainQuestion,
                  size: 26,
                  align: TextAlign.center,
                  weight: FontWeight.bold,
                  color: AppTheme.cT!.appColorLight),
              30.height,
              CommonWidgets().makeDynamicText(
                  text: selectedMoodText,
                  size: 18,
                  align: TextAlign.center,
                  color: AppTheme.cT!.greyColor),
              10.height,
              SizedBox(
                child: SvgPicture.asset(
                  topEmojiList[selectedIndex]
                ),
              ),
              10.height,
              SvgPicture.asset("assets/assessment/bottom_farwarded.svg"),
            ]),
            30.height,
            emojisList(),
          ],
        ),
      ),
    );
  }

  ///Emoji List
  Widget emojisList() {
    return SizedBox(
      height: 150.h,
      child: AnimationLimiter(
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: emojis.length,
          itemBuilder: (context, index) {
            final String emojiAsset = emojis[index % emojis.length];
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 800),
              child: SlideAnimation(
                horizontalOffset: 20,
                curve: Curves.easeInOut,
                duration: const Duration(milliseconds: 800),
                child: FadeInAnimation(
                  child: GestureDetector(
                    onTap: () {
                      selectedIndex = index;

                      if (selectedIndex == 0) {
                        selectedMoodText =
                            widget.questionsModel!.listOfAnswers![0]
                                .questionText;
                        questionSummaryModel = questionSummaryModel!.copyWith(
                            answersList: [
                              widget.questionsModel!.listOfAnswers![0]
                                  .questionText!
                            ]);
                      } else if (selectedIndex == 1) {
                        selectedMoodText =
                            widget.questionsModel!.listOfAnswers![1]
                                .questionText;
                        questionSummaryModel = questionSummaryModel!.copyWith(
                            answersList: [
                              widget.questionsModel!.listOfAnswers![1]
                                  .questionText!
                            ]);
                      } else if (selectedIndex == 2) {
                        selectedMoodText =
                            widget.questionsModel!.listOfAnswers![2]
                                .questionText;
                        questionSummaryModel = questionSummaryModel!.copyWith(
                            answersList: [
                              widget.questionsModel!.listOfAnswers![2]
                                  .questionText!
                            ]);
                      } else if (selectedIndex == 3) {
                        selectedMoodText =
                            widget.questionsModel!.listOfAnswers![3]
                                .questionText;
                        questionSummaryModel = questionSummaryModel!.copyWith(
                            answersList: [
                              widget.questionsModel!.listOfAnswers![3]
                                  .questionText!
                            ]);
                      }

                      questionBloc!.add(AnswerSelectedEvent(
                          questionSummaryModel: questionSummaryModel!));

                      setState(() => {});
                    },
                    child: Container(
                      width: 150.w,
                      height: 120.h,
                      decoration: BoxDecoration(
                          border: selectedIndex == index
                              ? Border.all(
                                  width: 1.5.w,
                                  color: AppTheme.cT!.appColorLight!)
                              : null),
                      child: SvgPicture.asset(
                        emojiAsset,
                        width: 150.w,
                        height: 120.h,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
