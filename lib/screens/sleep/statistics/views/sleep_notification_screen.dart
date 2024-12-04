import 'package:flutter/material.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/routes/routes.dart';
import 'package:freud_ai/screens/sleep/statistics/views/overall_sleep_graph.dart';
import 'package:lottie/lottie.dart';

class SleepNotificationScreen extends StatelessWidget {
  final bool? isMorningNotification;

  const SleepNotificationScreen({super.key, this.isMorningNotification});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: Column(
          children: [
            const SizedBox(height: 52),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
              decoration: BoxDecoration(
                border: Border.all(width: 1.w, color: AppTheme.cT!.lightGrey!),
                borderRadius: BorderRadius.circular(12.w),
              ),
              child: CommonWidgets().makeDynamicText(
                  text: "Alarm at 10:05",
                  size: 12,
                  color: AppTheme.cT!.appColorLight!),
            ),
            20.height,
            CommonWidgets().makeDynamicText(
                text:
                    "${isMorningNotification! ? "Good Morning" : "Good Night"}, Shinomiya!",
                size: 26,
                weight: FontWeight.w600,
                color: AppTheme.cT!.appColorLight!),
            20.height,
            CommonWidgets().makeDynamicTextSpan(
                text1: isMorningNotification! ? "12" : "06",
                text2: ":",
                text3: "15",
                size1: 42,
                weight1: FontWeight.bold,
                color1: AppTheme.cT!.appColorLight!,
                color2: AppTheme.cT!.brownColor!),
            30.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.schedule_outlined, size: 18.w.h),
                const SizedBox(width: 5),
                CommonWidgets().makeDynamicText(
                    text: "Duration",
                    size: 12,
                    weight: FontWeight.w600,
                    color: AppTheme.cT!.greyColor!),
                20.width,
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: AppTheme.cT!.lightBrownColor,
                    borderRadius: BorderRadius.circular(20.w),
                  ),
                  child: CommonWidgets().makeDynamicText(
                      text: "0:01",
                      size: 16,
                      weight: FontWeight.w600,
                      color: AppTheme.cT!.whiteColor!),
                )
              ],
            ),
            const Spacer(),
            Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Lottie.asset(
                      !isMorningNotification!
                          ? "assets/sleep/good_night.json"
                          : "assets/sleep/morning_notification.json",
                      fit: BoxFit.fitWidth),
                ),
                Positioned(
                  bottom: 40.h,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    width: MediaQuery.sizeOf(context).width,
                    child: CommonWidgets().customButton(
                      text: "Continue",
                      showIcon: true,
                      callBack: () => Navigate.pushNamed(
                        isMorningNotification!
                            ? OverAllSleepGraph()
                            : const SleepNotificationScreen(
                                isMorningNotification: true),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
