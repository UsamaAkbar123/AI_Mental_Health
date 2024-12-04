import 'package:flutter/material.dart';
import 'package:freud_ai/configs/constants/assets.dart';
import 'package:freud_ai/configs/constants/constants.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/screens/questions/all_questions/select_from_slider.dart';
import 'package:freud_ai/screens/questions/all_questions/sleep_quality.dart';
import 'package:freud_ai/screens/questions/all_questions/steps_target_question.dart';
import 'package:freud_ai/screens/questions/all_questions/stress_impact_question.dart';
import 'package:freud_ai/screens/questions/feature/model_view_model.dart';
import 'package:freud_ai/screens/questions/model/listed_questions_model.dart';
import 'package:freud_ai/screens/questions/model/question_summary_model.dart';
import 'package:freud_ai/screens/questions/view/questions_view.dart';

class QuestionnaireSet1Constants {
  ///Here Declare the Questions Name
  String goalQuestionKey = "goalQuestionKey";
  String questionsFeature1 = "questionsFeature1";
  String questionsFeature2 = "questionsFeature2";
  String questionsFeature3 = "questionsFeature3";
  String questionsFeature4 = "questionsFeature4";

  static List<QuestionSummaryModel> goalOneAnsweredList=[];

  /// =========================Functions Names are the Features Names =========== ///

  ///Goal Questions
  FeatureViewModel getGoalQuestion() {
    List<Widget> listOfPageWidgets = [];

    List<QuestionsModelList> listOfQuestions = [
      QuestionsModelList(
          questionText: Constants.goal1Key,
          isSelected: false,
          itemIcon: AssetsItems.heart),
      QuestionsModelList(
          questionText: Constants.goal2Key,
          isSelected: false,
          itemIcon: AssetsItems.aiTherapyChat),
      QuestionsModelList(
          questionText: Constants.goal3Key,
          isSelected: false,
          itemIcon: AssetsItems.flag),
      QuestionsModelList(
          questionText: Constants.goal4Key,
          isSelected: false,
          itemIcon: AssetsItems.homeTopRound),
    ];

    QuestionsModel listedQuestionsModel = QuestionsModel(
        mainQuestion: "What’s your main\ngoal?",
        listOfAnswers: listOfQuestions);

    listOfPageWidgets.add(QuestionsView(questionsModel: listedQuestionsModel,key: UniqueKey()));

    return FeatureViewModel(
      text1: 'Personalize Your ',
      text2: 'AI\nMental Health ',
      text3: 'With Us',
      isAnimationFill: false,
      background: AssetsItems.dailyLifeBackground,
      text1Color: AppTheme.cT!.appColorLight,
      text2Color: AppTheme.cT!.purpleColor,
      text3Color: AppTheme.cT!.appColorLight,
      animation: AssetsItems.horizontalMovingJson,
      parentFeatureName: goalQuestionKey,
      listOfWidgets: listOfPageWidgets,
    );
  }

  /// ================    Goal 1 feature 1    ==================== ///

  ///Get Better QuestionsItem
  FeatureViewModel getFeature1Questions() {
    List<Widget> listOfPageWidgets = [];

    List<QuestionsModelList> listOfQuestions = [
      QuestionsModelList(
          questionText: 'Self-control',
          isSelected: false,
          itemIcon: AssetsItems.selfControlIcon),
      QuestionsModelList(
          questionText: 'Concentration',
          isSelected: false,
          itemIcon: AssetsItems.concentration),
      QuestionsModelList(
          questionText: 'Productivity',
          isSelected: false,
          itemIcon: AssetsItems.productivity),
      QuestionsModelList(
          questionText: 'Energy',
          isSelected: false,
          itemIcon: AssetsItems.energy),
    ];

    QuestionsModel listedQuestionsModel = QuestionsModel(
        mainQuestion: "What do you want to\nimprove?",
        featureName: questionsFeature1,
        userGoal: Constants.goal1Key,
        isSelectMultiple: true,
        listOfAnswers: listOfQuestions);

    listOfPageWidgets.add(
        QuestionsView(questionsModel: listedQuestionsModel, isShowGrid: true,key: UniqueKey()));

    listOfPageWidgets.add(SleepQualityQuestion(selectedGoal: Constants.goal1Key,featureName: questionsFeature1,key: UniqueKey()));

    listOfPageWidgets.add(StepsTargetQuestion(selectedGoal: Constants.goal1Key,featureName: questionsFeature1,key: UniqueKey()));

    return FeatureViewModel(
      text1: 'A Journey Towards your\n',
      text2: 'full potential ',
      text3: 'and embracing\n',
      text4: 'self-improvement',
      isAnimationFill: false,
      text1Color: AppTheme.cT!.appColorLight,
      text2Color: AppTheme.cT!.greenColor,
      text3Color: AppTheme.cT!.appColorLight,
      text4Color: AppTheme.cT!.greenColor,
      parentFeatureName: questionsFeature1,
      animation: AssetsItems.swapCardsJson,
      background: AssetsItems.swapCardsBackground,
      listOfWidgets: listOfPageWidgets,
    );
  }

  /// ================    Goal 1 feature 2    ==================== ///



  ///Get Better QuestionsItem
  FeatureViewModel getFeature2Questions() {
    List<Widget> listOfPageWidgets = [];

    List<QuestionsModelList> listOfQuestions = [
      QuestionsModelList(
          questionText: 'More than 3 hours',
          isSelected: false,
          itemIcon: AssetsItems.clockWithPlus),
      QuestionsModelList(
          questionText: '2 to 3 hours',
          isSelected: false,
          itemIcon: AssetsItems.clock30),
      QuestionsModelList(
          questionText: '1 to 2 hours',
          isSelected: false,
          itemIcon: AssetsItems.clock15),
      QuestionsModelList(
          questionText: '30 minutes to 1 hour',
          isSelected: false,
          itemIcon: AssetsItems.clock10),
      QuestionsModelList(
          questionText: 'Less than 30 minutes',
          isSelected: false,
          itemIcon: AssetsItems.clock30),
    ];

    QuestionsModel listedQuestionsModel = QuestionsModel(
        mainQuestion: "Daily time commitment for\nyour goals?",
        userGoal: Constants.goal1Key,
        isSelectMultiple: false,
        featureName: questionsFeature2,
        listOfAnswers: listOfQuestions);

    listOfPageWidgets.add(
      SelectFromSliderQuestion(
        questionsModel: listedQuestionsModel,
        key: UniqueKey(),
      ),
    );

    List<QuestionsModelList> listOfQuestions2 = [
      QuestionsModelList(questionText: 'Procrastination', isSelected: false),
      QuestionsModelList(questionText: 'Overeating', isSelected: false),
      QuestionsModelList(questionText: 'Lack of exercise', isSelected: false),
      QuestionsModelList(
          questionText: 'Poor time management', isSelected: false),
      QuestionsModelList(
          questionText: 'Excessive screen time', isSelected: false),
      QuestionsModelList(questionText: 'Negative self-talk', isSelected: false),
      QuestionsModelList(questionText: 'Sleep deprivation', isSelected: false),
      QuestionsModelList(
          questionText: 'Social media addiction', isSelected: false),
      QuestionsModelList(questionText: 'Smoking', isSelected: false),
      QuestionsModelList(questionText: 'Others', isSelected: false),
    ];

    QuestionsModel listedQuestionsModel2 = QuestionsModel(
        mainQuestion: "Which habits bother you\nthe most?",
        featureName: questionsFeature2,
        userGoal: Constants.goal1Key,
        isSelectMultiple: true,
        listOfAnswers: listOfQuestions2);

    listOfPageWidgets.add(
      QuestionsView(
        questionsModel: listedQuestionsModel2,
        key: UniqueKey(),
      ),
    );

    ///Question 3
    List<QuestionsModelList> listOfQuestions3 = [
      QuestionsModelList(questionText: 'Highly distractible'),
      QuestionsModelList(questionText: 'Very distractible'),
      QuestionsModelList(questionText: 'Moderately distractible'),
      QuestionsModelList(questionText: 'Slightly distractible'),
      QuestionsModelList(questionText: 'Not distractible at all'),
    ];

    QuestionsModel listedQuestionsModel3 = QuestionsModel(
        mainQuestion: "How distractible do you\nconsider yourself?",
        userGoal: Constants.goal1Key,
        featureName: questionsFeature2,
        isSelectMultiple: false,
        listOfAnswers: listOfQuestions3);

    listOfPageWidgets.add(
      StressImpactQuestion(
        questionsModel: listedQuestionsModel3,
        key: UniqueKey(),
      ),
    );

    return FeatureViewModel(
      text1: 'AI Therapy: Personalized\nsupport, advanced features\nfor ',
      text2: 'mental wellness',
      isAnimationFill: false,
      text1Color: AppTheme.cT!.appColorLight,
      text2Color: AppTheme.cT!.greenColor,
      animation: AssetsItems.aiOnboardingRobot,
      parentFeatureName: questionsFeature2,
      background: AssetsItems.mentalWellNessBackground,
      listOfWidgets: listOfPageWidgets,
    );
  }



  /// ================    Goal 1 feature 3    ==================== ///
  ///Get Enhance Personal Questions QuestionsItem
  FeatureViewModel getFeature3Questions() {
    List<Widget> listOfPageWidgets = [];

    List<QuestionsModelList> listOfQuestions1 = [
      QuestionsModelList(
          questionText: 'Well-structured',
          isSelected: false,
          itemIcon: AssetsItems.happyEmoji),
      QuestionsModelList(
          questionText: 'Hectic and stressful',
          isSelected: false,
          itemIcon: AssetsItems.worriedEmoji),
      QuestionsModelList(
          questionText: 'Inconsistent',
          isSelected: false,
          itemIcon: AssetsItems.angryEmoji),
      QuestionsModelList(
          questionText: 'Non-existent',
          isSelected: false,
          itemIcon: AssetsItems.sadEmoji),
    ];

    QuestionsModel listedQuestionsModel1 = QuestionsModel(
        mainQuestion: "What does your current\ndaily routine look like?",
        userGoal: Constants.goal1Key,
        featureName: questionsFeature3,
        isSelectMultiple: false,
        listOfAnswers: listOfQuestions1);

    listOfPageWidgets.add(
      QuestionsView(
        questionsModel: listedQuestionsModel1,
        isShowGrid: true,
        key: UniqueKey(),
      ),
    );

    List<QuestionsModelList> listOfQuestions2 = [
      QuestionsModelList(questionText: 'Restful', isSelected: false),
      QuestionsModelList(
          questionText: 'Occasional interruptions', isSelected: false),
      QuestionsModelList(
          questionText: 'Frequently disturbed', isSelected: false),
      QuestionsModelList(questionText: 'Very poor', isSelected: false),
    ];

    QuestionsModel listedQuestionsModel2 = QuestionsModel(
        mainQuestion: "How is your usual sleep\nquality?",
        featureName: questionsFeature3,
        userGoal: Constants.goal1Key,
        isSelectMultiple: false,
        listOfAnswers: listOfQuestions2);

    listOfPageWidgets.add(
      QuestionsView(
        questionsModel: listedQuestionsModel2,
        key: UniqueKey(),
      ),
    );

    ///Question 3
    List<QuestionsModelList> listOfQuestions3 = [
      QuestionsModelList(
          questionText: 'Strong support system', isSelected: false),
      QuestionsModelList(questionText: 'Moderate support', isSelected: false),
      QuestionsModelList(
          questionText: 'Little support',
          itemSubText: "Don’t worry, we're here for you 💛",
          isSelected: false),
      QuestionsModelList(
          questionText: 'No support',
          itemSubText: "Don’t worry, we're here for you 💛",
          isSelected: false),
    ];

    QuestionsModel listedQuestionsModel3 = QuestionsModel(
        mainQuestion:
            "Do you have a support\nsystem(people) to help you\nmanage stress?",
        userGoal: Constants.goal1Key,
        featureName: questionsFeature3,
        isSelectMultiple: false,
        listOfAnswers: listOfQuestions3);

    listOfPageWidgets.add(
      QuestionsView(
        questionsModel: listedQuestionsModel3,
        key: UniqueKey(),
      ),
    );

    return FeatureViewModel(
      text1: 'Simplify life with our AI ',
      text2: 'AI Routine\nPlanner ',
      text3: 'for stress management\nand daily organization',
      isAnimationFill: false,
      background: AssetsItems.aiRoutinePlanBackground,
      text1Color: AppTheme.cT!.appColorLight,
      text2Color: AppTheme.cT!.orangeColor,
      text3Color: AppTheme.cT!.appColorLight,
      animation: AssetsItems.aiRoutinePlannerJson,
      parentFeatureName: questionsFeature3,
      listOfWidgets: listOfPageWidgets,
    );
  }

  /// ================    Goal 1 feature 4    ==================== ///



  ///Get Enhance Personal Questions QuestionsItem
  FeatureViewModel getFeature4Questions() {
    List<Widget> listOfPageWidgets = [];


    List<QuestionsModelList> listOfQuestions1 = [
      QuestionsModelList(questionText: 'Work-related stress', isSelected: false),
      QuestionsModelList(questionText: 'Relationship difficulties', isSelected: false),
      QuestionsModelList(questionText: 'Financial concerns', isSelected: false),
      QuestionsModelList(questionText: 'Health issues', isSelected: false),
      QuestionsModelList(questionText: 'Academic pressures', isSelected: false),
      QuestionsModelList(questionText: 'Social isolation', isSelected: false),
    ];

    QuestionsModel listedQuestionsModel1 = QuestionsModel(
        mainQuestion: "What challenges are you\ncurrently facing?",
        featureName: questionsFeature4,
        userGoal: Constants.goal1Key,
        isSelectMultiple: true,
        listOfAnswers: listOfQuestions1);

    listOfPageWidgets.add(
      QuestionsView(
        questionsModel: listedQuestionsModel1,
        key: UniqueKey(),
      ),
    );

    return FeatureViewModel(
      text1: 'Track your ',
      text2: 'mood fluctuations.\n',
      text3: "Let's navigate the highs and\nlows ",
      text4: "together",
      isAnimationFill: false,
      text1Color: AppTheme.cT!.appColorLight,
      text2Color: AppTheme.cT!.greyColor,
      text3Color: AppTheme.cT!.appColorLight,
      text4Color: AppTheme.cT!.greyColor,
      background: AssetsItems.moodTrackerBackground,
      animation: AssetsItems.moodTrackerJson,
      parentFeatureName: questionsFeature4,
      listOfWidgets: listOfPageWidgets,
    );
  }
}
