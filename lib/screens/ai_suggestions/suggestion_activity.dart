import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';

class SuggestionActivity extends StatefulWidget {
  const SuggestionActivity({super.key});

  @override
  State<SuggestionActivity> createState() => _SuggestionActivityState();
}

class _SuggestionActivityState extends State<SuggestionActivity> {

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
        color: AppTheme.cT!.greenColor!,
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
              text: "Mindfullness\nActivities",
              size: 32,
              weight: FontWeight.w700,
              color: AppTheme.cT!.whiteColor),
          10.height,
        ],
      ),
    );
  }

  Widget aiSuggestionDetail() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.h),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: CommonWidgets().listViewAboveRow(
                context: context, text1: "All Suggestions", text2: "See All"),
          ),
          10.height,
          aiSuggestionsItemView(),
          20.height,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: CommonWidgets().listViewAboveRow(
                context: context, text1: "MindFull Resources", text2: "See All"),
          ),
          Container(
            margin: EdgeInsets.all(12.w),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppTheme.cT!.whiteColor,
              borderRadius: BorderRadius.circular(20.w),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset('assets/home/video.png'),
                10.height,
                CommonWidgets().makeDynamicText(
                    text: "Why should we be mindful?",
                    size: 20,
                    weight: FontWeight.w700,
                    color: AppTheme.cT!.appColorLight),
                15.height,
                CommonWidgets().makeDynamicText(
                    text:
                        "Mindfulness, the practice of being fully present and engaged in the moment, has become increasingly important in our fast-paced world. It's not just a trend; it's a vital tool for enhancing overall well-being.",
                    size: 14,
                    weight: FontWeight.w400,
                    color: AppTheme.cT!.greyColor),
                20.height,
                Row(
                  children: [
                    SvgPicture.asset("assets/common/check_mark.svg"),
                    CommonWidgets().makeDynamicText(
                        text: "Reduce Stress",
                        size: 12,
                        weight: FontWeight.w500,
                        color: AppTheme.cT!.appBlackColor),
                    const Spacer(),
                    SvgPicture.asset("assets/common/check_mark.svg"),
                    CommonWidgets().makeDynamicText(
                        text: "Improve health",
                        size: 12,
                        weight: FontWeight.w500,
                        color: AppTheme.cT!.appBlackColor),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }


  ///Ai All Suggestions ItemView
  Widget aiSuggestionsItemView() {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        itemCount: 10,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 5.h),
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 5.w),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
                color: AppTheme.cT!.whiteColor,
                borderRadius: BorderRadius.circular(20.w)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset("assets/home/stress.svg",
                    width: 32, height: 32),
                const Spacer(),
                Expanded(
                  child: CommonWidgets().makeDynamicText(
                      text: "Daily motivation\nRoutine",
                      size: 16,
                      weight: FontWeight.w600,
                      color: AppTheme.cT!.appColorLight),
                ),
              ],
            ),
          );
        },
      ),
    );
  }


  ///Mark As complete Button
  Widget markAsComplete(){
    return CommonWidgets().customButton(text: 'Mark as complete',showIcon: true,icon: "");
  }



}
