import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/screens/bmi/model/bmi_model.dart';

class BMIItemView extends StatelessWidget {
  final bool? isFromMain;
  final AddBMIModel? addBMIModel;
  final VoidCallback onTap;

  const BMIItemView({
    super.key,
    this.isFromMain,
    this.addBMIModel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        width: MediaQuery.sizeOf(context).width,
        margin: EdgeInsets.symmetric(vertical: 10.h),
        decoration: ShapeDecoration(
          color:
              isFromMain! ? AppTheme.cT!.scaffoldLight : AppTheme.cT!.whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26.w),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: isFromMain!
                      ? AppTheme.cT!.whiteColor
                      : AppTheme.cT!.scaffoldLight,
                  borderRadius: BorderRadius.circular(12.w)),
              child: CommonWidgets().makeDynamicTextSpan(
                  text1:
                      '${CommonWidgets().splitDateFormat(addBMIModel!.dateBMI!)["month"]}\n',
                  text2:
                      '${CommonWidgets().splitDateFormat(addBMIModel!.dateBMI!)["day"]}',
                  size1: 16,
                  size2: 16,
                  weight2: FontWeight.w500,
                  weight1: FontWeight.w500,
                  align: TextAlign.center,
                  color1: AppTheme.cT!.greyColor,
                  color2: AppTheme.cT!.appColorDark),
            ),
            12.width,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonWidgets().makeDynamicText(
                          text: "BMI Score",
                          size: 18,
                          weight: FontWeight.w600,
                          color: AppTheme.cT!.appColorLight),
                      totalBMIScore()
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset("assets/bmi/light.svg"),
                      const SizedBox(),
                      CommonWidgets().makeDynamicText(
                          text: addBMIModel!.bmiStatus,
                          size: 14,
                          weight: FontWeight.w400,
                          color: AppTheme.cT!.greyColor),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///Sleep Progress
  Widget totalBMIScore() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: AppTheme.cT!.purpleColor,
        borderRadius: BorderRadius.circular(12.w),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset("assets/bmi/bmi.svg"),
          10.width,
          CommonWidgets().makeDynamicText(
            text: addBMIModel!.bmiScore,
            size: 14,
            color: AppTheme.cT!.whiteColor,
          )
        ],
      ),
    );
  }

}
