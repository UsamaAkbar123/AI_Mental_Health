import 'package:flutter/material.dart';
import 'package:freud_ai/configs/constants/assets.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/routes/routes.dart';
import 'package:freud_ai/screens/Widgets/animated_column.dart';
import 'package:freud_ai/screens/ai_therapy/screens/create-conversation/new_conversation.dart';
import 'package:lottie/lottie.dart';

class AiBotsPage extends StatelessWidget {
  const AiBotsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: aiBotsPageBody());
  }

  ///AI Bots Page Body
  Widget aiBotsPageBody() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 12.w, right: 12.w, top: 50.h),
          child: CommonWidgets().customAppBar(
              text: "Mindful AI Chatbot",
              borderColor: AppTheme.cT!.appColorLight),
        ),
        Expanded(
          child: AnimatedColumnWrapper(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(AssetsItems.welcomeJson),
              20.height,
              CommonWidgets().makeDynamicText(
                  text: "Talk to Doctor Freud AI",
                  size: 22,
                  weight: FontWeight.w700,
                  align: TextAlign.center,
                  color: AppTheme.cT!.appColorLight),
              10.height,
              CommonWidgets().makeDynamicText(
                  text:
                      "You have no AI conversations. Get your\nmind healthy by starting a new one.",
                  size: 14,
                  align: TextAlign.center,
                  color: AppTheme.cT!.greyColor),
              30.height,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: CommonWidgets().customButton(
                    text: "Start New Chat",
                    buttonColor: AppTheme.cT!.orangeColor,
                    showIcon: true,
                    callBack: () async {
                      Navigate.pushAndReplace(const CreateConversationBots());
                    },
                    icon: "assets/common/plus_ic.svg"),
              )
            ],
          ),
        ),
      ],
    );
  }
}
