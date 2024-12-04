import 'package:flutter/material.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/extensions.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/routes/routes.dart';
import 'package:freud_ai/screens/sleep/statistics/views/new_sleep_schedule.dart';

class ShowSleepStat extends StatefulWidget {
  const ShowSleepStat({super.key});

  @override
  State<ShowSleepStat> createState() => _ShowSleepStatState();
}

class _ShowSleepStatState extends State<ShowSleepStat>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _animation = Tween<double>(begin: 0.0, end: 0.25).animate(_controller);
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            40.height,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: CommonWidgets().customAppBar(),
            ),
            CommonWidgets().makeDynamicText(
                text: "You Slept for",
                size: 28,
                weight: FontWeight.w600,
                color: AppTheme.cT!.appColorLight),
            const SizedBox(height: 60),
            SizedBox(
              height: 240,
              width: 240,
              child: Stack(
                children: [
                  SizedBox(
                    height: 220,
                    width: 220,
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return CircularProgressIndicator(
                          value: _animation.value,
                          strokeWidth: 30,
                          backgroundColor: AppTheme.cT!.lightGrey50,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.cT!.purpleColor!),
                        );
                      },
                    ),
                  ),
                  CommonWidgets()
                      .makeDynamicTextSpan(
                          text1: '2.25 ',
                          text2: 'h',
                          size1: 42,
                          size2: 22,
                          weight1: FontWeight.bold,
                          weight2: FontWeight.w700,
                          align: TextAlign.center,
                          color1: AppTheme.cT!.appColorLight,
                          color2: AppTheme.cT!.lightGrey)
                      .centralized()
                ],
              ),
            ),
            30.height,
            CommonWidgets().makeDynamicText(
                text: "You’re insomniac. You should\nget more sleep!",
                size: 22,
                align: TextAlign.center,
                weight: FontWeight.w600,
                color: AppTheme.cT!.appColorLight),
            const Spacer(),
            CommonWidgets().customButton(
              text: "Got It, Thanks!",
              showIcon: false,
              callBack: () => Navigate.pushNamed(const NewSleepSchedule()),
            ),
            30.height,
          ],
        ),
      ),
    );
  }
}
