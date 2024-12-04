import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/routes/routes.dart';
import 'package:freud_ai/screens/ai_suggestions/suggestion_activity.dart';

class AiSuggestionPage extends StatefulWidget {
  const AiSuggestionPage({super.key});

  @override
  State<AiSuggestionPage> createState() => _AiSuggestionPageState();
}

class _AiSuggestionPageState extends State<AiSuggestionPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            aiSuggestionHeader(),
            aiSuggestionDetail(),
            aiSuggestionsItemView()
          ],
        ),
      ),
    );
  }

  Widget aiSuggestionHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: ShapeDecoration(
        color: AppTheme.cT!.appColorLight!,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(40.w),
              bottomLeft: Radius.circular(40.w)),
        ),
        shadows: [
          const BoxShadow(
            color: Color(0x0C4B3425),
            blurRadius: 0,
            offset: Offset(0, 0),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: const Color(0x0C4B3425),
            blurRadius: 15.w,
            offset: const Offset(0, 7),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: const Color(0x0A4B3425),
            blurRadius: 28.w,
            offset: const Offset(0, 28),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: const Color(0x074B3425),
            blurRadius: 37.w,
            offset: const Offset(0, 62),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: const Color(0x024B3425),
            blurRadius: 44.w,
            offset: const Offset(0, 110),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: const Color(0x004B3425),
            blurRadius: 48.w,
            offset: const Offset(0, 172),
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          40.height,
          CommonWidgets().backButton(borderColor: AppTheme.cT!.whiteColor),
          10.height,
          CommonWidgets().makeDynamicText(
              text: "Ai Score Suggestion",
              size: 32,
              weight: FontWeight.w700,
              color: AppTheme.cT!.whiteColor),
          10.height,
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset("assets/home/light.svg",
                  width: 16.w, height: 16.h),
              4.width,
              CommonWidgets().makeDynamicText(
                  text: "52 Total",
                  size: 12,
                  weight: FontWeight.w700,
                  color: AppTheme.cT!.whiteColor),
              30.width,
              CommonWidgets().makeDot(color: AppTheme.cT!.whiteColor),
              SvgPicture.asset("assets/home/gpt.svg",
                  width: 16.w, height: 16.h),
              4.width,
              CommonWidgets().makeDynamicText(
                  text: "Gpt",
                  size: 12,
                  weight: FontWeight.w700,
                  color: AppTheme.cT!.whiteColor),
            ],
          ),
          10.height,
        ],
      ),
    );
  }

  Widget aiSuggestionDetail() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 20.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CommonWidgets().makeDynamicText(
              text: "All Suggestions",
              size: 16,
              weight: FontWeight.w700,
              color: AppTheme.cT!.appColorLight),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: AppTheme.cT!.lightBrownColor,
              borderRadius: BorderRadius.circular(20.w),
            ),
            child: Row(
              children: [
                SvgPicture.asset("assets/home/calender.svg"),
                const SizedBox(width: 5),
                CommonWidgets().makeDynamicText(
                    text: "All time",
                    size: 12,
                    weight: FontWeight.w400,
                    color: AppTheme.cT!.greyColor),
                SvgPicture.asset("assets/common/arrow_down.svg"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget aiSuggestionsItemView() {
    return ListView.builder(
      itemCount: 10,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: (){
            Navigate.pushNamed(const SuggestionActivity());
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
            padding: EdgeInsets.all(16.w),
            width: MediaQuery.sizeOf(context).width,
            decoration: BoxDecoration(
                color: AppTheme.cT!.whiteColor,
                borderRadius: BorderRadius.circular(20.w)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 50.w,
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppTheme.cT!.greenColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.share,
                              color: AppTheme.cT!.whiteColor!),
                        ),
                        Container(
                          width: 50.w,
                          height: 50,
                          margin: const EdgeInsets.only(left: 25),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 2, color: AppTheme.cT!.whiteColor!),
                              color: AppTheme.cT!.purpleColor,
                              shape: BoxShape.circle),
                          child: Icon(Icons.auto_graph,
                              color: AppTheme.cT!.whiteColor!),
                        ),
                        Container(
                          width: 50.w,
                          height: 50,
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(left: 50),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 2, color: AppTheme.cT!.whiteColor!),
                              color: AppTheme.cT!.orangeColor,
                              shape: BoxShape.circle),
                          child: CommonWidgets().makeDynamicText(
                              text: "8+",
                              size: 16,
                              weight: FontWeight.w700,
                              color: AppTheme.cT!.whiteColor),
                        ),
                      ],
                    ),
                    10.height,
                    CommonWidgets().makeDynamicText(
                        text: "Mindfulness Activities",
                        size: 18,
                        weight: FontWeight.w700,
                        color: AppTheme.cT!.appColorLight),
                    Row(
                      children: [
                        CommonWidgets().makeDynamicText(
                            text: "Breathing, Relax",
                            size: 12,
                            weight: FontWeight.w500,
                            color: AppTheme.cT!.greyColor),
                        10.width,
                        CommonWidgets()
                            .makeDot(color: AppTheme.cT!.appColorLight),
                        10.width,
                        CommonWidgets().makeDynamicText(
                            text: "25-30min",
                            size: 12,
                            weight: FontWeight.w500,
                            color: AppTheme.cT!.greyColor),
                      ],
                    )
                  ],
                ),
                SvgPicture.asset("assets/home/arrow_forward.svg"),
              ],
            ),
          ),
        );
      },
    );
  }
}
