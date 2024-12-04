import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/extensions.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/screens/routine/model/day_daily_routine_planner_model.dart';

class SubTaskItemView extends StatelessWidget {

  final Function? voidCallback;
  final Function? saveProgressFunction;
  final SubTaskModel subTaskModel;

  const SubTaskItemView(
      {super.key,
      required this.subTaskModel,
      this.saveProgressFunction,
      this.voidCallback});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Row(
        children: [
          CommonWidgets().customRadioButton(subTaskModel.isCompleted!,
              color: subTaskModel.isCompleted!
                  ? AppTheme.cT!.appColorLight
                  : AppTheme.cT!.whiteColor),
          10.width,
          Expanded(
            child: CommonWidgets().makeDynamicText(
                size: 16,
                weight: FontWeight.w700,
                text: subTaskModel.subTaskName,
                color: AppTheme.cT!.appColorLight),
          ),
          10.width,
          // CommonWidgets().makeDynamicText(
          //     size: 14,
          //     weight: FontWeight.w500,
          //     text: subTaskModel.reminderTime,
          //     color: AppTheme.cT!.appColorLight),
          // 10.width,
          // SizedBox(
          //   width: 40.w,
          //   height: 40.h,
          //   child: Center(
          //     child: SvgPicture.asset(AssetsItems.alarm,
          //         width: 24.w,
          //         height: 24.h,
          //         fit: BoxFit.contain,
          //       colorFilter: ColorFilter.mode(
          //         subTaskModel.reminderTime!.isEmpty
          //             ? AppTheme.cT!.lightGrey50 ?? Colors.transparent
          //             : AppTheme.cT!.appColorLight ?? Colors.transparent,
          //         BlendMode.srcIn,
          //       ),
          //     ),
          //   ),
          // ).clickListener(
          //     click: () => voidCallback != null
          //         ? Navigate.pushNamed(TaskNotificationReminder(
          //                 reminderTime: subTaskModel.reminderTime,
          //                 isReminderSet: subTaskModel.isNotifyReminder))
          //             .then((value) {
          //             if (value != null) {
          //               voidCallback!.call(value);
          //             }
          //           })
          //         : null)
        ],
      ).clickListener(click: () {
        log("subTaskCompletionStatus :: ${subTaskModel.isCompleted}");

        if (saveProgressFunction != null) {
          if (subTaskModel.isCompleted!) {
            saveProgressFunction!.call(false);
          } else {
            saveProgressFunction!.call(true);
          }
        }
      }),
    );
  }
}
