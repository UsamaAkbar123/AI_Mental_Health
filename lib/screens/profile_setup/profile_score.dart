import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/extensions.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/routes/routes.dart';
import 'package:freud_ai/screens/splash/splash_screen.dart';

class ProfileScore extends StatelessWidget {
  const ProfileScore({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: AppTheme.cT!.appColorDark,
            child: SvgPicture.asset("assets/profile/ai_score_bg.svg",
                fit: BoxFit.cover),
          ),
          Column(
            children: [
              const SizedBox(height: 80),
              CommonWidgets().makeDynamicText(
                  text: "Your Freud Score",
                  size: 32,
                  weight: FontWeight.bold,
                  align: TextAlign.center,
                  color: AppTheme.cT!.whiteColor),
              30.height,
              Container(
                width: 200,
                height: 200,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    color: Colors.white, shape: BoxShape.circle),
                child: CommonWidgets().makeDynamicText(
                    text: "82",
                    size: 82,
                    weight: FontWeight.bold,
                    align: TextAlign.center,
                    color: AppTheme.cT!.appColorLight),
              ),
              30.height,
              CommonWidgets().makeDynamicText(
                  text:
                      "You’re mentally healthy. We’re redirecting you back home!",
                  size: 26,
                  weight: FontWeight.normal,
                  align: TextAlign.center,
                  color: AppTheme.cT!.whiteColor),
              30.height,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.lightbulb, color: Colors.white),
                    CommonWidgets().makeDynamicText(
                        text: "8 AI suggestions",
                        size: 16,
                        weight: FontWeight.w600,
                        align: TextAlign.center,
                        color: AppTheme.cT!.whiteColor),
                    const Spacer(),
                    const Icon(Icons.sentiment_satisfied, color: Colors.white),
                    10.width,
                    CommonWidgets().makeDynamicText(
                        text: "Overjoyed",
                        size: 16,
                        weight: FontWeight.w600,
                        align: TextAlign.center,
                        color: AppTheme.cT!.whiteColor),
                  ],
                ),
              ),
              30.height,
              GestureDetector(
                onTap: () {
                  Navigate.pushAndRemoveUntil(const SplashScreen());
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 5.h),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.w),
                      border: Border.all(width: 1.w, color: Colors.white)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CommonWidgets().makeDynamicText(
                          text: "I'm Ready",
                          size: 16,
                          weight: FontWeight.w600,
                          align: TextAlign.center,
                          color: AppTheme.cT!.whiteColor),
                      10.width,
                      const Icon(Icons.home_sharp, color: Colors.white)
                    ],
                  ),
                ),
              ),
            ],
          ).centralized()
        ],
      ),
    );
  }
}
