import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/screens/sleep/model/sleep_model.dart';

class SleepItemView extends StatelessWidget {
  final bool? isFromStat;
  final SleepModel? sleepModel;
  const SleepItemView({super.key, this.isFromStat,this.sleepModel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //Navigate.pushNamed(const ShowSleepStat());
      },
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
          padding: EdgeInsets.all(10.w),
          width: MediaQuery.sizeOf(context).width,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: isFromStat!
                ? AppTheme.cT!.whiteColor
                : AppTheme.cT!.scaffoldLight,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22.w),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding:EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: !isFromStat!
                      ? AppTheme.cT!.whiteColor
                      : AppTheme.cT!.scaffoldLight,
                  borderRadius: BorderRadius.circular(12.w),
                ),
                child: CommonWidgets().makeDynamicTextSpan(
                    text1: 'Sep\n',
                    text2: '12',
                    size1: 14,
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
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CommonWidgets().makeDynamicText(
                            text: "You slept for 4.2h",
                            size: 16,
                            weight: FontWeight.w600,
                            color: AppTheme.cT!.appColorLight),
                        const Spacer(),
                        sleepProgress()
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  ///Sleep Progress
  Widget sleepProgress() {
    return Container(
      width: 100.w,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: AppTheme.cT!.purpleColor,
        borderRadius: BorderRadius.circular(12.w),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset("assets/bmi/bmi.svg"),
          10.width,
          Expanded(
            child: CommonWidgets().makeDynamicText(
              text: "Insomaniac",
              lines: 1,
              size: 14,
              color: AppTheme.cT!.whiteColor,
            ),
          )
        ],
      ),
    );
  }
}
