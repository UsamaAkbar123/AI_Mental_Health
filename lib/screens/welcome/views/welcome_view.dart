import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/configs/constants/assets.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/routes/routes.dart';
import 'package:freud_ai/screens/Widgets/animated_column.dart';
import 'package:freud_ai/screens/authentication/signin/sign_in.dart';
import 'package:freud_ai/screens/interest/interest_onboarding_page.dart';
import 'package:freud_ai/screens/questions/questionnaire-set1/questionnaire_set1_constants.dart';
import 'package:lottie/lottie.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12.w),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: AnimatedColumnWrapper(
          children: [
            10.height,

            SafeArea(
                child: SvgPicture.asset("assets/welcome/welcome_logo.svg")),

            10.height,

            CommonWidgets().makeDynamicTextSpan(
                text1: "Welcome to your",
                text2: " mental\nhealth",
                text3: " journey",
                size1: 30,
                weight1: FontWeight.w800,
                color1: AppTheme.cT!.appColorLight,
                color2: AppTheme.cT!.brownColor,
                color3: AppTheme.cT!.appColorLight,
                align: TextAlign.center),


            10.height,
            CommonWidgets().makeDynamicText(
                text:
                    "Where you can track and improve various aspects of your well-being 🍃",
                size: 18,
                weight: FontWeight.w500,
                align: TextAlign.center,
                color: AppTheme.cT!.greyColor),
            20.height,
            SizedBox(
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height / 2.5.h,
              child: Lottie.asset(AssetsItems.welcomeJson),
            ),
            20.height,
            CommonWidgets().customButton(
                text: "Get Started",
                showIcon: true,
                callBack: () => getStartedClickListener()),
            30.height,
            /*CommonWidgets().makeDynamicTextSpan(
                text1: "Already have an account ? ",
                text2: "Sign in",
                size1: 14,
                showUnderLine2: true,
                weight1: FontWeight.w700,
                onText2Click: () => handleSignInClickListener(),
                color1: AppTheme.cT!.greyColor,
                color2: AppTheme.cT!.greenColor),*/
          ],
        ),
      ),
    );
  }

  ///Get Started Button Click Listener
  getStartedClickListener() {
    Navigate.pushNamed(InterestsOnboardingPage(featureViewModel: QuestionnaireSet1Constants().getGoalQuestion()));
  }



  ///Here we will handle the click listener
  handleSignInClickListener() {
    Navigate.pushNamed(const SignInPage());
  }
}
