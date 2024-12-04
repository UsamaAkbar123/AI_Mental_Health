import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/extensions.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/routes/routes.dart';
import 'package:freud_ai/screens/sleep/bloc/sleep_bloc.dart';
import 'package:freud_ai/screens/sleep/bloc/sleep_state.dart';
import 'package:freud_ai/screens/sleep/statistics/views/new_sleep_schedule.dart';

class SleepScheduleView extends StatelessWidget {
  final bool? isFromStat;

  const SleepScheduleView({super.key, this.isFromStat});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SleepBloc,SleepState>(builder: (context, state) {


      /// Time strings
      String startTimeStr = state.sleepSchedule!.sleepAt!;
      String endTimeStr = state.sleepSchedule!.wokeUpAt!;

      /// Parse the time strings into time objects
      TimeOfDay startTime = parseTimeString(startTimeStr);
      TimeOfDay endTime = parseTimeString(endTimeStr);

      /// Calculate the difference in hours
      int differenceInHours = calculateTimeDifference(startTime, endTime);

      return Container(
          margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 15.h),
          padding: EdgeInsets.all(20.w),
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
              CommonWidgets().makeDynamicText(
                  text: "Schedule set for $differenceInHours hours",
                  size: 16,
                  weight: FontWeight.w600,
                  color: AppTheme.cT!.appColorLight),
              const Spacer(),
              editButton()
            ],
          )).clickListener(
        click: () => Navigate.pushNamed(const NewSleepSchedule()),
      );
    });
  }

  ///Sleep Progress
  Widget editButton() {
    return Container(
      width: 80.w,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: AppTheme.cT!.appColorLight!),
        borderRadius: BorderRadius.circular(12.w),
      ),
      child: CommonWidgets().makeDynamicText(
        text: "Edit",
        lines: 1,
        size: 14,
        color: AppTheme.cT!.appColorLight,
      ),
    );
  }



  TimeOfDay parseTimeString(String timeString) {
    // Split the time string into hours, minutes, and AM/PM
    List<String> parts = timeString.split(' ');
    List<String> timeParts = parts[0].split(':');

    // Parse hours and minutes
    int hours = int.parse(timeParts[0]);
    int minutes = int.parse(timeParts[1]);

    // Adjust hours for PM times
    if (parts[1] == 'PM' && hours < 12) {
      hours += 12;
    }

    // Create and return TimeOfDay object
    return TimeOfDay(hour: hours, minute: minutes);
  }

  int calculateTimeDifference(TimeOfDay startTime, TimeOfDay endTime) {
    // Convert time objects to minutes
    int startMinutes = startTime.hour * 60 + startTime.minute;
    int endMinutes = endTime.hour * 60 + endTime.minute;

    // Calculate the difference in minutes
    int differenceInMinutes = endMinutes - startMinutes;

    // Convert the difference to hours
    double differenceInHours = differenceInMinutes / 60;

    // Return the difference in hours (rounded to the nearest integer)
    return differenceInHours.round();
  }







}
