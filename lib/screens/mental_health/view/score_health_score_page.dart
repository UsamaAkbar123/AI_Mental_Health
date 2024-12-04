import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/routes/routes.dart';
import 'package:freud_ai/screens/ai_suggestions/ai_suggesstions_page.dart';

class MentalHealthScorePage extends StatefulWidget {
  const MentalHealthScorePage({super.key});

  @override
  State<MentalHealthScorePage> createState() => _MentalHealthScorePageState();
}

class _MentalHealthScorePageState extends State<MentalHealthScorePage> {
  final assetItems = [
    AssetItem('good.svg', 'Sun'),
    AssetItem('poor.svg', 'Mon'),
    AssetItem('worst.svg', 'Tue'),
    AssetItem('excelent.svg', 'Wed'),
    AssetItem('fair.svg', 'Thu'),
    AssetItem('worst.svg', 'Fri'),
    AssetItem('poor.svg', 'Sat'),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              50.height,
              CommonWidgets().backButton(),
              20.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonWidgets().makeDynamicTextSpan(
                      text1: 'Freud Score\n',
                      text2: 'See your mental score insights',
                      size1: 32,
                      size2: 14,
                      weight2: FontWeight.w400,
                      weight1: FontWeight.w600,
                      color1: AppTheme.cT!.appColorLight,
                      color2: AppTheme.cT!.lightGrey),
                  SvgPicture.asset("assets/home/question_mark.svg"),
                ],
              ),
              20.height,
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                    color: AppTheme.cT!.whiteColor,
                    borderRadius: BorderRadius.circular(10.w)),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CommonWidgets().makeDot(color: AppTheme.cT!.greenColor),
                        CommonWidgets().makeDynamicText(
                            text: "Positive",
                            size: 12,
                            weight: FontWeight.w400,
                            color: AppTheme.cT!.greyColor),
                        30.width,
                        CommonWidgets()
                            .makeDot(color: AppTheme.cT!.orangeColor),
                        CommonWidgets().makeDynamicText(
                            text: "Negative",
                            size: 12,
                            weight: FontWeight.w400,
                            color: AppTheme.cT!.greyColor),
                        const Spacer(),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 5.h),
                          decoration: BoxDecoration(
                            color: AppTheme.cT!.lightBrownColor,
                            borderRadius: BorderRadius.circular(20.w),
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset("assets/home/calender.svg"),
                              CommonWidgets().makeDynamicText(
                                  text: "Monthly",
                                  size: 12,
                                  weight: FontWeight.w400,
                                  color: AppTheme.cT!.greyColor),
                              SvgPicture.asset("assets/common/arrow_down.svg"),
                            ],
                          ),
                        ),
                      ],
                    ),
                    30.height,
                    SvgPicture.asset("assets/home/insight.svg"),
                  ],
                ),
              ),
              20.height,
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                    color: AppTheme.cT!.whiteColor,
                    borderRadius: BorderRadius.circular(10.w)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CommonWidgets().makeDynamicText(
                            text: "Mood history",
                            size: 16,
                            weight: FontWeight.w600,
                            color: AppTheme.cT!.appColorLight),
                        const Icon(Icons.more_horiz_outlined)
                      ],
                    ),
                    SizedBox(
                      height: 80.h,
                      child: ListView.builder(
                          itemCount: assetItems.length,
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(right: 12.w),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                      "assets/assessment/${assetItems[index].assetName}",
                                      width: 32,
                                      height: 32),
                                  CommonWidgets().makeDynamicText(
                                      text: assetItems[index].itemName,
                                      size: 16,
                                      weight: FontWeight.w400,
                                      color: AppTheme.cT!.greyColor),
                                ],
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              ),
              20.height,
              CommonWidgets().customButton(
                text: "Click for AI Suggestion",
                callBack: () => {
                  Navigate.pushNamed(const AiSuggestionPage())
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AssetItem {
  final String assetName;
  final String itemName;

  AssetItem(this.assetName, this.itemName);
}
