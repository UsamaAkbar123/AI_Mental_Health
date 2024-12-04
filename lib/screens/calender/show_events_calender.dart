import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/screens/Widgets/calender_views.dart';
import 'package:freud_ai/screens/steps/bloc/steps_bloc.dart';
import 'package:freud_ai/screens/steps/model/step_counter_goal_model.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ShowEventsCalender extends StatefulWidget {
  final List<StepCounterGoalModel>? listOfStepCounterModel;

  const ShowEventsCalender({super.key, this.listOfStepCounterModel});

  @override
  State<ShowEventsCalender> createState() => _ShowEventsCalenderState();
}

class _ShowEventsCalenderState extends State<ShowEventsCalender> {
  DateRangePickerController controller = DateRangePickerController();
  late DateTime startDate;

  @override
  void initState() {
    /// reason of this logic is that, we will not allow user to scroll
    /// back to its min date, which is the datetime of first entry of step counter goal
    /// in database
    if (widget.listOfStepCounterModel?.first != null) {
      startDate = DateFormat("MM/dd/yyyy").parse(
        widget.listOfStepCounterModel!.first.todayDateId!,
      );
    } else {
      startDate = DateTime.now();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height / 2.5,
      child: SfDateRangePicker(
        controller: controller,
        view: DateRangePickerView.month,
        showNavigationArrow: true,
        selectionColor: Colors.transparent,
        selectionShape: DateRangePickerSelectionShape.circle,
        backgroundColor: Colors.transparent,
        minDate: startDate,
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
        cellBuilder: (
          BuildContext context,
          DateRangePickerCellDetails details,
        ) {
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
              name: decadeYearRange,
              isShowDates: false,
            );
          } else if (controller.view == DateRangePickerView.century) {
            /// Display century's year range when the view is set to century
            final int startCenturyYear =
                details.date.year - details.date.year % 100;
            final int endCenturyYear = startCenturyYear + 99;
            final String centuryYearRange =
                '$startCenturyYear - $endCenturyYear';

            return CalenderMonthYearView(
              name: centuryYearRange,
              isShowDates: false,
            );
          } else {
            ///Show the Events and other Months Dates
            final bool isBlackOut = isBlackedDate(details.date);
            SpecialDateModel specialDateInfo =
                checkSpecialDay(details.date, context);

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
            return CalenderMonthYearView(
              isShowDates: true,
              dateColor: textColor,
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
  SpecialDateModel checkSpecialDay(DateTime date, BuildContext context) {
    String formattedDate = DateFormat('MM/dd/yyyy').format(date);

    for (int i = 0; i < widget.listOfStepCounterModel!.length; i++) {
      if (formattedDate == widget.listOfStepCounterModel![i].todayDateId!) {
        int pedometerOrDatEndStepValue = 0;
        int lastIndex = widget.listOfStepCounterModel!.length - 1;
        if (lastIndex == i) {
          pedometerOrDatEndStepValue = context.read<StepsBloc>().pedometerStep;
        } else {
          pedometerOrDatEndStepValue =
              widget.listOfStepCounterModel?[i].dayEndStepValue ?? 0;
        }

        // int pedometerStepValue = context.read<StepsBloc>().pedometerStep;
        int dayStartStepValue =
            widget.listOfStepCounterModel?[i].dayStartStepValue ?? 0;
        int currentStep = pedometerOrDatEndStepValue - dayStartStepValue;
        int goalStep = widget.listOfStepCounterModel?[i].goalStep ?? 0;

        double stepPercentage = currentStep / goalStep;

        // print("stepPercentage: $stepPercentage");

        /// Customize the SpecialDateModel based on your conditions
        return SpecialDateModel(
          isSpecialDate: true,
          specialDate: formattedDate,
          showKCalPercentage: 0.3.toString(),
          showStepsPercentage: stepPercentage.toString(),
          showDistancePercentage: 0.7.toString(),
        );
      }
    }

    return SpecialDateModel(
      isSpecialDate: false,
      specialDate: null,
      dateColor: null,
    );
  }

  // bool isSameDate(DateTime date, DateTime dateTime) {
  bool isBlackedDate(DateTime date) {
    if (date.day == 0 || date.day == 0) {
      return true;
    }
    return false;
  }
}

///Special Date Model
class SpecialDateModel {
  bool? isSpecialDate;
  String? specialDate;
  Color? dateColor;
  String? showKCalPercentage;
  String? showStepsPercentage;
  String? showDistancePercentage;

  SpecialDateModel(
      {this.specialDate,
      this.dateColor,
      this.isSpecialDate,
      this.showKCalPercentage,
      this.showStepsPercentage,
      this.showDistancePercentage});
}
