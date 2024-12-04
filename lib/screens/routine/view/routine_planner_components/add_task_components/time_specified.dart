import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/extensions.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/routes/routes.dart';
import 'package:freud_ai/screens/routine/model/day_daily_routine_planner_model.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class TimeSpecifiedPage extends StatefulWidget {
  final RoutineTaskModel? routineTaskModel;

  const TimeSpecifiedPage({
    super.key,
    this.routineTaskModel,
  });

  @override
  State<TimeSpecifiedPage> createState() => _TimeSpecifiedPageState();
}

class _TimeSpecifiedPageState extends State<TimeSpecifiedPage> {
  bool isTimePeriodSelected = false;
  bool isPointTimeSelected = true;

  String selectedDateString = "";

  DateTime selectedPointDate = DateTime.now();
  DateTime selectedFromDate = DateTime.now();
  DateTime selectedToDate = DateTime.now();

  String? selectedPointTime;
  String? selectedTimePeriodFrom;
  String? selectedTimePeriodTO;

  DateFormat inputFormat = DateFormat('h:mm a');

  @override
  void initState() {
    super.initState();


    selectedPointTime = DateFormat('h:mm a').format(selectedPointDate.toLocal());

    selectedTimePeriodFrom = DateFormat('h:mm a').format(selectedFromDate.toLocal());

    selectedTimePeriodTO = DateFormat('h:mm a').format(selectedToDate.toLocal());



    if (widget.routineTaskModel!.isPointTimeSelected != null) {

      if (widget.routineTaskModel!.isPointTimeSelected!) {
        isPointTimeSelected = true;
        isTimePeriodSelected = false;
        selectedPointDate =
            inputFormat.parse(widget.routineTaskModel!.timeSpanForTask!);
        selectedPointTime = inputFormat.format(selectedPointDate.toLocal());
      } else if (widget.routineTaskModel!.timeSpanForTask!.isNotEmpty) {
        isTimePeriodSelected = true;
        isPointTimeSelected = false;
        List<String> timeParts =
            widget.routineTaskModel!.timeSpanForTask!.split(" to ");

        String startTime = timeParts[0].trim();

        String endTime = timeParts[1].trim();

        selectedFromDate = inputFormat.parse(startTime);

        selectedToDate = inputFormat.parse(endTime);

        selectedTimePeriodFrom = inputFormat.format(selectedFromDate.toLocal());

        selectedTimePeriodTO = inputFormat.format(selectedToDate.toLocal());

      } else {
        selectedPointTime = inputFormat.format(selectedPointDate.toLocal());
        selectedTimePeriodFrom = inputFormat.format(selectedFromDate.toLocal());
        selectedTimePeriodTO = inputFormat.format(selectedToDate.toLocal());
      }

    } else {

      selectedPointTime = inputFormat.format(selectedPointDate.toLocal());

      selectedTimePeriodFrom = inputFormat.format(selectedFromDate.toLocal());

      selectedTimePeriodTO = inputFormat.format(selectedToDate.toLocal());
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
                  child: Lottie.asset("assets/ai/text_to_speech.json"))),
          Column(
            children: [
              Column(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(top: 50.h, left: 12.w, right: 12.w),
                    child: CommonWidgets().customAppBar(
                        text: "Time Specified",
                        actionWidget: appBarSaveButton()),
                  ),
                  30.height,
                  selectInboxType(),
                  30.height,
                  taskSelectedTime(isPointTimeSelected
                      ? "Task at $selectedPointTime"
                      : "Task at $selectedTimePeriodFrom to Task at $selectedTimePeriodTO"),
                  isPointTimeSelected
                      ? createTimePicker("pointTime", selectedPointDate)
                      : const SizedBox(),
                  isTimePeriodSelected
                      ? createTimePicker("timePeriodFrom", selectedFromDate)
                      : const SizedBox(),
                  isTimePeriodSelected
                      ? createTimePeriodTimeForToDate(
                          "timePeriodTo", selectedFromDate)
                      : const SizedBox(),
                  20.height,
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  ///Create Time Picker
  Widget createTimePicker(String fromWhere, DateTime dateTime) {
    return Padding(
      padding: EdgeInsets.only(top: 20.h),
      child: SizedBox(
        height: 200.h,
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.time,
          initialDateTime: dateTime,
          backgroundColor: Colors.transparent,
          onDateTimeChanged: (DateTime newDateTime) {
            setState(() {
              if (fromWhere == "pointTime") {
                selectedPointDate = newDateTime;
                selectedPointTime =
                    DateFormat('h:mm a').format(selectedPointDate.toLocal());
              } else if (fromWhere == "timePeriodFrom") {
                selectedFromDate = newDateTime;
                selectedTimePeriodFrom =
                    DateFormat('h:mm a').format(selectedFromDate.toLocal());
              }
            });
          },
        ),
      ),
    );
  }

  ///Create Time Picker
  Widget createTimePeriodTimeForToDate(String fromWhere, DateTime dateTime) {
    DateTime minDateTime = dateTime.add(const Duration(minutes: 1));

    return Padding(
      padding: EdgeInsets.only(top: 20.h),
      child: SizedBox(
        height: 200.h,
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.time,
          initialDateTime: minDateTime,
          minimumDate: minDateTime,
          backgroundColor: Colors.transparent,
          onDateTimeChanged: (DateTime newDateTime) {
            setState(() {
              selectedToDate = newDateTime;
              selectedTimePeriodTO =
                  DateFormat('h:mm a').format(selectedToDate.toLocal());
            });
          },
        ),
      ),
    );
  }

  ///Task Selected Time
  Widget taskSelectedTime(text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
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
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
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
    ).clickListener(click: () {
      if (isPointTimeSelected) {
        selectedDateString = selectedPointTime!;
      } else {
        final format = DateFormat('h:mm a'); // 'h:mm a' format
        final parsedFromTime = format.parse(selectedTimePeriodFrom!);
        final parsedToTime = format.parse(selectedTimePeriodTO!);

        if (parsedToTime.isBefore(parsedFromTime)) {
          if (!mounted) return;
          CommonWidgets().showSnackBar(
              context, "end time must be greater then start time");
          return;
        } else {
          selectedDateString =
              "$selectedTimePeriodFrom to $selectedTimePeriodTO";
        }
      }

      Navigate.pop({
        "isPointTimeSelected": isPointTimeSelected,
        'selectedDateString': selectedDateString
      });
    });
  }

  ///Select Inbox Type
  Widget selectInboxType() {
    return Container(
      height: 48.h,
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      padding: EdgeInsets.symmetric(vertical: 2.h),
      decoration: BoxDecoration(
          color: AppTheme.cT!.whiteColor,
          borderRadius: BorderRadius.circular(30.w)),
      child: Row(
        children: [
          selectedTypeButton(
              isItemSelected: isPointTimeSelected,
              isPointTimeSelect: true,
              viewText: "Point Time"),
          selectedTypeButton(
              isItemSelected: isTimePeriodSelected,
              isPointTimeSelect: false,
              viewText: "Time Period"),
        ],
      ),
    );
  }

  Widget selectedTypeButton({isItemSelected, isPointTimeSelect, viewText}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          CommonWidgets().vibrate();
          setState(() {

            if (isPointTimeSelect) {
              isPointTimeSelected = true;
              isTimePeriodSelected = false;
            } else {
              isPointTimeSelected = false;
              isTimePeriodSelected = true;
            }
          });
        },
        child: Container(
          height: 48.h,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: isItemSelected
              ? selectedDecoration()
              : BoxDecoration(
                  color: AppTheme.cT!.whiteColor,
                  borderRadius: BorderRadius.circular(30.w),
                ),
          child: CommonWidgets().makeDynamicText(
              text: viewText,
              size: 22,
              align: TextAlign.center,
              weight: FontWeight.bold,
              color: isItemSelected
                  ? AppTheme.cT!.whiteColor
                  : AppTheme.cT!.appColorLight),
        ),
      ),
    );
  }

  ///BoxDecoration
  BoxDecoration selectedDecoration() {
    return BoxDecoration(
      color: AppTheme.cT!.greenColor,
      borderRadius: BorderRadius.circular(30.w),
      boxShadow: [
        BoxShadow(
          color: const Color(0x3FFFFFFF),
          blurRadius: 0,
          offset: const Offset(0, 0),
          spreadRadius: 4.w,
        )
      ],
    );
  }
}
