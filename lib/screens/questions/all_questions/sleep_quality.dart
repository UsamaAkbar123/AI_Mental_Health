import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/screens/Widgets/animated_column.dart';
import 'package:freud_ai/screens/questions/bloc/questions_bloc.dart';
import 'package:freud_ai/screens/questions/bloc/questions_event.dart';
import 'package:freud_ai/screens/questions/model/question_summary_model.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class SleepQualityQuestion extends StatefulWidget {

  final String selectedGoal;
  final String featureName;

   const SleepQualityQuestion({super.key,required this.selectedGoal,required this.featureName});

  @override
  State<SleepQualityQuestion> createState() => _SleepQualityQuestionState();
}

class _SleepQualityQuestionState extends State<SleepQualityQuestion> with AutomaticKeepAliveClientMixin{
  double _value = 75;

  bool index1Selected = false;
  bool index2Selected = false;
  bool index3Selected = false;
  bool index4Selected = true;

  QuestionBloc? questionBloc;
  QuestionSummaryModel? questionSummaryModel;

  @override
  void initState() {
    super.initState();
    questionBloc = context.read<QuestionBloc>();

    questionSummaryModel = QuestionSummaryModel(
        question: "What is your average\nnightly sleep?",
        selectedGoal: widget.selectedGoal,
        featureName: widget.featureName,
        answersList: const ["7-9 Hours"]);

    questionBloc!
        .add(AnswerSelectedEvent(questionSummaryModel: questionSummaryModel!));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: AnimatedColumnWrapper(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonWidgets().makeDynamicText(
                  text: "What is your average\nnightly sleep?",
                  size: 26,
                  align: TextAlign.start,
                  weight: FontWeight.bold,
                  color: AppTheme.cT!.appColorLight),
              50.height,
              viewOfSleepQuality(
                  viewText1: "Excellent",
                  viewText2: "7-9 Hours",
                  viewIcon: "excelent.svg",
                  isSelected: index4Selected),
              viewOfSleepQuality(
                  viewText1: "Fair",
                  viewText2: "5 Hours",
                  viewIcon: "fair.svg",
                  isSelected: index3Selected),
              viewOfSleepQuality(
                  viewText1: "Poor",
                  viewText2: "3-4 Hours",
                  viewIcon: "poor.svg",
                  isSelected: index2Selected),
              viewOfSleepQuality(
                  viewText1: "Worst",
                  viewText2: "<3 Hours",
                  viewIcon: "worst.svg",
                  isSelected: index1Selected),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 130.h),
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height / 2.6.h,
            child: SfSlider.vertical(
              min: 0,
              max: 75,
              value: _value,
              interval: 4,
              showTicks: false,
              showDividers: false,
              showLabels: false,
              enableTooltip: false,
              stepSize: 25,
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
                    questionSummaryModel = questionSummaryModel!
                        .copyWith(answersList: ["<3 Hours"]);
                  } else if (_value == 25) {
                    index1Selected = false;
                    index2Selected = true;
                    index3Selected = false;
                    index4Selected = false;
                    questionSummaryModel = questionSummaryModel!
                        .copyWith(answersList: ["3-4 Hours"]);
                  } else if (_value == 50) {
                    index1Selected = false;
                    index2Selected = false;
                    index3Selected = true;
                    index4Selected = false;
                    questionSummaryModel = questionSummaryModel!
                        .copyWith(answersList: ["5 Hours"]);
                  } else if (_value == 75) {
                    index1Selected = false;
                    index2Selected = false;
                    index3Selected = false;
                    index4Selected = true;
                    questionSummaryModel = questionSummaryModel!
                        .copyWith(answersList: ["7-9 Hours"]);
                  }

                  questionBloc!.add(AnswerSelectedEvent(
                      questionSummaryModel: questionSummaryModel!));
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  ///View of Sleep Quality
  Widget viewOfSleepQuality({viewText1, viewText2, viewIcon, isSelected}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonWidgets().makeDynamicText(
                  text: viewText1,
                  size: 18,
                  weight: FontWeight.w800,
                  color: isSelected
                      ? AppTheme.cT!.appColorLight
                      : AppTheme.cT!.lightGrey),
              8.height,
              SizedBox(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: 12.w,
                        height: 12.h,
                        child: SvgPicture.asset("assets/routine/clock.svg",
                        colorFilter: ColorFilter.mode(
                          isSelected
                              ? AppTheme.cT!.appColorDark ?? Colors.transparent
                              : AppTheme.cT!.lightGrey50 ?? Colors.transparent,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    4.width,
                    CommonWidgets().makeDynamicText(
                        text: viewText2,
                        size: 12,
                        weight: FontWeight.w800,
                        color: isSelected
                            ? AppTheme.cT!.appColorDark
                            : AppTheme.cT!.lightGrey50),
                  ],
                ),
              ),
            ],
          ),
          SvgPicture.asset("assets/assessment/$viewIcon"),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
