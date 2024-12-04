import 'package:freud_ai/application/app_info_model.dart';
import 'package:freud_ai/screens/routine/model/tags_model.dart';

class Constants {


  static CompleteAppInfoModel? completeAppInfoModel;


  ///Privacy Urls
  static String privacyUrl = "https://bluell.net/privacy";
  static String termsOfUse = "https://bluell.net/terms";
  static String customerSupport = "https://bluell.net/support";
  static String playStoreUrl = "https://play.google.com/store/apps/details?id=com.bluell.ai.mentalhealth&hl=en&gl=US";









  ///Tables Name for SQfLite
  static String openAiAPIKey = "API_KEY";
  static bool isChatBoxCreated = false;
  static String mentalHealthDatabase = "mentalHealthDatabase.db";
  static String chatTableName = "chatsTable";
  static String trashTableName = "trashTable";
  static String goalTableName = "goalsTable";
  static String stepsGoalsTable = "stepsGoalsTable";
  static String stepCounterTableName = "stepCounterTable";
  static const completeAppInfoTableName = "completeAppInfoTable";


  /// implement the new logic for step counter with updated table name

  static const stepCounterGoalTableName = "stepCounterGoalTableName";
  static const bmiTableName = "bmiTableName";
  static const moodTableName = "moodTableName";
  static const personalInformationTableName = "personalInformationTable";
  static const routinePlannerTableName = "routinePlannerTable";
  static const routinePlannerTagsTableName = "routinePlannerTagsTable";

  /// new daily routine planner
  static const dailyRoutinePlannerTableName = "dailyRoutinePlannerTable";
  static const dailyRoutinePlannerTagsTableName = "dailyRoutinePlannerTagsTable";

  static const sleepTableName = "sleepTableName";

  ///Preferences Keys
  static const isStepCounter = false;
  static const saveStepCounterPreferenceKey = "saveStepCounterPreferenceKey";
  static const stepCounterScheduler = "stepCounterScheduler";

  ///Goals Constants
  static String goal1Key = "I want to be a better person";
  static String goal2Key = "I want to try AI therapy";
  static String goal3Key = "I want to reduce stress";
  static String goal4Key = "I want upgrade my lifestyle";



  static String interest1 = "Mindfulness";
  static String interest2 = "Calmness";
  static String interest3 = "Productivity";
  static String interest4 = "Self-control";
  static String interest5 = "Fitness";
  static String interest6 = "Balanced Life";
  static String interest7 = "Self-love";
  static String interest8 = "Passion";
  static String interest9 = "Parenting";
  static String interest10 = "Rewamp";
  static String interest11 = "Anxiety";
  static String interest12 = "Deep Sleep";

  static String selfEvaluationPrompt =
      "Please keep the conversation focused on self-evaluation. Respond to user queries within this domain, and guide them back to topics related to self-assessment if they deviate.";
  static String aiDoctor =
      "Ensure the discussion remains within the AI Doctor domain. Address health-related queries and guide the user back to topics related to medical advice if they stray from this area.";
  static String aiNutrition =
      "Limit the conversation to the AI Nutrition domain. Provide guidance on nutrition-related questions and gently steer the user back to topics centered around dietary advice if they go off track.";
  static String aiGymInstructor =
      "Keep the chat within the AI Gym Instructor domain. Address inquiries about workouts, exercise plans, or fitness advice. Redirect the user to gym-related topics if they inquire about anything outside of this scope.";

  static String dietPlanner = "You are chatting with a person want you to make a diet plan for his/her, so restrict the chat to diet plan , even if he/she asks you to anything else from diet plan,restrict his/her to diet plan";




  static String fromEditScreen = "fromEditScreen";
  static String createNewRoutine = "createNewRoutine";

  static String selectedTag = "Healthy lifestyle";

  final List<TagsModel> routinePlannerTags = [
    const TagsModel(title: "All", isSelected: true),
    const TagsModel(title: "Healthy lifestyle", isSelected: false),
    const TagsModel(title: "Wake up Time", isSelected: false),
    const TagsModel(title: "Morning Routine", isSelected: false),
    const TagsModel(title: "Workout / Exercise", isSelected: false),
    const TagsModel(title: "Breakfast Time", isSelected: false),
    const TagsModel(title: "Commute / Travel", isSelected: false),
    const TagsModel(title: "Office Timing", isSelected: false),
    const TagsModel(title: "Work / School", isSelected: false),
    const TagsModel(title: "Meetings", isSelected: false),
    const TagsModel(title: "Lunch time / Office break", isSelected: false),
    const TagsModel(title: "Appointments", isSelected: false),
    const TagsModel(title: "Evening Routine", isSelected: false),
    const TagsModel(title: "Errands or Shopping", isSelected: false),
    const TagsModel(title: "Dinner", isSelected: false),
    const TagsModel(title: "Hobbies or Activities", isSelected: false),
    const TagsModel(title: "Family Time", isSelected: false),
    const TagsModel(title: "Relaxation", isSelected: false),
    const TagsModel(title: "Self-care", isSelected: false),
    const TagsModel(title: "Bedtime Routine", isSelected: false),
    const TagsModel(title: "Sleep Time", isSelected: false),
    const TagsModel(title: "Weekend Routine", isSelected: false),
    const TagsModel(title: "Wedding Routine", isSelected: false),
  ];

  static String staticRoutinePlanWhenNotCreated = '''{ "Wake up": "6 AM",
    "Sleep Time": "10 PM",
    "Drink Water": "8 Glasses"} ''';
}
