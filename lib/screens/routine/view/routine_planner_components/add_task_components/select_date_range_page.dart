import 'package:flutter/material.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/extensions.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/routes/routes.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class SelectDateRangePage extends StatefulWidget {
  final (String startDate, String endDate)? dates;
  final bool? isFromMain;
  final bool isEditMode;

  const SelectDateRangePage({
    super.key,
    this.dates,
    this.isFromMain,
    required this.isEditMode,
  });

  @override
  State<SelectDateRangePage> createState() => _SelectDateRangePageState();
}

class _SelectDateRangePageState extends State<SelectDateRangePage> {
  String startingDate = "";
  String endingDate = "";

  DateRangePickerController controller = DateRangePickerController();

  TextEditingController controller1 = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.dates!.$1 != "") {
      controller.selectedRange = PickerDateRange(
        // DateFormat('d MMMM y').parse(widget.dates!.$1),// Start date
        DateTime.now(),
        DateFormat('d MMMM y').parse(widget.dates!.$2), // End Date
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 12.w, right: 12.w, top: 50.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonWidgets().customAppBar(
                    text: "Select Date Range",
                    actionWidget: appBarActionWidgets()),
                30.height,
                SizedBox(
                  height: MediaQuery.sizeOf(context).height / 2.5.h,
                  child: SfDateRangePicker(
                    controller: controller,
                    view: DateRangePickerView.month,
                    startRangeSelectionColor: AppTheme.cT!.greenColor,
                    endRangeSelectionColor: AppTheme.cT!.greenColor,
                    selectionColor: AppTheme.cT!.greenColor,
                    toggleDaySelection: false,
                    backgroundColor: Colors.transparent,
                    headerStyle: const DateRangePickerHeaderStyle(
                      backgroundColor: Colors.transparent,
                    ),
                    selectableDayPredicate: (DateTime dateTime) {
                      // Check if the provided date is today or in the future
                      return dateTime.isAfter(
                          DateTime.now().subtract(const Duration(days: 1)));
                    },
                    /*selectableDayPredicate: (DateTime dateTime) {
                      // Check if there are already selected dates
                      if (controller.selectedRange != null) {
                        // User has already selected a date range
                        DateTime startDate =
                            controller.selectedRange!.startDate!;
                        DateTime endDate =
                            controller.selectedRange!.endDate ?? DateTime.now();

                        // Check if the provided date falls within the selected range
                        if (dateTime.isAfter(
                                startDate.subtract(const Duration(days: 1))) &&
                            dateTime.isBefore(
                                endDate.add(const Duration(days: 1)))) {
                          // Date falls within the selected range, so it's selectable
                          return true;
                        } else {
                          // Date falls outside the selected range, so it's not selectable
                          return false;
                        }
                      } else {
                        // User hasn't selected a date range yet, restrict selection to today and beyond
                        return dateTime.isAfter(
                            DateTime.now().subtract(const Duration(days: 1)));
                      }
                    },*/
                    extendableRangeSelectionDirection:
                        ExtendableRangeSelectionDirection.both,
                    selectionMode: widget.isEditMode
                        ? DateRangePickerSelectionMode.extendableRange
                        : DateRangePickerSelectionMode.range,
                    monthViewSettings: const DateRangePickerMonthViewSettings(
                        showTrailingAndLeadingDates: true,
                        enableSwipeSelection: false),
                    monthCellStyle: const DateRangePickerMonthCellStyle(
                      blackoutDatesDecoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      weekendDatesDecoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      specialDatesDecoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      specialDatesTextStyle: TextStyle(color: Colors.white),
                      cellDecoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    selectionShape: DateRangePickerSelectionShape.circle,
                    onSelectionChanged:
                        (DateRangePickerSelectionChangedArgs args) {
                      PickerDateRange pickerDateRange = args.value;

                      /// if user want to edit the date, and if the selected end date is
                      /// after the already added routine planner end selected date
                      /// then user cannot select the data range out of the box
                      ///
                      /// and else case create routine planner

                      if (widget.isFromMain != null &&
                          widget.isFromMain == true) {
                        DateTime? endDateLimit =
                            DateFormat('d MMMM y').parse(widget.dates!.$2);
                        if (pickerDateRange.endDate!.isAfter(endDateLimit)) {
                          CommonWidgets().showSnackBar(context,
                              "The chosen day is not part of the cycle");
                          // Reset selection to the last valid state
                          controller.selectedRange = PickerDateRange(
                            DateTime.now(),
                            DateFormat('d MMMM y').parse(widget.dates!.$2),
                          );
                        } else {
                          startingDate = DateFormat('d MMMM y')
                              .format(pickerDateRange.startDate!);

                          endingDate = DateFormat('d MMMM y').format(
                              pickerDateRange.endDate ?? DateTime.now());
                        }
                      }else{
                        startingDate = DateFormat('d MMMM y')
                            .format(pickerDateRange.startDate!);

                        endingDate = DateFormat('d MMMM y').format(
                            pickerDateRange.endDate ?? DateTime.now());
                      }
                    },
                  ),
                ),
                30.height,
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///
  bool isSpecialDay(DateTime date) {
    if (date.day == 20 || date.day == 21 || date.day == 24 || date.day == 25) {
      return true;
    }
    return false;
  }

  ///
  bool isSameDate(DateTime date, DateTime dateTime) {
    if (date.year == dateTime.year &&
        date.month == dateTime.month &&
        date.day == dateTime.day) {
      return true;
    }

    return false;
  }

  ///
  bool isBlackedDate(DateTime date) {
    if (date.day == 17 || date.day == 18) {
      return true;
    }
    return false;
  }

  ///AppBar Cancel Button
  Widget appBarActionWidgets() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
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
      Navigate.pop({"startingDate": startingDate, "endingDate": endingDate});
    });
  }
}
