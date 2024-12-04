import 'package:flutter/material.dart';
import 'package:freud_ai/configs/constants/assets.dart';
import 'package:freud_ai/configs/constants/constants.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/routes/routes.dart';
import 'package:freud_ai/screens/ai_therapy/screens/create-conversation/model/conversation_bot_model.dart';
import 'package:freud_ai/screens/ai_therapy/screens/create-conversation/model/selected_conversation_model.dart';
import 'package:freud_ai/screens/ai_therapy/screens/create-conversation/view/conversation_avatars.dart';
import 'package:freud_ai/screens/ai_therapy/screens/create-conversation/view/conversation_bots.dart';
import 'package:freud_ai/screens/ai_therapy/screens/inbox/chat_box_page.dart';

class CreateConversationBots extends StatefulWidget {
  const CreateConversationBots({super.key});

  @override
  State<CreateConversationBots> createState() => _CreateConversationBotsState();
}

class _CreateConversationBotsState extends State<CreateConversationBots> {
  SelectedConversationModel? selectedConversationModel;


  @override
  void initState() {
    super.initState();

    selectedConversationModel = SelectedConversationModel(
      selectedBot: 'AI Doctor',
      systemPrompt: Constants.aiDoctor,
      selectedAvatar: AssetsItems.conversationAvatar12,
      aiTherapyIcon: AssetsItems.aiDoctor,
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          selectConversationHeader(),
          conversationAvatarSelector(),
        ],
      ),
    );
  }

  ///Conversation Header
  conversationAvatarSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        32.height,

        /// Conversation Icon
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: CommonWidgets().makeDynamicText(
              size: 16,
              weight: FontWeight.w800,
              text: "Ai Therapy Assistant",
              color: AppTheme.cT!.appColorLight),
        ),
        8.height,
        ConversationBots(selectConversationBot: (value) {
          ConversationBotModel conversationBotModel = value;
          selectedConversationModel = selectedConversationModel!.copyWith(
              selectedBot: conversationBotModel.aiBotName,
            systemPrompt: conversationBotModel.botPrompt,
            aiTherapyIcon: conversationBotModel.itemIcon,
          );
        }),
        24.height,

        /// Conversation Icon
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: CommonWidgets().makeDynamicText(
              size: 16,
              weight: FontWeight.w800,
              text: "Conversation Icon",
              color: AppTheme.cT!.appColorLight),
        ),

        8.height,

        ///  Profile Avatars
        ConversationAvatars(
            selectedConversationItem: (value) =>
              selectedConversationModel = selectedConversationModel!.copyWith(selectedAvatar: value)
            ),

        32.height,

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: CommonWidgets().customButton(
            text: "Create Conversation",
            icon: AssetsItems.plusWithCircle,
            showIcon: true,
            callBack: () => Navigate.pushAndReplace(ChatInBoxPage(selectedConversationModel: selectedConversationModel)),
          ),
        )
      ],
    );
  }

  ///Account Settings Header
  Widget selectConversationHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: ShapeDecoration(
        color: AppTheme.cT!.appColorLight!,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(40.w),
              bottomLeft: Radius.circular(40.w)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          40.height,
          CommonWidgets().customAppBar(borderColor: AppTheme.cT!.whiteColor),
          12.height,
          CommonWidgets().makeDynamicText(
              text: "New  Conversation",
              size: 36,
              align: TextAlign.left,
              weight: FontWeight.w800,
              color: AppTheme.cT!.whiteColor),
          12.height,
        ],
      ),
    );
  }
}
