import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/screens/home/view/chatbot/chatbot_view.dart';
import 'package:freud_ai/screens/home/view/header/home_header_view.dart';
import 'package:freud_ai/screens/home/view/mindful_tracker/mindful_tracker_view.dart';
import 'package:freud_ai/screens/home/view/today_health_metrics/health_metrics_view.dart';

class HomePageView extends StatelessWidget {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppTheme.cT!.scaffoldLight!,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  140.height,
                  const TodayHealthMetricsView(),
                  const MindfulTracker(),
                  const ChatBotView(),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: 140.h,
              child: const HomeHeaderView(),
            ),
          ),
          50.height
        ],
      ),
    );
  }
}
