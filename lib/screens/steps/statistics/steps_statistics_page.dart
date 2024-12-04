import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/screens/steps/aggregate_function/aggregate_year_month_week_function.dart';
import 'package:freud_ai/screens/steps/bloc/steps_bloc.dart';
import 'package:freud_ai/screens/steps/model/step_counter_goal_model.dart';
import 'package:freud_ai/screens/steps/model/step_report_model/month_report_model.dart';
import 'package:freud_ai/screens/steps/model/step_report_model/week_report_model.dart';
import 'package:freud_ai/screens/steps/model/step_report_model/year_report_model.dart';
import 'package:freud_ai/screens/steps/statistics/views/monthly_steps.dart';
import 'package:freud_ai/screens/steps/statistics/views/weekly_steps.dart';
import 'package:freud_ai/screens/steps/statistics/views/yearly_steps.dart';

class StepsStatistics extends StatefulWidget {

  const StepsStatistics({super.key});

  @override
  State<StepsStatistics> createState() => _StepsStatisticsState();
}

class _StepsStatisticsState extends State<StepsStatistics> {
  final PageController _pageController = PageController(initialPage: 0);

  int selectedIndex = 1;
  List<Widget> pageList = [];

  bool isMonthSelected = true;
  bool yearSelected = false;
  bool weekSelected = false;

  List<StepCounterGoalModel> listOfStepCounterModel = [];
  late AggregateYearMonthWeekFunction aggregateYearMonthWeekFunction;

  List<YearViewModel> yearlyData = [];
  List<MonthModel> monthlyData = [];
  List<WeekModel> weeklyData = [];

  @override
  void initState() {
    aggregateYearMonthWeekFunction = AggregateYearMonthWeekFunction();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    readTheStepsBloc();

    yearlyData =
        aggregateYearMonthWeekFunction.aggregateByYear(listOfStepCounterModel);
    monthlyData =
        aggregateYearMonthWeekFunction.aggregateByMonth(listOfStepCounterModel);
    weeklyData =
        aggregateYearMonthWeekFunction.groupStepsByWeek(listOfStepCounterModel);
    addListPages();

    log("yearly data: ${yearlyData.length}");
    log("monthly data: ${monthlyData.length}");
    log("weekly data: ${weeklyData.length}");

  }

  readTheStepsBloc() {
    listOfStepCounterModel =
        context.read<StepsBloc>().listOfStepCounterGoalModel ?? [];
  }

  ///Add Pages
  addListPages() {
    pageList.add(WeeklyStepsView(
      listOfStepCounterModel: listOfStepCounterModel,
      weeklyData: weeklyData,
    ));
    pageList.add(MonthlyStepsView(
      listOfStepCounterModel: listOfStepCounterModel,
      monthlyData: monthlyData,
    ));
    pageList.add(YearlyStepsView(
      yearlyData: yearlyData,
    ));
    // pageList.add(const AllStepsView());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        height: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            60.height,
            stepsAppBAr(),
            20.height,
            selectStatSteps(),
            20.height,
            stepsCounterIndications(),
            Expanded(
              child: selectedIndex != 3 ? pageView() : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  stepsAppBAr() {
    return CommonWidgets().customAppBar(
        borderColor: AppTheme.cT!.appColorLight!);
  }

  ///PageView
  Widget pageView() {
    return SizedBox(
      height: selectedIndex == 0 ? 100.h : 320.h,
      child: PageView.builder(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        itemCount: pageList.length,
        itemBuilder: (context, index) {
          return pageList[selectedIndex];
        },
      ),
    );
  }

  ///Animate the Next page
  animateTheNextPage(int pageNumber) {
    _pageController.animateToPage(
      pageNumber,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  /// Select Stat Steps
  Widget selectStatSteps() {
    return Container(
      height: 48.h,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.w),
        ),
      ),
      child: Row(
        children: [
          selectedTypeButton(isItemSelected: weekSelected, viewText: "Week"),
          selectedTypeButton(
              isItemSelected: isMonthSelected, viewText: "Month"),
          selectedTypeButton(isItemSelected: yearSelected, viewText: "Year"),
          // selectedTypeButton(isItemSelected: allSelected, viewText: "All"),
        ],
      ),
    );
  }

  /// Selected Type Button
  Widget selectedTypeButton({isItemSelected, viewText}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          CommonWidgets().vibrate();
          setState(() {
            if (viewText == "Week") {
              weekSelected = true;
              isMonthSelected = false;
              yearSelected = false;
              // allSelected = false;
              selectedIndex = 0;
            } else if (viewText == "Month") {
              weekSelected = false;
              isMonthSelected = true;
              yearSelected = false;
              // allSelected = false;
              selectedIndex = 1;
            } else if (viewText == "Year") {
              weekSelected = false;
              isMonthSelected = false;
              yearSelected = true;
              // allSelected = false;
              selectedIndex = 2;
            } else if (viewText == "All") {
              weekSelected = false;
              isMonthSelected = false;
              yearSelected = false;
              // allSelected = true;
              selectedIndex = 3;
            }
          });
        },
        child: Container(
          height: 42.h,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration:
              isItemSelected ? selectedDecoration() : const BoxDecoration(),
          child: CommonWidgets().makeDynamicText(
              text: viewText,
              size: 16,
              align: TextAlign.center,
              weight: FontWeight.w500,
              color: isItemSelected
                  ? AppTheme.cT!.whiteColor
                  : AppTheme.cT!.appColorLight),
        ),
      ),
    );
  }

  ///Select Decoration
  BoxDecoration selectedDecoration() {
    return BoxDecoration(
      color: AppTheme.cT!.greenColor,
      borderRadius: BorderRadius.circular(30.w),
      boxShadow: [
        BoxShadow(
          color: AppTheme.cT!.lightGreenColor!,
          blurRadius: 0,
          offset: const Offset(0, 0),
          spreadRadius: 4.w,
        )
      ],
    );
  }

  ///Steps counter indications
  Widget stepsCounterIndications() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        makeItemForIndication(color: AppTheme.cT!.blueColor, text: "Steps"),
        SizedBox(width: 15.w),
        makeItemForIndication(color: AppTheme.cT!.yellowColor, text: "Time"),
        SizedBox(width: 15.w),
        makeItemForIndication(color: AppTheme.cT!.orangeColor, text: "Kcal"),
        SizedBox(width: 15.w),
        makeItemForIndication(
            color: AppTheme.cT!.purpleColor, text: "Distance"),
      ],
    );
  }

  ///Make item for indications
  Widget makeItemForIndication({color, text}) {
    return Row(
      children: [
        CommonWidgets().makeDot(color: color, size: 10.w.h),
        CommonWidgets().makeDynamicText(
            text: text,
            size: 14,
            align: TextAlign.center,
            weight: FontWeight.w500,
            color: AppTheme.cT!.appColorLight)
      ],
    );
  }
}
