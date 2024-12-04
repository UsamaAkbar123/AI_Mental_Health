import 'dart:async';

import 'package:chat_gpt_flutter/chat_gpt_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:freud_ai/configs/constants/constants.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/keyboard_observer.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/screens/Widgets/chat_bubble.dart';
import 'package:freud_ai/screens/ai_therapy/bloc/conversation_bloc.dart';
import 'package:freud_ai/screens/ai_therapy/bloc/conversation_event.dart';
import 'package:freud_ai/screens/ai_therapy/screens/conversations/model/conversations_model.dart';
import 'package:freud_ai/screens/ai_therapy/screens/create-conversation/model/selected_conversation_model.dart';
import 'package:freud_ai/screens/ai_therapy/screens/inbox/model/chat_model.dart';
import 'package:freud_ai/screens/ai_therapy/screens/inbox/view/chat_box_header.dart';
import 'package:freud_ai/screens/ai_therapy/screens/inbox/view/chat_text_field.dart';
import 'package:freud_ai/screens/ai_therapy/screens/inbox/view/empty_chat_bot.dart';

class ChatInBoxPage extends StatefulWidget {
  final SelectedConversationModel? selectedConversationModel;
  final ConversationsModel? chatHistoryModel;
  final bool ? isFromRecent;

  const ChatInBoxPage({
    super.key,
    this.chatHistoryModel,
    this.selectedConversationModel,
    this.isFromRecent,
  });

  @override
  State<ChatInBoxPage> createState() => _ChatInBoxPageState();
}

class _ChatInBoxPageState extends State<ChatInBoxPage> {
  ConversationsModel? conversationsModel;

  final ScrollController scrollController = ScrollController();

  TextEditingController textEditingController = TextEditingController();

  String gptResponse = "";
  bool isWidgetVisible = false;

  // FocusNode chatTextFieldFocus = FocusNode();
  SelectedConversationModel? selectedConversationModel;
  StreamSubscription<StreamCompletionResponse>? chatStreamSubscription;
  final chatGpt = ChatGpt(apiKey: dotenv.env[Constants.openAiAPIKey]!);

  ConversationBloc conversationBloc = ConversationBloc();

  @override
  void initState() {
    initializeTheChatScreen();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    if (chatStreamSubscription != null) {
      chatStreamSubscription!.cancel();
    }

    super.dispose();
  }

  ///Here We  Will Initialize the  Chat Screen
  initializeTheChatScreen() {
    if (widget.selectedConversationModel != null) {
      selectedConversationModel = widget.selectedConversationModel;
    } else {
      selectedConversationModel = SelectedConversationModel();
      selectedConversationModel = selectedConversationModel!.copyWith(
          selectedBot: widget.chatHistoryModel!.chatTitle,
          selectedAvatar: widget.chatHistoryModel!.chatLogo,
        aiTherapyIcon: widget.chatHistoryModel!.aiTherapyIcon,
        systemPrompt: widget.chatHistoryModel!.botSystemPrompt,
      );
    }

    if (widget.chatHistoryModel != null) {
      conversationsModel = widget.chatHistoryModel!;
    } else {
      conversationsModel = ConversationsModel(
          chatTitle: selectedConversationModel!.selectedBot,
          chatLogo: selectedConversationModel!.selectedAvatar,
          aiTherapyIcon: selectedConversationModel!.aiTherapyIcon,
          totalChatCount: "0",
          userMoodInChat: "Sad",
          chatType: "Recent",
          botSystemPrompt: selectedConversationModel!.systemPrompt,
          timeStamp: DateTime.now().toString(),
          isFavorite: false,
          listOfChat: const []);
    }

    if (conversationsModel!.listOfChat!.isNotEmpty) {
      ///Jump To The latest message directly
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        }
      });
    }

    if (conversationsModel!.listOfChat!.isEmpty) {
      isWidgetVisible = true;

      /// Add a lifecycle observer to detect when the keyboard is opened or closed
      WidgetsBinding.instance.addObserver(
          KeyboardObserver(onKeyboardVisibilityChanged: (isVisible) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          if (!mounted) return;
          setState(() {
            isWidgetVisible = !isVisible;
          });
        });
      }));
    }
  }

  ///This is Auto Scroll when user come in chat and when send message
  void _scrollToBottom() {
    if (conversationsModel!.listOfChat!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ChatBoxHeader(selectedConversationModel: selectedConversationModel!),
          Expanded(
              child: conversationsModel!.listOfChat!.isNotEmpty
                  ? SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      controller: scrollController,
                      child: Column(
                        children: [
                          conversationsModel!.listOfChat!.isNotEmpty
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: conversationsModel!.listOfChat!.length,
                                  addAutomaticKeepAlives: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.only(
                                      top: 15.h,
                                      bottom: 50.h,
                                      left: 12.w,
                                      right: 12.w),
                                  itemBuilder: (context2, index) {
                                    return ChatBubble(
                                      context: context,
                                      chatModel: conversationsModel!
                                          .listOfChat![index],
                                    );
                                  },
                                )
                              : const SizedBox()
                        ],
                      ),
                    )
                  : isWidgetVisible
                      ? const EmptyChatBot()
                      : const SizedBox()),
          if(widget.isFromRecent == true)
          ChatBoxTextField(
            getFieldData: (controller) => _sendChatMessage(controller),
          )
        ],
      ),
    );
  }



  ///Send Message Chat
  _sendChatMessage(TextEditingController textEditingController) async {
    if (textEditingController.text.trim().isNotEmpty) {
      ChatInboxModel chatModel = ChatInboxModel(
          question: textEditingController.text.trim(),
          isReceived: false,
          answer: StringBuffer(""),
          botName: selectedConversationModel!.selectedBot,
          botPrompt: selectedConversationModel!.systemPrompt,
          conversationAvatar: selectedConversationModel!.selectedAvatar,
          timeStamp: DateTime.now().toString());

      List<ChatInboxModel> addQuestionInChatList =
          List<ChatInboxModel>.from(conversationsModel!.listOfChat!);
      addQuestionInChatList.add(chatModel);
      conversationsModel = conversationsModel!.copyWith(
          listOfChat: addQuestionInChatList,
          totalChatCount: addQuestionInChatList.length.toString());

      final question = textEditingController.text;

      if (conversationsModel!.listOfChat!.length == 1) {
        conversationBloc
            .add(ChatCreateTableEvent(conversationsModel: conversationsModel!));
      } else {
        conversationBloc
            .add(ChatSendMessageEvent(conversationsModel: conversationsModel));
      }

      textEditingController.clear();
      CommonWidgets().hideSoftInputKeyboard(context);
      setState(() => {});

      ///Changing model for Answer
      chatModel = chatModel.copyWith(
          answer: StringBuffer(), isReceived: true, question: "");

      ///This Model is Added for  Answer
      List<ChatInboxModel> addAnswerInChatList =
          List<ChatInboxModel>.from(conversationsModel!.listOfChat!);
      addAnswerInChatList.add(chatModel);
      conversationsModel = conversationsModel!.copyWith(
          listOfChat: addAnswerInChatList,
          totalChatCount: addAnswerInChatList.length.toString());

      _scrollToBottom();

      final testRequest = ChatCompletionRequest(
        stream: true,
        maxTokens: 150,
        // model: ChatGptModel.gpt35Turbo0125.modelName,
        model: ChatGptModel.gpt35Turbo1106.modelName,
        messages: [
          Message(
              role: Role.system.name,
              content: selectedConversationModel!.systemPrompt!),
          Message(role: Role.user.name, content: question),
        ],
      );

      await _chatStreamResponse(testRequest);

      _scrollToBottom();
    }


  }

  ///Chat Stream Response
  _chatStreamResponse(ChatCompletionRequest request) async {
    try {
      final stream = await chatGpt.createChatCompletionStream(request);
      chatStreamSubscription = stream!.listen(
        (event) => setState(
          () {
            if (event.streamMessageEnd) {
              if (conversationsModel!.listOfChat!.length == 2) {
                conversationsModel = conversationsModel!
                    .copyWith(id: conversationBloc.currentChatId);
              }

              conversationBloc.add(
                  ChatSendMessageEvent(conversationsModel: conversationsModel));


              BlocProvider.of<ConversationBloc>(context).add(GetConversationEvent());


              chatStreamSubscription!.cancel();
            } else {
              return conversationsModel!.listOfChat!.last.answer!.write(
                event.choices?.first.delta?.content,
              );
            }
          },
        ),
      );
    } catch (error) {
      setState(() {
        conversationsModel!.listOfChat!.last.answer!
            .write("Something went wrong...");
        _scrollToBottom();
      });
    }
  }
}
