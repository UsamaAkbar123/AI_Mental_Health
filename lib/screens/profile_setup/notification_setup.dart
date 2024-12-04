import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/routes/routes.dart';
import 'package:freud_ai/screens/Widgets/animated_switch.dart';
import 'package:freud_ai/screens/profile_setup/profile_completion.dart';

class NotificationSetup extends StatefulWidget {
  const NotificationSetup({super.key});

  @override
  State<NotificationSetup> createState() => _NotificationSetupState();
}

class _NotificationSetupState extends State<NotificationSetup> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.cT!.lightGreenColor,
      body: SizedBox(
        height: MediaQuery.sizeOf(context).height,
        child: Stack(
          children: [
            Positioned(
                top: 0,
                child: SvgPicture.asset("assets/profile/notification_bg.svg")),
            settingsView(),
            appBarWidget(),
          ],
        ),
      ),
    );
  }

  ///AppBar
  Widget appBarWidget() {
    return Container(
      margin: EdgeInsets.only(top: 50.h, left: 12.w, right: 12.w),
      child: Row(
        children: [
          CommonWidgets().backButton(borderColor: AppTheme.cT!.appColorLight),
          10.width,
          CommonWidgets().makeDynamicText(
              text: "Notification Setup",
              size: 28,
              weight: FontWeight.w600,
              color: AppTheme.cT!.appColorLight)
        ],
      ),
    );
  }



  ///Settings View
  Widget settingsView() {
    return Positioned(
      bottom: 0,
      child: Stack(
        children: [
          SvgPicture.asset(
            "assets/common/round_bg.svg",
            alignment: Alignment.center,
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height / 2,
          ),
          SizedBox(
            width: MediaQuery.sizeOf(context).width,
            child: Container(
              margin: EdgeInsets.only(top: 50.h),
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CommonWidgets().makeDynamicText(
                        text: "Freud Notification Setup",
                        size: 28,
                        weight: FontWeight.w600,
                        color: AppTheme.cT!.appColorLight),
                    30.height,
                    notificationView(
                        text: "AI Chatbot Notification", icon: "ai_chat.svg"),
                    20.height,
                    notificationView(
                        text: "Mental Journal Notification",
                        icon: "mental_journal.svg"),
                    20.height,
                    notificationView(
                        text: "Mood Tracker Notification",
                        icon: "mood_tracker.svg"),
                    20.height,
                    CommonWidgets().customButton(
                      text: "continue",
                      showIcon: true,
                      callBack: () => Navigate.pushNamed(
                        const ProfileCompletion(),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  ///Notification View
  Widget notificationView({text, icon}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset("assets/profile/$icon"),
        10.width,
        CommonWidgets().makeDynamicText(
            text: text,
            size: 16,
            weight: FontWeight.w500,
            color: AppTheme.cT!.appColorLight),
        const Spacer(),
        const AnimatedSwitch()
      ],
    );
  }
}
