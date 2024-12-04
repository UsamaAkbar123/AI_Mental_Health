import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/routes/routes.dart';
import 'package:freud_ai/screens/bmi/add-bmi/add_bmi.dart';
import 'package:freud_ai/screens/mood/bloc/mood_bloc.dart';
import 'package:freud_ai/screens/mood/bloc/mood_state.dart';
import 'package:freud_ai/screens/mood/mood_stat/calendars/mood_montly_view.dart';
import 'package:freud_ai/screens/mood/mood_stat/calendars/mood_weekly_view.dart';
import 'package:freud_ai/screens/mood/mood_stat/calendars/mood_yearly_view.dart';
import 'package:freud_ai/screens/mood/mood_stat/view/mood_detail.dart';
import 'package:freud_ai/screens/mood/views/mood_history_item_view.dart';



class MoodStatisticPage extends StatefulWidget {
  const MoodStatisticPage({super.key});

  @override
  State<MoodStatisticPage> createState() => _MoodStatisticPageState();
}

class _MoodStatisticPageState extends State<MoodStatisticPage> {
  final PageController _pageController = PageController(initialPage: 0);

  int selectedIndex = 1;
  List<Widget> pageList = [];

  bool isMonthSelected = true;
  bool yearSelected = false;
  bool allSelected = false;
  bool weekSelected = false;


  ///Add List Pages
  addListPages() {
    pageList.add(const MoodWeeklyView());
    pageList.add(const MoodMonthlyView());
    pageList.add(const MoodYearlyView());
  }

  @override
  Widget build(BuildContext context) {
    ///Add Pages List function
    addListPages();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.only(left: 12.w, right: 12.w, top: 50.h),
        child: Column(
          children: [
            bmiAppBar(),
            20.height,
            selectWeightType(),
            20.height,
            Expanded(child: SingleChildScrollView(
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
            ))
          ],
        ),
      ),
    );
  }

  ///Add BMI
  bmiAppBar() {
    return CommonWidgets().customAppBar(
      borderColor: AppTheme.cT!.appColorLight!,
      text: "Mood Statistics",
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

  ///BMI Buttons
  makeBMIButton({text}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          CommonWidgets().makeDynamicText(
              size: 16,
              weight: FontWeight.w600,
              text: text,
              color: AppTheme.cT!.greyColor),
          10.height,
          GestureDetector(
            onTap: () {
              CommonWidgets().vibrate();
              if (text == "Height") {
                Navigate.pushNamed(const AddBmiPage(initialPage: 1));
              } else {
                Navigate.pushNamed(const AddBmiPage(initialPage: 0));
              }
            },
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
              decoration: BoxDecoration(
                  color: AppTheme.cT!.whiteColor,
                  borderRadius: BorderRadius.circular(30.w)),
              child: Row(
                children: [
                  SvgPicture.asset("assets/bmi/arrows.svg"),
                  10.width,
                  Expanded(
                    child: CommonWidgets().makeDynamicText(
                        size: 16,
                        weight: FontWeight.w600,
                        text: text,
                        color: AppTheme.cT!.greyColor),
                  ),
                  10.width,
                  SvgPicture.asset("assets/common/arrow_down.svg"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///BMI List
  Widget bmiListView() {
    ///Bloc Builder of Mood Model list
    return BlocBuilder<MoodBloc, MoodState>(builder: (context, state) {
      if (state.status == MoodStateStatus.loaded) {
        return ListView.builder(
          itemCount: state.moodModelList!.length,
          shrinkWrap: true,
          reverse: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          itemBuilder: (context, index) {
            return MoodHistoryItemView(
              isFromMain: false,
              moodModel: state.moodModelList![index],
              onTap: () {
                Navigate.pushNamed(
                  MoodDetailScreen(
                    moodModel: state.moodModelList![index],
                  ),
                );
              },
            );
          },
        );
      } else {
        return const SizedBox();
      }
    });
  }

  ///Animate to the next Page
  animateTheNextPage(int pageNumber) {
    _pageController.animateToPage(
      pageNumber,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  ///Selected Weight type
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

  ///Selected Type Button
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

  ///Selected Decoration
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
