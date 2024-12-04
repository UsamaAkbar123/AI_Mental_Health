import 'package:flutter/material.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class YearlySleepStatView extends StatefulWidget {
  const YearlySleepStatView({super.key});

  @override
  State<YearlySleepStatView> createState() => _YearlySleepStatViewState();
}

class _YearlySleepStatViewState extends State<YearlySleepStatView> {
  List<ChartData> chartData = [
    ChartData(
        'Jan',
        2,
        4,
        5,
        4,
        AppTheme.cT!.greenColor!,
        AppTheme.cT!.greenColor!,
        AppTheme.cT!.yellowColor!,
        AppTheme.cT!.purpleColor!),
    ChartData(
        'Feb',
        2,
        4,
        6,
        5,
        AppTheme.cT!.greenColor!,
        AppTheme.cT!.greenColor!,
        AppTheme.cT!.yellowColor!,
        AppTheme.cT!.purpleColor!),
    ChartData(
        'Mar',
        2,
        5,
        7,
        6,
        AppTheme.cT!.greenColor!,
        AppTheme.cT!.greenColor!,
        AppTheme.cT!.yellowColor!,
        AppTheme.cT!.purpleColor!),
    ChartData(
        'Apr',
        2,
        6,
        8,
        7,
        AppTheme.cT!.greenColor!,
        AppTheme.cT!.greenColor!,
        AppTheme.cT!.yellowColor!,
        AppTheme.cT!.purpleColor!),
    ChartData(
        'May',
        2,
        7,
        9,
        8,
        AppTheme.cT!.greenColor!,
        AppTheme.cT!.greenColor!,
        AppTheme.cT!.yellowColor!,
        AppTheme.cT!.purpleColor!)
  ];
  late SelectionBehavior _selectionBehavior;

  @override
  void initState() {
    _selectionBehavior = SelectionBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 300.h,
        margin: EdgeInsets.only(bottom: 10.h),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10.w)),
        child: SfCartesianChart(
          // Mode of selection
          selectionType: SelectionType.cluster,
          borderWidth: 0,
          plotAreaBorderWidth: 0,
          primaryXAxis: const CategoryAxis(
            majorTickLines: MajorTickLines(width: 0),
            majorGridLines: MajorGridLines(width: 0),
            opposedPosition: true,
            axisLine: AxisLine(width: 0.0),
          ),
          primaryYAxis: const NumericAxis(
            majorGridLines: MajorGridLines(width: 0.0),
            // Set width to 0 to hide major grid lines
            minorGridLines: MinorGridLines(
                width: 0), // Set width to 0 to hide minor grid lines
          ),
          series: <CartesianSeries<ChartData, String>>[
            ColumnSeries<ChartData, String>(
              dataSource: chartData,
              borderRadius: BorderRadius.circular(10.w),
              initialSelectedDataIndexes: const <int>[1],
              selectionBehavior: _selectionBehavior,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              spacing: 0.1,
              pointColorMapper: (ChartData data, _) => data.color,
            ),
            ColumnSeries<ChartData, String>(
              dataSource: chartData,
              borderRadius: BorderRadius.circular(10.w),
              selectionBehavior: _selectionBehavior,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y1,
              spacing: 0.1,
              pointColorMapper: (ChartData data, _) => data.color1,
            ),
            ColumnSeries<ChartData, String>(
              dataSource: chartData,
              borderRadius: BorderRadius.circular(10.w),
              selectionBehavior: _selectionBehavior,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y2,
              spacing: 0.1,
              pointColorMapper: (ChartData data, _) => data.color2,
            ),
            ColumnSeries<ChartData, String>(
              dataSource: chartData,
              borderRadius: BorderRadius.circular(10.w),
              selectionBehavior: _selectionBehavior,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y3,
              spacing: 0.1,
              pointColorMapper: (ChartData data, _) => data.color3,
            ),
          ],
        ));
  }
}

class ChartData {
  final String x;
  final double y;
  final double y1;
  final double y2;
  final double y3;
  final Color color;
  final Color color1;
  final Color color2;
  final Color color3;

  ChartData(this.x, this.y, this.y1, this.y2, this.y3, this.color, this.color1,
      this.color2, this.color3);
}
