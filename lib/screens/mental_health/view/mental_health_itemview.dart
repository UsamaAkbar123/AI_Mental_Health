import 'package:flutter/material.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/extensions.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';

class MentalHealthItemView extends StatelessWidget {
  const MentalHealthItemView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 12.w),
      child: Container(
          padding: EdgeInsets.all(16.w),
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: AppTheme.cT!.whiteColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22.w),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 50.w,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: AppTheme.cT!.scaffoldLight,
                    borderRadius: BorderRadius.circular(12.w)),
                child: CommonWidgets().makeDynamicTextSpan(
                    text1: 'Sep\n',
                    text2: '12',
                    size1: 16,
                    size2: 16,
                    weight2: FontWeight.w500,
                    weight1: FontWeight.w500,
                    align: TextAlign.center,
                    color1: AppTheme.cT!.greyColor,
                    color2: AppTheme.cT!.appColorDark),
              ),
              12.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonWidgets().makeDynamicText(
                      text: "Anxious, Depressed",
                      size: 18,
                      weight: FontWeight.w600,
                      color: AppTheme.cT!.appColorLight),
                  const SizedBox(height: 8),
                  CommonWidgets().makeDynamicText(
                      text: "No Recommendation.",
                      size: 14,
                      weight: FontWeight.w400,
                      color: AppTheme.cT!.greyColor),
                ],
              ),
              const Spacer(),
              sleepProgress()
            ],
          )),
    );
  }

  ///Sleep Progress
  Widget sleepProgress() {
    return SizedBox(
      height: 40.h,
      width: 40.w,
      child: Stack(
        children: [
          SizedBox(
            height: 40.h,
            width: 40.w,
            child: CircularProgressIndicator(
              value: 0.2,
              backgroundColor: AppTheme.cT!.lightBrownColor,
              valueColor:
                  AlwaysStoppedAnimation<Color>(AppTheme.cT!.purpleColor!),
            ),
          ),
          CommonWidgets()
              .makeDynamicTextSpan(
                  text1: '20%',
                  size1: 12,
                  align: TextAlign.center,
                  color1: AppTheme.cT!.appColorDark)
              .centralized()
        ],
      ),
    );
  }
}
