import 'package:flutter/material.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/screens/bmi/statistics/view/bmi_detail.dart';

class BMIDetailItemView extends StatelessWidget {
  final BMIDetailModel? bmiDetailModel;

  const BMIDetailItemView({super.key, this.bmiDetailModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
      decoration: BoxDecoration(
          color: AppTheme.cT!.whiteColor,
          borderRadius: BorderRadius.circular(12.w)),
      child: Row(
        children: [
          CommonWidgets().makeDot(color: bmiDetailModel!.color, size: 12.w.h),
          10.width,
          CommonWidgets().makeDynamicText(
              size: 16,
              weight: FontWeight.w600,
              text: bmiDetailModel!.text1,
              color: AppTheme.cT!.appColorLight),
          const Spacer(),
          CommonWidgets().makeDynamicTextSpan(
            size1: 16,
            weight1: FontWeight.w600,
            text1: bmiDetailModel!.text2,
            text2: bmiDetailModel!.text3,
            color1: AppTheme.cT!.greyColor,
            color2: AppTheme.cT!.appColorLight,
          ),
        ],
      ),
    );
  }
}
