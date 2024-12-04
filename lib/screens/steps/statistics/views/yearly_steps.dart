import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/screens/steps/aggregate_function/aggregate_year_month_week_function.dart';
import 'package:freud_ai/screens/steps/model/step_report_model/year_report_model.dart';
import 'package:freud_ai/screens/steps/view/common_view_widgets/step_counter_yearly_or_month_item_view_widget.dart';


class YearlyStepsView extends StatefulWidget {
  final List<YearViewModel> yearlyData;

  const YearlyStepsView({
    super.key,
    required this.yearlyData,
  });

  @override
  State<YearlyStepsView> createState() => _YearlyStepsViewState();

}

class _YearlyStepsViewState extends State<YearlyStepsView> {

  late List<ChartData> chartData;
  late AggregateYearMonthWeekFunction aggregateYearMonthWeekFunction;

  @override
  void initState() {
    chartData = [];
    aggregateYearMonthWeekFunction = AggregateYearMonthWeekFunction();
    super.initState();

  }

  /// get integer from 0 to 11 based of month of year
  int _getWeekDayInInteger(String weekday) {
    switch (weekday) {
      case "January":
        return 1;
      case "February":
        return 2;
      case "March":
        return 3;
      case "April":
        return 4;
      case "May":
        return 5;
      case "June":
        return 6;
      case "July":
        return 7;
      case "August":
        return 8;
      case "September":
        return 9;
      case "October":
        return 10;
      case "November":
        return 11;
      default:
        return 12;
    }
  }

  /// get top heading of yearly graph
  Widget getTitles(double value, TitleMeta meta) {
    TextStyle style = const TextStyle(
      // color: AppTheme.cT!.appColorLight,
      color: Color(0xffC9C7C5),
      fontWeight: FontWeight.w700,
      fontSize: 12,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = 'Jan';
        break;

      case 2:
        text = 'Feb';
        break;

      case 3:
        text = 'Mar';
        break;

      case 4:
        text = 'Apr';
        break;

      case 5:
        text = 'May';
        break;

      case 6:
        text = 'Jun';
        break;

      case 7:
        text = 'Jul';
        break;

      case 8:
        text = 'Aug';
        break;

      case 9:
        text = 'Sep';
        break;

      case 10:
        text = 'Oct';
        break;

      case 11:
        text = 'Non';
        break;

      case 12:
        text = 'Dec';
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
    return PageView.builder(
        itemCount: widget.yearlyData.length,
        itemBuilder: (context, outerIndex) {
          Map<String, dynamic> result =
              aggregateYearMonthWeekFunction.calculateProgressAndTotalSteps(
            widget.yearlyData[outerIndex].listOfStepCounterMode,
            context,
          );

          chartData = [];

          for (var yearlyModel in widget.yearlyData) {
            chartData.add(
              ChartData(
                yearlyModel.month,
                double.parse(result["totalSteps"].toString()),
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                16.height,
                Container(
                  height: 300.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.w),
                  ),
                  child: Container(
                    height: 300.h,
                    padding: EdgeInsets.only(
                      left: 8.w,
                      right: 8.w,
                      top: 8.h,
                      bottom: 30.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.w),
                      color: Colors.white,
                    ),
                    child: BarChart(
                      BarChartData(
                          maxY: 400000,
                          minY: 0,
                          gridData: const FlGridData(show: false),
                          borderData: FlBorderData(show: false),
                          titlesData: FlTitlesData(
                            show: true,
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 30,
                                getTitlesWidget: getTitles,
                              ),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: const AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: false,
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 100000,
                                reservedSize: 50,
                                getTitlesWidget: (value, meta) {
                                  return SideTitleWidget(
                                    axisSide: meta.axisSide,
                                    child: Text(
                                      value == 0 ? "0" : '${value.toInt() ~/ 1000}k',
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
                                      BarChartRodData(toY: data.y, width: 4),
                                    ],
                                  ))
                              .toList()),
                    ),
                  ),
                ),
                SizedBox(height: 15.h),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.yearlyData.length,
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return StepCounterYearlyOrMonthItemView(
                      monthOrWeekRangeName: widget.yearlyData[index].month,
                      totalMonthOrWeekRangeSteps: result["totalSteps"],
                      stepProgress:
                          result["totalSteps"] < result["totalGoalSteps"]
                              ? result["progress"]
                              : 100,
                      stepPercentageValue:
                          result["totalSteps"] < result["totalGoalSteps"]
                              ? result["percentage"]
                              : 1.0,
                    );
                  },
                ),
              ],
            ),
          );
        });
  }
}

class ChartData {
  final String x;
  final double y;

  ChartData(this.x, this.y);
}

