import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/screens/mood/bloc/mood_bloc.dart';
import 'package:freud_ai/screens/mood/model/mood_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MoodYearlyView extends StatefulWidget {

  const MoodYearlyView({super.key});

  @override
  State<MoodYearlyView> createState() => _MoodYearlyViewState();

}

class _MoodYearlyViewState extends State<MoodYearlyView> {
  late List<ChartData> chartData;

  @override
  void initState() {
    super.initState();
    /// Generate chart data dynamically based on bmiData

    final bmiData = BlocProvider.of<MoodBloc>(context,listen: false).state.moodModelList;

    chartData = generateChartDataFromBMI(bmiData!);
  }

  List<ChartData> generateChartDataFromBMI(List<MoodModel> bmiData) {
    List<ChartData> data = [];

    /// Iterate through BMI data and convert it to chart data
    for (var bmiModel in bmiData) {
      String month =bmiModel.moodTimeStamp!; // Extract month from date

      double bmiScore = _getMoodValue(bmiModel.moodName!); // Convert BMI score to double
      Color color = _getColorForBMIScore(bmiModel.moodName!); // Get color based on BMI score

      data.add(ChartData(month, bmiScore, color));
    }

    return data;
  }

  ///Get Colors from BMI Score
  Color _getColorForBMIScore(String mood) {
    /// Define your logic to assign color based on BMI score

    if (mood == "You were happy") {
      return AppTheme.cT!.yellowColor!; // Underweight
    } else if (mood == "You were neutral") {
      return AppTheme.cT!.appColorLight!; // Normal weight
    } else if (mood == "You were sad") {
      return AppTheme.cT!.orangeColor!; // Overweight
    } else if (mood == "You were depressed") {
      return AppTheme.cT!.purpleColor!; // Overweight
    } else if (mood == "You were overjoyed") {
      return AppTheme.cT!.greenColor!; // Overweight
    } else {
      return AppTheme.cT!.orangeColor!; // Obese
    }
  }


  double _getMoodValue(String mood) {

    /// Define your logic to assign color based on BMI score

    if (mood == "You were happy") {
      return 12; // Underweight
    } else if (mood == "You were neutral") {
      return 10; // Normal weight
    } else if (mood == "You were sad") {
      return 4; // Overweight
    } else if (mood == "You were depressed") {
      return 2; // Overweight
    } else if (mood == "You were overjoyed") {
      return 15; // Overweight
    } else {
      return 5; // Obese
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.w),
      ),
      child: SfCartesianChart(
        primaryXAxis: const CategoryAxis(
          majorGridLines: MajorGridLines(width: 0),
          // Remove horizontal grid lines
          labelRotation: 45,
          // Rotate labels for better visibility
          minimum: 0,
          maximumLabels: 12,
          interval: 1,
          labelPlacement: LabelPlacement.betweenTicks,
        ),
        series: <CartesianSeries>[
          LineSeries<ChartData, String>(
            dataSource: chartData,
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y,
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              labelAlignment: ChartDataLabelAlignment.top,
              labelPosition: ChartDataLabelPosition.inside,
              textStyle: TextStyle(fontSize: 12),
            ),
            markerSettings: MarkerSettings(
              isVisible: true,
              borderWidth: 0,
              color: chartData[0].color,
            ),
            color: chartData[0].color,
          ),
        ],
        annotations: <CartesianChartAnnotation>[
          for (var data in chartData)
            CartesianChartAnnotation(
              widget: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: data.color,
                ),
              ),
              coordinateUnit: CoordinateUnit.point,
              x: data.x,
              y: data.y,
            ),
        ],
      ),
    );
  }
}


///Chart Data
class ChartData {
  final String x;
  final double y;
  final Color color;
  ChartData(this.x, this.y, this.color);
}

