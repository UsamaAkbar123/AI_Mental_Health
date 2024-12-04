import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/routes/routes.dart';
import 'package:freud_ai/screens/bmi/bloc/bmi_bloc.dart';
import 'package:freud_ai/screens/bmi/bloc/bmi_state.dart';
import 'package:freud_ai/screens/bmi/statistics/calendar/bmi_monthly_view.dart';
import 'package:freud_ai/screens/bmi/statistics/calendar/bmi_yearly_view.dart';
import 'package:freud_ai/screens/bmi/statistics/view/bmi_detail.dart';
import 'package:freud_ai/screens/bmi/statistics/view/bmi_weekly_view.dart';
import 'package:freud_ai/screens/bmi/views/bmi_item_view.dart';

class BMIStatisticsPage extends StatefulWidget {
  const BMIStatisticsPage({super.key});

  @override
  State<BMIStatisticsPage> createState() => _BMIStatisticsPageState();
}

class _BMIStatisticsPageState extends State<BMIStatisticsPage> {
  final PageController _pageController = PageController(initialPage: 0);

  int selectedIndex = 1;
  List<Widget> pageList = [];

  bool isMonthSelected = true;
  bool yearSelected = false;
  bool allSelected = false;
  bool weekSelected = false;

  addListPages() {
    pageList.add(const BMIWeeklyView());
    pageList.add(const BMIMonthlyView());
    pageList.add(const BMIYearlyView());
  }

  @override
  Widget build(BuildContext context) {
    addListPages();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.only(left: 12.w, right: 12.w, top: 50.h),
        child: Column(
          children: [
            CommonWidgets().customAppBar(
              borderColor: AppTheme.cT!.appColorLight!,
              text: "BMI Statistics",
            ),
            20.height,
            selectWeightType(),
            20.height,
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    selectedIndex != 3 ? pageView() : const SizedBox(),
                    20.height,
                    /*Row(
                       children: [
                       makeBMIButton(text: "Height"),
                       30.width,
                       makeBMIButton(text: "Weight"),
                      ],
                     ),
                    20.height,*/
                    bmiListView()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///PageView
  Widget pageView() {
    return SizedBox(
      height: 320.h,
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


  /// comment code

  // ///BMI Buttons
  // makeBMIButton({text}) {
  //   return Expanded(
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         CommonWidgets().makeDynamicText(
  //             size: 16,
  //             weight: FontWeight.w600,
  //             text: text,
  //             color: AppTheme.cT!.greyColor),
  //         10.height,
  //         GestureDetector(
  //           onTap: () {
  //             CommonWidgets().vibrate();
  //             if (text == "Height") {
  //               Navigate.pushNamed(const AddBmiPage(initialPage: 1));
  //             } else {
  //               Navigate.pushNamed(const AddBmiPage(initialPage: 0));
  //             }
  //           },
  //           child: Container(
  //             alignment: Alignment.center,
  //             padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
  //             decoration: BoxDecoration(
  //                 color: AppTheme.cT!.whiteColor,
  //                 borderRadius: BorderRadius.circular(30.w)),
  //             child: Row(
  //               children: [
  //                 SvgPicture.asset("assets/bmi/arrows.svg"),
  //                 10.width,
  //                 Expanded(
  //                   child: CommonWidgets().makeDynamicText(
  //                       size: 16,
  //                       weight: FontWeight.w600,
  //                       text: text,
  //                       color: AppTheme.cT!.greyColor),
  //                 ),
  //                 10.width,
  //                 SvgPicture.asset("assets/common/arrow_down.svg"),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  ///BMI List
  Widget bmiListView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CommonWidgets().makeDynamicText(
                text: "Body Mass Index",
                size: 16,
                weight: FontWeight.w800,
                color: AppTheme.cT!.appColorLight),
            // CommonWidgets()
            //     .makeDynamicText(
            //         text: "See Details",
            //         size: 16,
            //         weight: FontWeight.w500,
            //         color: AppTheme.cT!.greenColor)
            //     .clickListener(click: () {}),
          ],
        ),
        15.height,
        BlocBuilder<BMIBloc, BMIState>(builder: (context, state) {
          return ListView.builder(
            itemCount: state.bmiModelList!.length,
            shrinkWrap: true,
            reverse: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(bottom: 40.h),
            itemBuilder: (context, index) {
              return BMIItemView(
                  isFromMain: false,
                addBMIModel: state.bmiModelList![index],
                onTap: () {
                  Navigate.pushNamed(
                    BMIDetailView(
                      bmiModel: state.bmiModelList![index],
                    ),
                  );
                },
              );
            },
          );
        })
      ],
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
  Widget selectWeightType() {
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
          //selectedTypeButton(isItemSelected: allSelected, viewText: "All"),
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
