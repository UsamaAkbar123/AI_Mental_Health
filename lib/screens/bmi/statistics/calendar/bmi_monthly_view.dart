import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/screens/Widgets/calender_views.dart';
import 'package:freud_ai/screens/bmi/bloc/bmi_bloc.dart';
import 'package:freud_ai/screens/bmi/model/bmi_model.dart';
import 'package:freud_ai/screens/bmi/statistics/calendar/bmi_calendar_item_view.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class BMIMonthlyView extends StatefulWidget {
  const BMIMonthlyView({super.key});

  @override
  State<BMIMonthlyView> createState() => _BMIMonthlyViewState();
}

class _BMIMonthlyViewState extends State<BMIMonthlyView> {
  List<AddBMIModel> bmiList = [];
  late BMIBloc bmiBloc;
  late DateTime calenderStartDate;
  DateRangePickerController controller = DateRangePickerController();

  @override
  void initState() {
    bmiBloc = BlocProvider.of<BMIBloc>(context, listen: false);

    if (bmiBloc.state.bmiModelList!.isNotEmpty) {
      bmiList = bmiBloc.state.bmiModelList ?? [];
    }

    if (bmiList.isNotEmpty) {
      calenderStartDate =
          DateFormat("MM/dd/yyyy").parse(bmiList.first.bmiTimeStamp!);
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

        cellBuilder: (BuildContext context, DateRangePickerCellDetails details) {
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
              bmiList,
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
                specialDateModel: specialDateInfo,
                date: details.date.day.toString(),
                dateDecoration: cellDecoration);
          }
        },
      ),
    );
  }

  ///Check Special Day
  BMISpecialDateModel checkSpecialDay(
    DateTime date,
    context,
    List<AddBMIModel> bmiList,
  ) {
    String formattedDate = DateFormat('MM/dd/yyyy').format(date);

    for (int i = 0; i < bmiList.length; i++) {
      if (formattedDate == bmiList[i].bmiTimeStamp) {
        /// Customize the SpecialDateModel based on your conditions
        return BMISpecialDateModel(
            isSpecialDate: true,
            specialDate: formattedDate,
          bmiScore: bmiList[i].bmiScore,
          dateColor: AppTheme.cT!.whiteColor,
          indicatorColor: AppTheme.cT!.appColorLight,
          backgroundColor: AppTheme.cT!.greenColor,
        );
      }
    }

    return BMISpecialDateModel(
      isSpecialDate: false,
      specialDate: null,
      dateColor: null,
    );
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

///Special Date Model
class BMISpecialDateModel {
  bool? isSpecialDate;
  String? specialDate;
  String? bmiScore;
  Color? dateColor;
  Color? backgroundColor;
  Color? indicatorColor;

  BMISpecialDateModel(
      {this.specialDate,
      this.dateColor,
        this.bmiScore,
      this.isSpecialDate,
      this.backgroundColor,
      this.indicatorColor});
}
