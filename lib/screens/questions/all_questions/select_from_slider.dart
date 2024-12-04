import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/screens/Widgets/animated_column.dart';
import 'package:freud_ai/screens/questions/bloc/questions_bloc.dart';
import 'package:freud_ai/screens/questions/bloc/questions_event.dart';
import 'package:freud_ai/screens/questions/model/listed_questions_model.dart';
import 'package:freud_ai/screens/questions/model/question_summary_model.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class SelectFromSliderQuestion extends StatefulWidget {
  final QuestionsModel? questionsModel;

  const SelectFromSliderQuestion({super.key, this.questionsModel});

  @override
  State<SelectFromSliderQuestion> createState() =>
      _SelectFromSliderQuestionState();
}

class _SelectFromSliderQuestionState extends State<SelectFromSliderQuestion> with AutomaticKeepAliveClientMixin {
  double _value = 45;

  bool index1Selected = false;
  bool index2Selected = false;
  bool index3Selected = false;
  bool index4Selected = true;
  bool index5Selected = false;

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
        answersList: [widget.questionsModel!.listOfAnswers![3].questionText!]);

    questionBloc!
        .add(AnswerSelectedEvent(questionSummaryModel: questionSummaryModel!));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: AnimatedColumnWrapper(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonWidgets().makeDynamicText(
              text: widget.questionsModel!.mainQuestion,
              size: 26,
              align: TextAlign.start,
              weight: FontWeight.bold,
              color: AppTheme.cT!.appColorDark),
          20.height,
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 50.w),
                  height: MediaQuery.sizeOf(context).height / 2.h,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.h),
                      viewOfStepCounter(
                          viewText1: widget
                              .questionsModel!.listOfAnswers![0].questionText,
                          icon:
                              widget.questionsModel!.listOfAnswers![0].itemIcon,
                          isSelected: index5Selected),
                      viewOfStepCounter(
                          viewText1: widget
                              .questionsModel!.listOfAnswers![1].questionText,
                          icon:
                              widget.questionsModel!.listOfAnswers![1].itemIcon,
                          isSelected: index4Selected),
                      viewOfStepCounter(
                          viewText1: widget
                              .questionsModel!.listOfAnswers![2].questionText,
                          icon:
                              widget.questionsModel!.listOfAnswers![2].itemIcon,
                          isSelected: index3Selected),
                      viewOfStepCounter(
                          viewText1: widget
                              .questionsModel!.listOfAnswers![3].questionText,
                          icon:
                              widget.questionsModel!.listOfAnswers![3].itemIcon,
                          isSelected: index2Selected),
                      viewOfStepCounter(
                          viewText1: widget
                              .questionsModel!.listOfAnswers![4].questionText,
                          icon:
                              widget.questionsModel!.listOfAnswers![4].itemIcon,
                          isSelected: index1Selected),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 45.h, top: 10.h),
                height: MediaQuery.sizeOf(context).height / 2.h,
                child: SfSlider.vertical(
                  min: 0,
                  max: 60,
                  value: _value,
                  interval: 5,
                  showTicks: false,
                  showDividers: false,
                  showLabels: false,
                  enableTooltip: false,
                  stepSize: 15,
                  activeColor: AppTheme.cT!.orangeColor,
                  minorTicksPerInterval: 0,
                  onChanged: (dynamic value) {
                    setState(() {
                      _value = value;

                      if (_value == 0) {
                        index1Selected = true;
                        index2Selected = false;
                        index3Selected = false;
                        index4Selected = false;
                        index5Selected = false;
                        questionSummaryModel!.copyWith(answersList: [
                          widget.questionsModel!.listOfAnswers![0].questionText!
                        ]);
                      } else if (_value == 15) {
                        index1Selected = false;
                        index2Selected = true;
                        index3Selected = false;
                        index4Selected = false;
                        index5Selected = false;
                        questionSummaryModel!.copyWith(answersList: [
                          widget.questionsModel!.listOfAnswers![1].questionText!
                        ]);
                      } else if (_value == 30) {
                        index1Selected = false;
                        index2Selected = false;
                        index3Selected = true;
                        index4Selected = false;
                        index5Selected = false;
                        questionSummaryModel!.copyWith(answersList: [
                          widget.questionsModel!.listOfAnswers![2].questionText!
                        ]);
                      } else if (_value == 45) {
                        index1Selected = false;
                        index2Selected = false;
                        index3Selected = false;
                        index4Selected = true;
                        index5Selected = false;
                        questionSummaryModel!.copyWith(answersList: [
                          widget.questionsModel!.listOfAnswers![3].questionText!
                        ]);
                      } else if (_value == 60) {
                        index1Selected = false;
                        index2Selected = false;
                        index3Selected = false;
                        index4Selected = false;
                        index5Selected = true;
                        questionSummaryModel!.copyWith(answersList: [
                          widget.questionsModel!.listOfAnswers![4].questionText!
                        ]);
                      }

                      questionBloc!.add(AnswerSelectedEvent(
                          questionSummaryModel: questionSummaryModel!));
                    });
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  ///View of Sleep Quality
  Widget viewOfStepCounter({viewText1, isSelected, icon}) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(icon,
              width: 24.w,
              height: 24.h,
            colorFilter: ColorFilter.mode(
              isSelected
                  ? AppTheme.cT!.appColorLight ?? Colors.transparent
                  : AppTheme.cT!.lightGrey ?? Colors.transparent,
              BlendMode.srcIn,
            ),
          ),
          10.width,
          CommonWidgets().makeDynamicText(
              text: viewText1,
              size: 18,
              weight: FontWeight.w800,
              color: isSelected
                  ? AppTheme.cT!.appColorDark
                  : AppTheme.cT!.lightGrey),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
