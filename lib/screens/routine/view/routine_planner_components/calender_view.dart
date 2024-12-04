import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/screens/routine/bloc/routine_bloc.dart';
import 'package:freud_ai/screens/routine/bloc/routine_event.dart';
import 'package:intl/intl.dart';

class RoutineWeeklyCalenderView extends StatefulWidget {
  const RoutineWeeklyCalenderView({super.key});

  @override
  State<RoutineWeeklyCalenderView> createState() => _RoutineWeeklyCalenderViewState();
}

class _RoutineWeeklyCalenderViewState extends State<RoutineWeeklyCalenderView> {
  Color unSelectedTedTextColor = const Color(0xffF2F5EB);
  String selectedDate = "";
  DateTime initialDate = DateTime.now();

  late EasyInfiniteDateTimelineController _controller;

  @override
  void initState() {
    _controller = EasyInfiniteDateTimelineController();
    selectedDate = DateFormat('MMM d, yyyy').format(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0.w),
          child: Row(
            children: [
              CommonWidgets().makeDynamicText(
                  text: selectedDate,
                  size: 16,
                  weight: FontWeight.w800,
                  color: AppTheme.cT!.whiteColor),
              const Spacer(),
              SvgPicture.asset(
                height: 18.h,
                width: 18.w,
                "assets/routine/routine_calender_icon.svg",
                colorFilter: ColorFilter.mode(
                  AppTheme.cT!.whiteColor ?? Colors.transparent,
                  BlendMode.srcIn,
                ),
              ),
              5.width,
              GestureDetector(
                onTap: (){
                  _controller.animateToCurrentData();

                  initialDate = DateTime.now();

                  selectedDate =
                      DateFormat('MMM d, yyyy').format(DateTime.now());

                  /// filter the routines task based on data selected
                  ///
                  BlocProvider.of<RoutineBloc>(context, listen: false)
                      .add((GetSingleDailyRoutineTaskByDataEvent(
                    filterDate: DateFormat('d MMMM y').format(DateTime.now()),
                  )));

                  setState(() {});
                },
                child: CommonWidgets().makeDynamicText(
                    text: "Today",
                    size: 16,
                    weight: FontWeight.w800,
                    color: AppTheme.cT!.whiteColor),
              ),
            ],
          ),
        ),
        12.height,
        SizedBox(
          child: EasyInfiniteDateTimeLine(
            controller: _controller,
            firstDate: DateTime(1990, 1, 1),
            focusDate: initialDate,
            lastDate: DateTime(2090, 12, 31),
            activeColor: AppTheme.cT!.whiteColor,
            showTimelineHeader: false,
            // initialDate: initialDate,
            onDateChange: (selectedDate) {
              /// filter the routines task based on data selected
              ///
              BlocProvider.of<RoutineBloc>(context, listen: false)
                  .add((GetSingleDailyRoutineTaskByDataEvent(
                filterDate: DateFormat('d MMMM y').format(selectedDate),
              )));

              this.selectedDate =
                  DateFormat('MMM d, yyyy').format(selectedDate);

              _controller = EasyInfiniteDateTimelineController();


              initialDate = selectedDate;

              setState(() {});
            },
            dayProps: EasyDayProps(
              height: 118.h,
              width: 60.w,
            ),
            // headerProps: const EasyHeaderProps(
            //   showMonthPicker: false,
            //   showHeader: false,
            // ),
            itemBuilder: (
                BuildContext context,
                DateTime date,
                bool isSelected,
                VoidCallback onTap,
            ) {
              return InkResponse(
                onTap: onTap,
                child: Container(
                  height: 150.h,
                  width: 60.w,
                  margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 2.w),
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.cT!.whiteColor
                        : AppTheme.cT!.brownColor,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: isSelected
                        ? const [
                            BoxShadow(
                              color: Color(0x3FFFFFFF),
                              blurRadius: 0,
                              offset: Offset(0, 0),
                              spreadRadius: 4,
                            )
                          ]
                        : [],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CommonWidgets().makeDot(
                            color: isSelected
                                ? AppTheme.cT!.greenColor
                                : unSelectedTedTextColor,
                            margin: 2.w.h,
                            size: 12.w.h,
                          ),
                        ],
                      ),
                      8.height,
                      CommonWidgets().makeDynamicText(
                        text: EasyDateFormatter.shortDayName(date, "en_US"),
                        size: 16,
                        weight: FontWeight.w800,
                        color: isSelected
                            ? AppTheme.cT!.appColorLight
                            : unSelectedTedTextColor,
                      ),
                      CommonWidgets().makeDynamicText(
                        text: DateFormat('dd').format(date),
                        size: 16,
                        weight: FontWeight.w800,
                        color: isSelected
                            ? AppTheme.cT!.appColorLight
                            : unSelectedTedTextColor,
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

}