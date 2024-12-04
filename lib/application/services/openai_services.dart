import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:chat_gpt_flutter/chat_gpt_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:freud_ai/configs/constants/constants.dart';
import 'package:freud_ai/configs/database/shared_pref.dart';
import 'package:freud_ai/screens/routine/bloc/routine_bloc.dart';
import 'package:freud_ai/screens/routine/bloc/routine_event.dart';
import 'package:freud_ai/screens/routine/model/day_daily_routine_planner_model.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';


class OpenAIServices {
  /// A static instance of the OpenAI chat model with the provided API key.
  static final openai = ChatGpt(apiKey: dotenv.env[Constants.openAiAPIKey]!);

  Future<void> startOpenAiService({
    Map<String, dynamic>? query,
    String? chatName,
  }) async {
    String model;

    int maxTokens = 400;

    chatName = 'ChatGPT';

    String prompt = _constructPrompt(query);

    /// Select the appropriate model based on the chatName.
    switch (chatName) {
      ///This Will Call The ChatGPT 3
      case 'ChatGPT':
        // model = ChatGptModel.gpt35Turbo0125.modelName;
        model = ChatGptModel.gpt35Turbo1106.modelName;
        maxTokens = 400;
        break;

      ///This Will Call The ChatGPT 3
      case 'GPT-4':
        // model = ChatGptModel.gpt40125Preview.modelName;
        model = ChatGptModel.gpt35Turbo1106.modelName;
        maxTokens = 5;
        break;

      default:
        // model = ChatGptModel.gpt35Turbo0125.modelName;
        model = ChatGptModel.gpt35Turbo1106.modelName;
        maxTokens = 5;
    }

    try {
      /// Create a chat completion request.
      final chatRequest = ChatCompletionRequest(
        stream: true,
        maxTokens: maxTokens,
        model: model,
        messages: [Message(role: Role.user.name, content: prompt)],
      );

      /// Initiate the chat stream response.
      await _chatStreamResponse(chatRequest);
    } on Exception catch (error) {
      log("PrintedFreudOpenAiLogger : 1 $error");

      ///This is the case when No Internet connection or something else error occured
      saveTheRoutinePlanner(
          StringBuffer(Constants.staticRoutinePlanWhenNotCreated));


      ///FlutterLogger.error(error.toString());
    }
  }



  /// Handles chat stream responses from OpenAI.
  _chatStreamResponse(ChatCompletionRequest request) async {
    StringBuffer responseBuffer = StringBuffer();

    try {
      final stream = await openai.createChatCompletionStream(request);

      stream!.listen(
        (event) {
          if (event.streamMessageEnd) {
            saveTheRoutinePlanner(responseBuffer);
          } else {

            responseBuffer.write(event.choices?.first.delta?.content);

          }
        },
      );
    } catch (error) {
      log("PrintedFreudOpenAiLogger : 2");

      ///This is the case when No Internet connection or something else error occured
      saveTheRoutinePlanner(
        StringBuffer(Constants.staticRoutinePlanWhenNotCreated),
      );
    }
  }

  ///Save The Data
  saveTheRoutinePlanner(StringBuffer responseBuffer) {
    Map<String, dynamic> listOfMap = jsonDecode(responseBuffer.toString());

    log("decode response result before: $listOfMap");

    /// for now the mental health score calculate from onboarding
    /// is store in shared preference
    /// in future will store in sqlite database

    sharedPreferencesManager.setMentalHealthScore = listOfMap["Mental Score"].toString();

   listOfMap.remove("Mental Score");

    log("decode response result after: $listOfMap");

    List<RoutineTaskModel> listOfRoutineModel =
        _getTheMapDataIntoList(listOfMap);

    log("list of routine from bot: $listOfRoutineModel");

    RoutineBloc routineBloc = RoutineBloc();

    routineBloc.add(
      AddRoutinePlanToDatabaseAfterOnboardingEvent(routinePlan: listOfRoutineModel),
    );

    /// just comment it, for now its looks no need for this event
    // routineBloc.add(
    //   RoutinePlannerCreatedEvent(routinePlan: responseBuffer.toString()),
    // );
  }

  ///
  List<RoutineTaskModel> _getTheMapDataIntoList(
      Map<String, dynamic> routineMap) {
    return routineMap.entries.map((entry) {
      /// Create an initial RoutineModel for each entry
      RoutineTaskModel initialModel = RoutineTaskModel().initial();

      /// Modify the taskTitle and value on the 0 index of subTasksList
      RoutineTaskModel modifiedModel = initialModel.copyWith(
        taskRoutineCommonId: const Uuid().v4(),
        taskName: entry.key,
        tagName: "Healthy lifestyle",
        scheduleStartDate: DateFormat('d MMMM y').format(DateTime.now()),
        scheduleEndDate: DateFormat('d MMMM y')
            .format(DateTime.now().add(const Duration(days: 6))),
        subTaskModelList: [
          SubTaskModel(
            /// Assuming the value is a string, modify the SubTaskModel accordingly
            subTaskName: entry.value.toString(),
          ),
          ...initialModel.subTaskModelList?.skip(1) ?? [],
        ],
      );

      return modifiedModel;

    }).toList();
  }

  /// Constructs a detailed prompt including user's responses
  String _constructPrompt(Map<String, dynamic>? userData) {
    var responseFormat =
        '''Given the user's responses about their daily routine,and you should just mentioned the awake and sleep times and water glass numbers,goals for self-improvement, sleep habits, physical activity, time availability for goals, distraction levels, support system, and current challenges, create a personalized daily routine plan. The plan should encompass recommendations for improving self-control, concentration, productivity, and energy levels, taking into account the user's average nightly sleep hours, daily steps goal, and time they can dedicate to their goals. It should offer strategies to combat procrastination, overeating, lack of exercise, poor time management, excessive screen time, negative self-talk, sleep deprivation, social media addiction, and any other specified habits troubling the user. The plan should be supportive and adaptable, recognizing the user's support system strength and the challenges they are currently facing, including work-related stress, relationship difficulties, financial concerns, health issues, academic pressures, and social isolation. and check {user_responses},and return response in  given format
    {
    "Wake up":"{suggested by openAI}",
    "Sleep Time":"{suggested by openAI}",
    "Drink Water":"{suggested by openAI}"
    "Mental Score":"{suggested by openAI in percentage}" 
    }
    ''';

    String prompt = json.encode({
      "prompt": responseFormat,
      "user_responses": userData,

      /// Assuming userData contains the structured user responses
    });

    return prompt;
  }
}
