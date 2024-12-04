import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/extensions.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/routes/routes.dart';
import 'package:freud_ai/screens/Widgets/cliper.dart';
import 'package:freud_ai/screens/mental_health/view/mental_health_itemview.dart';
import 'package:freud_ai/screens/mental_health/view/score_health_score_page.dart';

class MentalHealthPage extends StatelessWidget {
  const MentalHealthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: healthBody(context),
    );
  }

  ///Mental Health Body
  Widget healthBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              ClipPath(
                clipper: ClipperClass(),
                child: Container(
                  height: MediaQuery.sizeOf(context).height / 2.h,
                  width: MediaQuery.sizeOf(context).width,
                  color: AppTheme.cT!.brownColor,
                  child: SvgPicture.asset("assets/common/mental_health_bg.svg",
                      fit: BoxFit.cover),
                ),
              ),
              mentalHealthAppBar(),
              mentalHealthScore(),
              insightsButton()
            ],
          ),
          scoreHistory(context),
        ],
      ),
    );
  }


  ///AppBar Mental Health
  Widget mentalHealthAppBar() {
    return Padding(
      padding: EdgeInsets.only(top: 50.h, left: 12.w, right: 12.w),
      child: CommonWidgets().customAppBar(
          text: "Routine Planner",
          borderColor: AppTheme.cT!.whiteColor,
          actionWidget: Container(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
            decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(width: 1.w, color: AppTheme.cT!.whiteColor!),
                borderRadius: BorderRadius.circular(15.w)),
            child: CommonWidgets().makeDynamicText(
                text: "Normal",
                size: 12,
                weight: FontWeight.bold,
                color: AppTheme.cT!.whiteColor),
          )),
    );
  }

  ///Insight button to view full health
  Widget insightsButton() {
    return Positioned(
      bottom: 15.h,
      left: 0,
      right: 0,
      child: CommonWidgets().ovalButton(
        iconData: Icons.bar_chart,
        callBack: () => Navigate.pushNamed(
          const MentalHealthScorePage(),
        ),
      ),
    );
  }

  ///Mental Health Score
  Widget mentalHealthScore() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      top: 0,
      child: CommonWidgets()
          .makeDynamicTextSpan(
              text1: '80\n',
              text2: 'Mentally Stable',
              size1: 52,
              size2: 32,
              weight2: FontWeight.w600,
              weight1: FontWeight.bold,
              align: TextAlign.center,
              color1: AppTheme.cT!.whiteColor,
              color2: AppTheme.cT!.whiteColor)
          .centralized(),
    );
  }

  ///This Widget will show the history of mental health
  Widget scoreHistory(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: CommonWidgets().listViewAboveRow(
              context: context, text1: "Score History", text2: "See All"),
        ),
        ListView.builder(
          itemCount: 14,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return const MentalHealthItemView();
          },
        )
      ],
    );
  }
}
