import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/screens/Widgets/animated_column.dart';
import 'package:freud_ai/screens/questions/bloc/questions_bloc.dart';
import 'package:freud_ai/screens/questions/bloc/questions_event.dart';
import 'package:freud_ai/screens/questions/model/question_summary_model.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class StepsTargetQuestion extends StatefulWidget {
  final String selectedGoal;
  final String featureName;
  const StepsTargetQuestion({super.key,required this.featureName,required this.selectedGoal});

  @override
  State<StepsTargetQuestion> createState() => _StepsTargetQuestionState();
}

class _StepsTargetQuestionState extends State<StepsTargetQuestion> with AutomaticKeepAliveClientMixin {
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
        question: "What is your average\ndaily steps goal?",
        selectedGoal: widget.selectedGoal,
        featureName: widget.featureName,
        answersList: const ["7500 to 10000"]);

    questionBloc!
        .add(AnswerSelectedEvent(questionSummaryModel: questionSummaryModel!));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: SingleChildScrollView(
        child: AnimatedColumnWrapper(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonWidgets().makeDynamicText(
                text: "What is your average\ndaily steps goal?",
                size: 26,
                align: TextAlign.start,
                weight: FontWeight.bold,
                color: AppTheme.cT!.appColorDark),
            50.height,
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: MediaQuery.sizeOf(context).height / 2.h,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.h),
                        viewOfStepCounter(
                            viewText1: "More than 10000",
                            isSelected: index5Selected),
                        viewOfStepCounter(
                            viewText1: "7500 to 10000",
                            isSelected: index4Selected),
                        viewOfStepCounter(
                            viewText1: "5000 to 7500",
                            isSelected: index3Selected),
                        viewOfStepCounter(
                            viewText1: "3000 to 4500",
                            isSelected: index2Selected),
                        viewOfStepCounter(
                            viewText1: "Under 3000", isSelected: index1Selected),
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
                    inactiveColor: AppTheme.cT!.lightGrey50,
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
                          questionSummaryModel!
                              .copyWith(answersList: ["Under 3000"]);
                        } else if (_value == 15) {
                          index1Selected = false;
                          index2Selected = true;
                          index3Selected = false;
                          index4Selected = false;
                          index5Selected = false;
                          questionSummaryModel!
                              .copyWith(answersList: ["3000 to 4500"]);
                        } else if (_value == 30) {
                          index1Selected = false;
                          index2Selected = false;
                          index3Selected = true;
                          index4Selected = false;
                          index5Selected = false;
                          questionSummaryModel!
                              .copyWith(answersList: ["5000 to 7500"]);
                        } else if (_value == 45) {
                          index1Selected = false;
                          index2Selected = false;
                          index3Selected = false;
                          index4Selected = true;
                          index5Selected = false;
                          questionSummaryModel!
                              .copyWith(answersList: ["7500 to 10000"]);
                        } else if (_value == 60) {
                          index1Selected = false;
                          index2Selected = false;
                          index3Selected = false;
                          index4Selected = false;
                          index5Selected = true;
                          questionSummaryModel!
                              .copyWith(answersList: ["More than 10000"]);
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
      ),
    );
  }

  ///View of Sleep Quality
  Widget viewOfStepCounter({viewText1, isSelected}) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(left: 40.w),
        child: CommonWidgets().makeDynamicText(
            text: viewText1,
            size: 18,
            weight: FontWeight.w800,
            color: isSelected
                ? AppTheme.cT!.appColorDark
                : AppTheme.cT!.lightGrey),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
