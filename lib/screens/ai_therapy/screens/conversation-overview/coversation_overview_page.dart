import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/screens/ai_therapy/screens/conversations/view/conversation_header.dart';

class ConversationOverviewPage extends StatefulWidget {
  const ConversationOverviewPage({super.key});

  @override
  State<ConversationOverviewPage> createState() => _ConversationOverviewPageState();
}

class _ConversationOverviewPageState extends State<ConversationOverviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ConversationHeader(context: context),
          20.height,
          chatProWidget()
        ],
      ),
    );
  }


  ///Chat Pro Card
  Widget chatProWidget() {
    return Stack(
      children: [
        SvgPicture.asset("assets/ai/chat_pro.svg"),
        proChatCard(),
      ],
    );
  }



  ///
  Widget proChatCard() {
    return Positioned(
      right: 20,
      top: 10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonWidgets().makeDynamicText(
              text: "Upgrade to Pro!",
              size: 20,
              weight: FontWeight.w600,
              color: AppTheme.cT!.appColorLight),
          10.height,
          upgradeRowTexts(text: "24/7 Live & Fast Support"),
          const SizedBox(height: 5),
          upgradeRowTexts(text: "Unlimited Conversations!"),
          10.height,
          SizedBox(
              height: 42.h,
              child: CommonWidgets().customButton(text: "Go Pro, Now!"))
        ],
      ),
    );
  }

  Widget upgradeRowTexts({text}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(Icons.check_circle, color: AppTheme.cT!.appColorLight),
        CommonWidgets().makeDynamicText(
            text: text,
            size: 13,
            weight: FontWeight.w500,
            color: AppTheme.cT!.greyColor),
      ],
    );
  }
}