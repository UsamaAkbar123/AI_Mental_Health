import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/configs/constants/assets.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/screens/Widgets/animated_column.dart';
import 'package:freud_ai/screens/feedback/model/feed_back_model.dart';

class FeedBackPage extends StatefulWidget {
  const FeedBackPage({super.key});

  @override
  State<FeedBackPage> createState() => _FeedBackPageState();
}

class _FeedBackPageState extends State<FeedBackPage> {
  List<FeedBackModel> feedBackList = [
    FeedBackModel(
        feedBackText: "Performance",
        backgroundColor: AppTheme.cT!.greenColor!,
        isSelected: false),
    FeedBackModel(
        feedBackText: "Bug",
        backgroundColor: AppTheme.cT!.orangeColor!,
        isSelected: false),
    FeedBackModel(
        feedBackText: "User Experience",
        backgroundColor: AppTheme.cT!.greenColor!,
        isSelected: false),
    FeedBackModel(
        feedBackText: "Crashes",
        backgroundColor: AppTheme.cT!.orangeColor!,
        isSelected: false),
    FeedBackModel(
        feedBackText: "Loading",
        backgroundColor: AppTheme.cT!.greenColor!,
        isSelected: false),
    FeedBackModel(
        feedBackText: "Support",
        backgroundColor: AppTheme.cT!.greenColor!,
        isSelected: false),
    FeedBackModel(
        feedBackText: "Navigation",
        backgroundColor: AppTheme.cT!.yellowColor!,
        isSelected: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SvgPicture.asset(AssetsItems.feedBackBackground,
              height: MediaQuery.sizeOf(context).height,
              width: MediaQuery.sizeOf(context).width),
          Column(
            children: [
              50.height,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: CommonWidgets().customAppBar(
                    text: "Send Feedback",
                    borderColor: AppTheme.cT!.whiteColor),
              ),
              32.height,
            ],
          ),
          Positioned(
            bottom: 0,
            child: Container(
              height: MediaQuery.sizeOf(context).height / 1.4.h,
              width: MediaQuery.sizeOf(context).width,
              decoration: BoxDecoration(
                color: AppTheme.cT!.whiteColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.w),
                  topRight: Radius.circular(40.w),
                ),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: AnimatedColumnWrapper(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    50.height,
                    CommonWidgets().makeDynamicText(
                        text: "Which of the area\nneeds improvement?",
                        size: 30,
                        color: AppTheme.cT!.appColorLight,
                        align: TextAlign.center,
                        weight: FontWeight.w800),
                    30.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        feedbacksView(feedBackModel: feedBackList[0]),
                        20.width,
                        feedbacksView(feedBackModel: feedBackList[1]),
                      ],
                    ),
                    20.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        feedbacksView(feedBackModel: feedBackList[2]),
                      ],
                    ),
                    20.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        feedbacksView(feedBackModel: feedBackList[3]),
                        20.width,
                        feedbacksView(feedBackModel: feedBackList[4]),
                      ],
                    ),
                    20.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        feedbacksView(feedBackModel: feedBackList[5]),
                        20.width,
                        feedbacksView(feedBackModel: feedBackList[6]),
                      ],
                    ),
                    30.height,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child:
                          CommonWidgets().customButton(text: "Send Feedback",showIcon: true),
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: MediaQuery.sizeOf(context).height / 1.4.h - 50.h,
            child: Container(
              width: 100,
              height: 100,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.cT!.whiteColor,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x0C4B3425),
                      blurRadius: 16.w,
                      offset: const Offset(0, 8),
                      spreadRadius: 0,
                    )
                  ]),
              child: SvgPicture.asset(AssetsItems.feedBackEmoji),
            ),
          ),
        ],
      ),
    );
  }


  ///GridView Data
  Widget showGridList() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: AnimationLimiter(
        child: GridView.builder(
            itemCount: feedBackList.length,
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 20.h),
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 40,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 20.0,
            ),
            itemBuilder: (context, index) {
              return AnimationConfiguration.staggeredGrid(
                position: index,
                duration: const Duration(milliseconds: 800),
                columnCount: 2,
                child: ScaleAnimation(
                  child: FadeInAnimation(
                    child: feedbacksView(feedBackModel: feedBackList[index]),
                  ),
                ),
              );
            }),
      ),
    );
  }

  ///FeedBack ItemView
  Widget feedbacksView({FeedBackModel? feedBackModel}) {
    return InkWell(
      onTap: () {
        feedBackModel.isSelected = !feedBackModel.isSelected!;
        setState(() => {});
      },
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 42.w, vertical: 10.h),
        decoration: BoxDecoration(
            color: feedBackModel!.isSelected!
                ? feedBackModel.backgroundColor
                : null,
            borderRadius: BorderRadius.circular(100.w),
            border: Border.all(
                width: 1.w,
                color: feedBackModel.isSelected!
                    ? Colors.transparent
                    : AppTheme.cT!.appColorLight!)),
        child: CommonWidgets().makeDynamicText(
            text: feedBackModel.feedBackText,
            size: 16,
            color: feedBackModel.isSelected!
                ? AppTheme.cT!.whiteColor
                : AppTheme.cT!.appColorLight,
            align: TextAlign.center,
            weight: FontWeight.w800),
      ),
    );
  }



}
