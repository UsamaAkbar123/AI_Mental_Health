import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';

class AllItemView extends StatelessWidget {
  const AllItemView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 12.w),
      child: Container(
          padding: EdgeInsets.all(16.w),
          width: MediaQuery.sizeOf(context).width,
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
                alignment: Alignment.center,
                padding:
                EdgeInsets.symmetric(vertical: 5.h, horizontal: 10),
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
                    color1: AppTheme.cT!.brownColor,
                    color2: AppTheme.cT!.appColorLight),
              ),
              12.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CommonWidgets().makeDynamicText(
                            text: "22.5",
                            size: 16,
                            weight: FontWeight.w500,
                            color: AppTheme.cT!.appColorLight),
                        const Spacer(),
                        bmiValue()
                      ],
                    ),
                    const SizedBox(height: 8),
                    bmiProgress(),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  ///Sleep Progress
  Widget bmiValue() {
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
            text: "22.6",
            size: 14,
            color: AppTheme.cT!.whiteColor,
          )
        ],
      ),
    );
  }

  ///
  Widget bmiProgress() {
    return SizedBox(
        child: LinearProgressIndicator(
      value: 0.5,
      backgroundColor: AppTheme.cT!.scaffoldLight,
      borderRadius: BorderRadius.circular(10.w),
      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.cT!.appColorLight!),
    ));
  }

  ///
  Widget bmiProgressItemView({color}) {
    return Expanded(
      child: Container(
        height: 4.h,
        margin: EdgeInsets.only(right: 1.w),
        decoration: ShapeDecoration(
          color: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.w),
          ),
        ),
      ),
    );
  }
}
