import 'package:flutter/material.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/screens/calender/show_events_calender.dart';

class CalenderMonthYearView extends StatelessWidget {
  final String? name;
  final String? date;
  final bool? isShowDates;
  final Color? dateColor;
  final Decoration? dateDecoration;
  final SpecialDateModel? specialDateModel;

  const CalenderMonthYearView(
      {super.key,
      this.name,
      this.isShowDates,
      this.date,
      this.dateDecoration,
      this.specialDateModel,
    this.dateColor,
  });

  @override
  Widget build(BuildContext context) {
    if (!isShowDates!) {
      return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
        ),
        child: CommonWidgets().makeDynamicText(
            text: name, size: 14, color: AppTheme.cT!.appColorLight),
      );
    } else {
      /// Customize the day view cell using your original cellBuilder logic
      return Container(
        alignment: Alignment.center,
        decoration: dateDecoration!,
        margin: EdgeInsets.only(top: 2.h,left: 2.w,right: 2.w),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                date!,
                style: TextStyle(
                  fontSize: 12,
                  color: dateColor!,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            specialDateModel!.isSpecialDate!
                ? Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: 35.h,
                      width: 35.h,
                      child: CircularProgressIndicator(
                        value: double.parse(
                            specialDateModel!.showStepsPercentage!),
                        strokeWidth: 3,
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.cT!.blueColor!),
                      ),
                    ),
                  )
                : const SizedBox(),
            specialDateModel!.isSpecialDate!
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 8.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          double.parse(specialDateModel!
                                      .showDistancePercentage!) >
                                  0
                              ? CommonWidgets().makeDot(
                                  color: AppTheme.cT!.yellowColor,
                                  margin: 2.0.w.h,
                                  size: 4.w.h)
                              : const SizedBox(),
                          double.parse(specialDateModel!.showKCalPercentage!) >
                                  0
                              ? CommonWidgets().makeDot(
                                  color: AppTheme.cT!.orangeDark,
                                  margin: 2.0.w.h,
                                  size: 4.w.h)
                              : const SizedBox(),
                          double.parse(specialDateModel!
                                      .showDistancePercentage!) >
                                  0
                              ? CommonWidgets().makeDot(
                                  color: AppTheme.cT!.purpleColor,
                                  margin: 0.0.w.h,
                                  size: 4.w.h)
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  )
                : const SizedBox()
          ],
        ),
      );
    }
  }
}
