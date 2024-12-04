import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/screens/Widgets/calender_views.dart';
import 'package:freud_ai/screens/bmi/statistics/calendar/bmi_calendar_item_view.dart';
import 'package:freud_ai/screens/bmi/statistics/calendar/bmi_monthly_view.dart';
import 'package:freud_ai/screens/mood/bloc/mood_bloc.dart';
import 'package:freud_ai/screens/mood/model/mood_model.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class MoodMonthlyView extends StatefulWidget {
  const MoodMonthlyView({super.key});

  @override
  State<MoodMonthlyView> createState() => _MoodMonthlyViewState();
}

class _MoodMonthlyViewState extends State<MoodMonthlyView> {
  List<MoodModel> moodList = [];
  late MoodBloc moodBloc;
  late DateTime calenderStartDate;
  DateRangePickerController controller = DateRangePickerController();

  @override
  void initState() {
    moodBloc = BlocProvider.of<MoodBloc>(context, listen: false);

    if (moodBloc.state.moodModelList!.isNotEmpty) {
      moodList = moodBloc.state.moodModelList ?? [];
    }

    if (moodList.isNotEmpty) {
      calenderStartDate = DateTime.parse(
        moodBloc.state.moodModelList!.first.moodDate!,
      );
    } else {
      calenderStartDate = DateTime.now();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height / 2.5.h,
      child: SfDateRangePicker(
        controller: controller,
        view: DateRangePickerView.month,
        showNavigationArrow: true,
        minDate: calenderStartDate,
        selectionColor: Colors.transparent,
        selectionShape: DateRangePickerSelectionShape.circle,
        backgroundColor: Colors.transparent,
        headerStyle: const DateRangePickerHeaderStyle(
          backgroundColor: Colors.transparent,
        ),
        monthViewSettings: const DateRangePickerMonthViewSettings(
          showTrailingAndLeadingDates: true,
        ),
        onViewChanged: (value) {
          ///TODO IMPLEMENTATION
        },
        onSelectionChanged: (value) {
          ///TODO IMPLEMENTATION
        },
        cellBuilder:
            (BuildContext context, DateRangePickerCellDetails details) {
          if (controller.view == DateRangePickerView.year) {
            /// Return the default month view cell
            final monthName = DateFormat.MMMM().format(details
                .visibleDates[details.visibleDates.indexOf(details.date)]);

            return CalenderMonthYearView(name: monthName, isShowDates: false);
          } else if (controller.view == DateRangePickerView.decade) {
            /// Display decade's year range when the view is set to decade
            final int startYear = details.date.year - details.date.year % 10;
            final int endYear = startYear + 9;
            final String decadeYearRange = '$startYear - $endYear';

            return CalenderMonthYearView(
                name: decadeYearRange, isShowDates: false);
          } else if (controller.view == DateRangePickerView.century) {
            /// Display century's year range when the view is set to century
            final int startCenturyYear =
                details.date.year - details.date.year % 100;
            final int endCenturyYear = startCenturyYear + 99;
            final String centuryYearRange =
                '$startCenturyYear - $endCenturyYear';

            return CalenderMonthYearView(
                name: centuryYearRange, isShowDates: false);
          } else {
            ///Show the Events and other Months Dates
            final bool isBlackOut = isBlackedDate(details.date);
            BMISpecialDateModel specialDateInfo = checkSpecialDay(
              details.date,
              context,
              moodList,
            );

            Color textColor = AppTheme.cT!.appColorLight!;

            BoxDecoration cellDecoration;

            if (isBlackOut) {
              textColor = AppTheme.cT!.whiteColor!;
              cellDecoration = BoxDecoration(
                color: AppTheme.cT!.appColorLight!,
                // or your blackout color
                shape: BoxShape.circle,
              );
            } else if (specialDateInfo.isSpecialDate!) {
              cellDecoration = const BoxDecoration(
                color: Colors.white, // or your default cell color
                shape: BoxShape.circle,
              );
            } else {
              textColor = AppTheme.cT!.appColorLight!;
              cellDecoration = const BoxDecoration(
                color: Colors.white, // or your default cell color
                shape: BoxShape.circle,
              );
            }

            return BMICalenderMonthYearView(
              isShowDates: true,
              dateColor: textColor,
              fromWhere: "moodTrack",
              specialDateModel: specialDateInfo,
              date: details.date.day.toString(),
              dateDecoration: cellDecoration,
            );
          }
        },
      ),
    );
  }

  ///Check Special Day
  BMISpecialDateModel checkSpecialDay(
    DateTime date,
    context,
    List<MoodModel> moodList,
  ) {
    String formattedDate = DateFormat('MM/dd/yyyy').format(date);

    for (int i = 0; i < moodList.length; i++) {
      DateTime modelDate = DateTime.parse(
        moodList[i].moodDate!,
      );

      String modelFormattedDate = DateFormat('MM/dd/yyyy').format(modelDate);

      if (formattedDate == modelFormattedDate) {
        /// Customize the SpecialDateModel based on your conditions
        return BMISpecialDateModel(
          isSpecialDate: true,
          specialDate: formattedDate,
          bmiScore: moodList[i].moodName,
          dateColor: AppTheme.cT!.whiteColor,
          indicatorColor: AppTheme.cT!.appColorLight,
          backgroundColor: _getColorForBMIScore(moodList[i].moodName!),
        );
      }
    }

    return BMISpecialDateModel(
      isSpecialDate: false,
      specialDate: null,
      dateColor: null,
    );
  }

  ///Get Colors from BMI Score
  Color _getColorForBMIScore(String mood) {
    // Define your logic to assign color based on BMI score
    // Example logic:
    if (mood == "You were happy") {
      return AppTheme.cT!.yellowColor!; // Underweight
    } else if (mood == "You were neutral") {
      return AppTheme.cT!.appColorLight!; // Normal weight
    } else if (mood == "You were sad") {
      return AppTheme.cT!.orangeColor!; // Overweight
    } else if (mood == "You were depressed") {
      return AppTheme.cT!.purpleColor!; // Overweight
    } else if (mood == "You were overjoyed") {
      return AppTheme.cT!.greenColor!; // Overweight
    } else {
      return AppTheme.cT!.orangeColor!; // Obese
    }
  }

  bool isSameDate(DateTime date, DateTime dateTime) {
    if (date.year == dateTime.year &&
        date.month == dateTime.month &&
        date.day == dateTime.day) {
      return true;
    }

    return false;
  }

  bool isBlackedDate(DateTime date) {
    if (date.day == 0 || date.day == 0) {
      return true;
    }
    return false;
  }
}
