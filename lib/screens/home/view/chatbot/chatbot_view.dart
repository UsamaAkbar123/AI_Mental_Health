import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/configs/constants/constants.dart';
import 'package:freud_ai/configs/database/database_helper.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/extensions.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/routes/routes.dart';
import 'package:freud_ai/screens/ai_therapy/ai_bots_page.dart';
import 'package:freud_ai/screens/ai_therapy/bloc/conversation_bloc.dart';
import 'package:freud_ai/screens/ai_therapy/bloc/conversation_event.dart';
import 'package:freud_ai/screens/ai_therapy/screens/conversations/conversation_inbox_page.dart';

class ChatBotView extends StatefulWidget {
  const ChatBotView({super.key});

  @override
  State<ChatBotView> createState() => _ChatBotViewState();
}

class _ChatBotViewState extends State<ChatBotView> {
  @override
  void initState() {
    context.read<ConversationBloc>().add(GetConversationEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final conversationBloc = context.read<ConversationBloc>();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonWidgets().makeDynamicText(
              text: "AI Therapy Chatbot",
              size: 18,
              weight: FontWeight.w800,
              color: AppTheme.cT!.appColorDark),
          10.height,
          Stack(
            children: [
              SvgPicture.asset("assets/home/chatbot_bg.svg"),
              Positioned(
                bottom: 10.h,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buttonContainer(
                        color: AppTheme.cT!.greenColor,
                        icon: Icons.add,
                        shadowColor: AppTheme.cT!.lightGreenColor),
                    //20.width,
                    /*buttonContainer(
                        color: AppTheme.cT!.orangeColor,
                        icon: Icons.settings,
                        shadowColor: AppTheme.cT!.lightGreenColor),*/
                  ],
                ),
              ),
              Positioned(bottom: 0, top: 25.h, child: aiTherapyChat())
            ],
          )
        ],
      ),
    ).clickListener(click: () async {
      /// if chat table exist and list of chat history or trash history is not empty
      /// then user will navigate to Conversation Inbox Page
      /// else
      /// user will redirect to Ai Bots Page

      if (await databaseHelper.isTableExist(Constants.chatTableName) &&
          (conversationBloc.state.listOfChatHistoryModel!.isNotEmpty ||
              conversationBloc.state.listOfTrashChatHistory!.isNotEmpty)) {
        Navigate.pushNamed(const ConversationInboxPage());
      } else {
        Navigate.pushNamed(const AiBotsPage());
      }
    });
  }

  ///Shadow Button
  Widget buttonContainer({color, icon, shadowColor}) {
    return Container(
      width: 50.w,
      height: 50.h,
      alignment: Alignment.center,
      decoration: ShapeDecoration(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.w),
        ),
        shadows: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 32.w,
            offset: const Offset(0, 16),
            spreadRadius: 0,
          )
        ],
      ),
      child: Icon(icon, color: AppTheme.cT!.whiteColor),
    );
  }

  ///Ai Therapy Chat
  Widget aiTherapyChat() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonWidgets().makeDynamicTextSpan(
              text1: "AI\n",
              text2: "Conversations",
              size1: 26,
              size2: 16,
              weight1: FontWeight.w700,
              color1: AppTheme.cT!.whiteColor),
          20.height,
          Row(
            children: [
              SvgPicture.asset("assets/home/calender.svg"),
              10.width,
              CommonWidgets().makeDynamicText(
                  text: "AI-powered Chatbots",
                  size: 16,
                  weight: FontWeight.w500,
                  color: AppTheme.cT!.whiteColor),
            ],
          ),
          /*Row(
            children: [
              Icon(Icons.star, color: AppTheme.cT!.whiteColor, size: 20.w.h),
              10.width,
              CommonWidgets().makeDynamicText(
                  text: "Go pro now",
                  size: 16,
                  weight: FontWeight.w500,
                  color: AppTheme.cT!.whiteColor),
            ],
          ),*/
        ],
      ),
    );
  }
}
