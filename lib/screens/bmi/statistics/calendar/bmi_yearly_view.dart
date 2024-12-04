import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/screens/bmi/bloc/bmi_bloc.dart';
import 'package:freud_ai/screens/bmi/model/bmi_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BMIYearlyView extends StatefulWidget {
  const BMIYearlyView({super.key});

  @override
  State<BMIYearlyView> createState() => _BMIYearlyViewState();

}

class _BMIYearlyViewState extends State<BMIYearlyView> {
  late List<ChartData> chartData;

  @override
  void initState() {
    super.initState();
    // Generate chart data dynamically based on bmiData


    final bmiData = BlocProvider.of<BMIBloc>(context,listen: false).state.bmiModelList;

    chartData = generateChartDataFromBMI(bmiData!);
  }

  List<ChartData> generateChartDataFromBMI(List<AddBMIModel> bmiData) {
    List<ChartData> data = [];

    // Iterate through BMI data and convert it to chart data
    for (var bmiModel in bmiData) {
      String month =bmiModel.dateBMI!; // Extract month from date
      double bmiScore = double.parse(bmiModel.bmiScore!); // Convert BMI score to double
      Color color = _getColorForBMIScore(bmiScore); // Get color based on BMI score

      data.add(ChartData(month, bmiScore, color));
    }

    return data;
  }

  Color _getColorForBMIScore(double bmiScore) {
    // Define your logic to assign color based on BMI score
    // Example logic:
    if (bmiScore < 18.5) {
      return Colors.blue; // Underweight
    } else if (bmiScore < 25) {
      return Colors.green; // Normal weight
    } else if (bmiScore < 30) {
      return Colors.orange; // Overweight
    } else {
      return Colors.red; // Obese
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
            color: AppTheme.cT!.appColorLight,
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

class ChartData {
  final String x;
  final double y;
  final Color color;
  ChartData(this.x, this.y, this.color);
}

