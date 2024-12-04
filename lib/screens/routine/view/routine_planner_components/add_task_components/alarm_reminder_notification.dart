import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/extensions.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/routes/routes.dart';
import 'package:freud_ai/screens/Widgets/animated_switch.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class TaskNotificationReminder extends StatefulWidget {
  final bool? isReminderSet;
  final String? reminderTime;

  const TaskNotificationReminder({
    super.key,
    this.reminderTime,
    this.isReminderSet,
  });

  @override
  State<TaskNotificationReminder> createState() =>
      _TaskNotificationReminderState();
}

class _TaskNotificationReminderState extends State<TaskNotificationReminder> {


  String? selectedAlarmTime;

  bool isNotifyReminder = false;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    if (widget.reminderTime!.isNotEmpty) {
      DateFormat inputFormat = DateFormat('h:mm a');
      selectedDate = inputFormat.parse(widget.reminderTime!);
      selectedAlarmTime = DateFormat('h:mm a').format(selectedDate.toLocal());
      if(widget.isReminderSet != null){
        isNotifyReminder = widget.isReminderSet!;
      }
    } else {
      selectedAlarmTime = DateFormat('h:mm a').format(selectedDate.toLocal());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            bottom: -60.h,
            child: Opacity(
              opacity: 0.4,
              child: Lottie.asset("assets/ai/text_to_speech.json"),
            ),
          ),
          Column(
            children: [
              Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 50, left: 12, right: 12),
                    child: CommonWidgets().customAppBar(
                      text: "Reminder",
                      actionWidget: appBarSaveButton(),
                    ),
                  ),
                  30.height,
                  notificationContainer(),
                  30.height,
                  taskSelectedTime("Alarm at $selectedAlarmTime"),
                  30.height,
                  createTimePicker(),
                  20.height,
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  ///Notification Container
  Widget notificationContainer() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: AppTheme.cT!.whiteColor,
          borderRadius: BorderRadius.circular(32.w)),
      child: Row(
        children: [
          Container(
            width: 50.w,
            height: 50.h,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: AppTheme.cT!.scaffoldLight),
            child: SvgPicture.asset("assets/common/notification.svg"),
          ),
          15.width,
          CommonWidgets().makeDynamicText(
              text: "Notify me",
              size: 22,
              weight: FontWeight.w700,
              color: AppTheme.cT!.appColorLight),
          const Spacer(),
          AnimatedSwitch(
              isChecked: widget.isReminderSet,
            callBack: (value) => isNotifyReminder = value,
          )
        ],
      ),
    );
  }

  ///Create Time Picker
  Widget createTimePicker() {
    return Padding(
      padding: EdgeInsets.only(top: 20.h),
      child: SizedBox(
        height: 200.h,
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.time,
          initialDateTime: selectedDate,
          backgroundColor: Colors.transparent,
          onDateTimeChanged: (DateTime newDateTime) {
            setState(() {
              selectedDate = newDateTime;
              selectedAlarmTime = DateFormat('h:mm a').format(selectedDate.toLocal());
            });
          },
        ),
      ),
    );
  }

  ///Task Selected Time
  Widget taskSelectedTime(text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(width: 1.w, color: AppTheme.cT!.appColorLight!),
        borderRadius: BorderRadius.circular(20.w),
      ),
      child: CommonWidgets().makeDynamicText(
        text: text,
        size: 16,
        weight: FontWeight.w500,
        color: AppTheme.cT!.appColorLight,
      ),
    );
  }

  ///AppBar Cancel Button
  Widget appBarSaveButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
      decoration: BoxDecoration(
        border: Border.all(width: 1.w, color: AppTheme.cT!.appColorLight!),
        borderRadius: BorderRadius.circular(20.w),
      ),
      child: CommonWidgets().makeDynamicText(
        text: "Save",
        size: 16,
        weight: FontWeight.w500,
        color: AppTheme.cT!.appColorLight,
      ),
    ).clickListener(
      click: () => Navigate.pop(
        {
          "selectedAlarmTime" : selectedAlarmTime,
          "isNotifyReminder"  : isNotifyReminder
        },
      ),
    );
  }
}
