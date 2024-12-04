import 'package:flutter/material.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/routes/routes.dart';
import 'package:freud_ai/screens/sleep/statistics/views/all_sleep_view.dart';
import 'package:freud_ai/screens/sleep/statistics/views/monthly_sleep.dart';
import 'package:freud_ai/screens/sleep/statistics/views/overall_sleep_graph.dart';
import 'package:freud_ai/screens/sleep/statistics/views/weekly_sleep.dart';
import 'package:freud_ai/screens/sleep/statistics/views/yearly_sleep.dart';
import 'package:freud_ai/screens/sleep/view/sleep_item_view.dart';

class SleepStatistics extends StatefulWidget {
  const SleepStatistics({super.key});

  @override
  State<SleepStatistics> createState() => _SleepStatisticsState();
}

class _SleepStatisticsState extends State<SleepStatistics> {
  final PageController _pageController = PageController(initialPage: 0);

  int selectedIndex = 1;
  List<Widget> pageList = [];

  bool isMonthSelected = true;
  bool yearSelected = false;
  bool allSelected = false;
  bool weekSelected = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    addListPages();
  }

  addListPages() {
    pageList.add(const WeeklySleepStatView());
    pageList.add(const MonthlySleepStat());
    pageList.add(const YearlySleepStatView());
    pageList.add(const AllSleepView());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              sleepAppBAr(),
              20.height,
              selectGraphType(),
              20.height,
              selectedIndex != 3 ? pageView() : const SizedBox(),
              CommonWidgets().listViewAboveRow(
                  context: context,
                  text1: "Sleep History",
                  text2: "See All",
                  callBack: () => Navigate.pushNamed(OverAllSleepGraph())),
              15.height,
              ListView.builder(
                itemCount: 10,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return const SleepItemView(isFromStat: true);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  ///Add BMI
  sleepAppBAr() {
    return Padding(
      padding: EdgeInsets.only(left: 12.w, right: 12.w, top: 50.h),
      child: CommonWidgets()
          .customAppBar(borderColor: AppTheme.cT!.appColorLight!),
    );
  }

  ///PageView
  Widget pageView() {
    return SizedBox(
      height: selectedIndex == 0 ? 100.h : 355.h,
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

  ///
  animateTheNextPage(int pageNumber) {
    _pageController.animateToPage(
      pageNumber,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  ///
  Widget selectGraphType() {
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
          selectedTypeButton(isItemSelected: allSelected, viewText: "All"),
        ],
      ),
    );
  }

  ///
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
              allSelected = false;
              selectedIndex = 0;
            } else if (viewText == "Month") {
              weekSelected = false;
              isMonthSelected = true;
              yearSelected = false;
              allSelected = false;
              selectedIndex = 1;
            } else if (viewText == "Year") {
              weekSelected = false;
              isMonthSelected = false;
              yearSelected = true;
              allSelected = false;
              selectedIndex = 2;
            } else if (viewText == "All") {
              weekSelected = false;
              isMonthSelected = false;
              yearSelected = false;
              allSelected = true;
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

  ///
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
}
