import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:freud_ai/configs/constants/assets.dart';
import 'package:freud_ai/configs/constants/constants.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/routes/routes.dart';
import 'package:freud_ai/screens/interest/interests_itemview.dart';
import 'package:freud_ai/screens/questions/bloc/questions_bloc.dart';
import 'package:freud_ai/screens/questions/feature/feature_view.dart';
import 'package:freud_ai/screens/questions/model/listed_questions_model.dart';
import 'package:freud_ai/screens/questions/model/question_summary_model.dart';
import 'package:freud_ai/screens/questions/questionnaire-set1/questionnaire_set1_constants.dart';
import 'package:freud_ai/screens/questions/questionnaire-set2/questionnaire_set2_constants.dart';
import 'package:freud_ai/screens/questions/questionnaire-set3/questionnaire_set3_constants.dart';
import 'package:freud_ai/screens/questions/questionnaire-set4/questionnaire_set4_constants.dart';
import 'package:lottie/lottie.dart';

class SelectInterestPage extends StatefulWidget {
  final String? parentFeatureName;
  final List<Widget>? listOfQuestionsWidgets;

  const SelectInterestPage({
    super.key,
    this.listOfQuestionsWidgets,
    this.parentFeatureName,
  });

  @override
  State<SelectInterestPage> createState() => _SelectInterestPageState();
}

class _SelectInterestPageState extends State<SelectInterestPage> {
  QuestionsModel? listedQuestionsModel;
  List<String> listOfSelectedInterest = [] ;
  List<QuestionsModelList> listOfQuestions = [
    QuestionsModelList(questionText: Constants.interest1, isSelected: false,itemIcon: AssetsItems.interest1Image),
    QuestionsModelList(questionText: Constants.interest2, isSelected: false,itemIcon: AssetsItems.interest2Image),
    QuestionsModelList(questionText: Constants.interest3, isSelected: false,itemIcon: AssetsItems.interest3Image),
    QuestionsModelList(questionText: Constants.interest4, isSelected: false,itemIcon: AssetsItems.interest4Image),
    QuestionsModelList(questionText: Constants.interest5, isSelected: false,itemIcon: AssetsItems.interest5Image),
    QuestionsModelList(questionText: Constants.interest6, isSelected: false,itemIcon: AssetsItems.interest6Image),
    QuestionsModelList(questionText: Constants.interest7, isSelected: false,itemIcon: AssetsItems.interest7Image),
    QuestionsModelList(questionText: Constants.interest8, isSelected: false,itemIcon: AssetsItems.interest8Image),
    QuestionsModelList(questionText: Constants.interest9, isSelected: false,itemIcon: AssetsItems.interest9Image),
    QuestionsModelList(questionText: Constants.interest10, isSelected: false,itemIcon: AssetsItems.interest10Image),
    QuestionsModelList(questionText: Constants.interest11, isSelected: false,itemIcon: AssetsItems.interest11Image),
    QuestionsModelList(questionText: Constants.interest12, isSelected: false,itemIcon: AssetsItems.interest12Image),

  ];
  @override
  void initState() {
    super.initState();

    listedQuestionsModel = QuestionsModel(
        mainQuestion: "Tell us what you're\ninterested in!",
      listOfAnswers: listOfQuestions,
    );

    final questionsBloc = BlocProvider.of<QuestionBloc>(context, listen: false);

    questionsBloc.questionSummaryModel = QuestionSummaryModel(
        question: "Tell us what you're interested in!",
        answersList: listOfSelectedInterest,
      featureName: QuestionnaireSet1Constants().goalQuestionKey,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.00, -1.00),
            end: Alignment(0, 1),
            colors: [Color(0x009BB067), Color(0x669BB067)],
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 50.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CommonWidgets().makeDynamicText(
                      text: listedQuestionsModel!.mainQuestion,
                      size: 30,
                      weight: FontWeight.w800,
                      align: TextAlign.center,
                      color: AppTheme.cT!.appColorLight),
                  listedQuestionsModel!.questionAnimation != null
                      ? Container(
                          margin: EdgeInsets.only(top: 20.h),
                          child: Lottie.asset(
                              listedQuestionsModel!.questionAnimation!),
                        )
                      : const SizedBox(),
                  20.height,
                  Expanded(
                    child: AnimationLimiter(
                      child: GridView.builder(
                          itemCount: listedQuestionsModel!.listOfAnswers!.length,
                          shrinkWrap: true,
                          padding: EdgeInsets.only(bottom: 120.h),
                          physics: const BouncingScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisExtent: 200.h,
                            crossAxisSpacing: 15.w,
                            mainAxisSpacing: 15.h,
                          ),
                          itemBuilder: (context, index) {
                            return AnimationConfiguration.staggeredGrid(
                                position: index,
                                duration: const Duration(milliseconds: 800),
                                columnCount: 2,
                                child: ScaleAnimation(
                                    child: FadeInAnimation(
                                        child: InterestItemView(
                                  listedQuestionsModel:
                                      listedQuestionsModel!.listOfAnswers![index],
                                  isInterestSelected: listedQuestionsModel!
                                          .listOfAnswers![index].isSelected ??
                                      false,
                                  onInterestTap: () {
                                    /// first update the status of selection of interest
                                    ///
                                    /// if status == true, then update the selected status to false vise versa

                                    listedQuestionsModel!
                                            .listOfAnswers![index].isSelected =
                                        !listedQuestionsModel!
                                            .listOfAnswers![index].isSelected!;

                                    /// based on status add or remove the interest from the interest list
                                    if (listedQuestionsModel!
                                        .listOfAnswers![index].isSelected!) {
                                      listOfSelectedInterest.add(
                                          listedQuestionsModel!
                                              .listOfAnswers![index]
                                              .questionText!);
                                    } else {
                                      listOfSelectedInterest.remove(
                                          listedQuestionsModel!
                                              .listOfAnswers![index]
                                              .questionText!);
                                    }
                                    setState(() {});
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 30.h,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.only(left: 12.w, right: 12.w),
                child: CommonWidgets().customButton(
                    showIcon: true,
                    text: "Continue",
                  callBack: () => navigateToNextQuestions(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  ///Navigate To Next Questions Portion according to Selected Goal
  navigateToNextQuestions() {
    /// Create a list of goal keys and their corresponding featureViewModels
    List<Map<String, dynamic>> goals = [
      {
        'key': Constants.goal1Key,
        'viewModel': QuestionnaireSet1Constants().getFeature1Questions()
      },
      {
        'key': Constants.goal2Key,
        'viewModel': QuestionnaireSet2Constants().getFeature1Questions()
      },

      {
        'key': Constants.goal3Key,
        'viewModel': QuestionnaireSet3Constants().getFeature1Questions()
      },

      {
        'key': Constants.goal4Key,
        'viewModel': QuestionnaireSet4Constants().getFeature1Questions()
      },

    ];

    /// Randomly select an index from the list
    Random random = Random();
    int randomIndex = random.nextInt(goals.length);

    /// Get the selected values
    // String selectedKey = goals[randomIndex]['key'];
    dynamic selectedViewModel = goals[randomIndex]['viewModel'];

    /// Use the selected values to create FeatureView
    if (listOfSelectedInterest.isNotEmpty) {
      Navigate.pushNamed(FeatureView(featureViewModel: selectedViewModel));
    } else {
      CommonWidgets().showSnackBar(context, "select interest");
    }
  }

}
