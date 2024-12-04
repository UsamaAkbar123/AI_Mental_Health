import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/screens/steps/bloc/steps_bloc.dart';
import 'package:freud_ai/screens/steps/model/step_counter_goal_model.dart';
import 'package:freud_ai/screens/steps/model/step_report_model/week_report_model.dart';
import 'package:freud_ai/screens/steps/view/common_view_widgets/step_counter_daily_itemview.dart';
import 'package:intl/intl.dart';

class WeeklyStepsView extends StatefulWidget {
  final List<StepCounterGoalModel>? listOfStepCounterModel;
  final List<WeekModel> weeklyData;

  const WeeklyStepsView({
    super.key,
    this.listOfStepCounterModel,
    required this.weeklyData,
  });

  @override
  State<WeeklyStepsView> createState() => _WeeklyStepsViewState();
}

class _WeeklyStepsViewState extends State<WeeklyStepsView> {
  late List<ChartData> chartData;
  late List<WeekModel> listOfWeekModel;

  @override
  void initState() {
    listOfWeekModel = widget.weeklyData;
    chartData = [
      // ChartData(3, 10000),
    ];

    super.initState();
  }

  /// get integer from 0 to 6 based of weekday
  int _getWeekDayInInteger(String weekday) {
    switch (weekday) {
      case "Monday":
        return 0;
      case "Tuesday":
        return 1;
      case "Wednesday":
        return 2;
      case "Thursday":
        return 3;
      case "Friday":
        return 4;
      case "Saturday":
        return 5;
      default:
        return 6;
    }
  }

  Widget getTitles(double value, TitleMeta meta) {
    TextStyle style = const TextStyle(
      // color: AppTheme.cT!.appColorLight,
      color:  Color(0xffC9C7C5),
      fontWeight: FontWeight.w700,
      fontSize: 12,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Mon';
        break;

      case 1:
        text = 'Tue';
        break;

      case 2:
        text = 'Wed';
        break;

      case 3:
        text = 'Thu';
        break;

      case 4:
        text = 'Fri';
        break;

      case 5:
        text = 'Sat';
        break;

      case 6:
        text = 'Sun';
        break;

      default:
        text = '';
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  @override
  Widget build(BuildContext context) {
    return  PageView.builder(
      itemCount: listOfWeekModel.length,
      itemBuilder: (BuildContext context, int outerIndex) {
        List<WeekViewModel> listOfWeekViewModel =
            listOfWeekModel[outerIndex].listOfWeekViewModel;

        chartData = [];

        for (int i = 0; i < listOfWeekViewModel.length; i++) {
          int dayStartStepValue = 0;
          int dayEndStepValue = 0;

          if (listOfWeekViewModel[i].stepCounterGoalModel.todayDateId ==
              DateFormat('MM/dd/yyyy').format(DateTime.now())) {
            dayStartStepValue =
                listOfWeekViewModel[i].stepCounterGoalModel.dayStartStepValue ??
                    0;
            dayEndStepValue = context.read<StepsBloc>().pedometerStep;
          } else {
            dayStartStepValue =
                listOfWeekViewModel[i].stepCounterGoalModel.dayStartStepValue ??
                    0;
            dayEndStepValue =
                listOfWeekViewModel[i].stepCounterGoalModel.dayEndStepValue ??
                    0;
          }

          chartData.add(ChartData(listOfWeekViewModel[i].day,
              (dayEndStepValue - dayStartStepValue).toDouble()));
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              16.height,
              Container(
                height: 300.h,
                // margin: EdgeInsets.symmetric(horizontal: 20.w),
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 30.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.w),
                  color: Colors.white,
                ),
                child: BarChart(
                  BarChartData(
                      maxY: 25000,
                      minY: 0,
                      gridData: const FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(
                        show: true,
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            getTitlesWidget: getTitles,
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 5000,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                space:
                                4,
                                child: Text(
                                  '${value.toInt()}',
                                  style: const TextStyle(
                                    fontSize: 12, // Adjust font size
                                  ),
                                  textAlign:
                                      TextAlign.center, // Center align text
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      barGroups: chartData
                          .map((data) => BarChartGroupData(
                                x: _getWeekDayInInteger(data.x),
                                barRods: [
                                  BarChartRodData(
                                    toY: data.y,
                                    width: 5,
                                  ),
                                ],
                              ))
                          .toList()),
                ),
              ),
              15.height,
              Align(
                alignment: Alignment.centerLeft,
                child: CommonWidgets().makeDynamicText(
                  text: listOfWeekModel[outerIndex].weekRange,
                  size: 17,
                  weight: FontWeight.w700,
                  // color: AppTheme.cT!.appColorLight,
                  color: const Color(0xff736B66),
                ),
              ),
              15.height,
              ListView.builder(
                  itemCount: listOfWeekViewModel.length,
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context,innerIndex) {
                    StepCounterGoalModel counterModel =
                        listOfWeekViewModel[innerIndex].stepCounterGoalModel;

                    int lastIndex = listOfWeekViewModel.length - 1;
                    return StepsDailyItemView(
                      isFromMain: false,
                      counterModel: counterModel,
                      isFirstStepGoalEntryIndex: lastIndex == innerIndex ? true : false,
                      dayName: listOfWeekViewModel[innerIndex].day,
                    );
                  }
              ),
            ],
          ),
        );
      },

    );
  }
}

class ChartData {
  final String x;
  final double y;

  // final Color color;

  ChartData(
    this.x,
    this.y,
  );
}