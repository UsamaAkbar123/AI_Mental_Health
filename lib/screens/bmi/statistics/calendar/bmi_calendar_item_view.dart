import 'package:flutter/material.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/screens/bmi/statistics/calendar/bmi_monthly_view.dart';

class BMICalenderMonthYearView extends StatelessWidget {
  final String? name;
  final String? date;
  final bool? isShowDates;
  final Color? dateColor;
  final String? fromWhere;
  final Decoration? dateDecoration;
  final BMISpecialDateModel? specialDateModel;

  const BMICalenderMonthYearView(
      {super.key,
      this.name,
      this.fromWhere,
      this.isShowDates,
      this.date,
      this.dateDecoration,
      this.specialDateModel,
      this.dateColor});

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
          margin: EdgeInsets.only(top: 2.h, left: 2.w, right: 2.w),
          child: Stack(
            children: [
              specialDateModel!.isSpecialDate!
                  ? Container(
                      decoration: BoxDecoration(
                        color: specialDateModel!.backgroundColor,
                        shape: BoxShape.circle,
                      ),
                    )
                  : const SizedBox(),
              Align(
                alignment: Alignment.center,
                child: Text(
                  date!,
                  style: TextStyle(
                    fontSize: 12,
                    color: specialDateModel!.dateColor ?? dateColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              fromWhere!="moodTrack"?  specialDateModel!.isSpecialDate!
                  ? Positioned(
                      top: 0,
                      right: 0,
                      left: 0,
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.w),
                            color: AppTheme.cT!.appColorLight,
                          ),
                        child: CommonWidgets().makeDynamicText(
                            text: specialDateModel!.bmiScore!,
                            size: 10,
                            color: specialDateModel!.dateColor!,
                            weight: FontWeight.w500),
                      ),
                    ),
                  ):const SizedBox()
                : const SizedBox(),
          ],
        ),
      );
    }
  }
}
