import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/screens/bmi/bloc/bmi_bloc.dart';
import 'package:freud_ai/screens/bmi/model/bmi_model.dart';

class BMIWeeklyView extends StatefulWidget {
  const BMIWeeklyView({super.key});

  @override
  State<BMIWeeklyView> createState() => _BMIWeeklyViewState();
}

class _BMIWeeklyViewState extends State<BMIWeeklyView> {
  late List<ChartData> chartData;

  @override
  void initState() {
    super.initState();
    // Generate chart data dynamically based on BMI data
    final bmiData = BlocProvider.of<BMIBloc>(context, listen: false).state.bmiModelList;
    chartData = generateChartDataFromBMI(bmiData!);
  }

  List<ChartData> generateChartDataFromBMI(List<AddBMIModel> bmiData) {
    List<ChartData> data = [];

    // Define a list to hold the day names
    List<String> dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    // Iterate through BMI data and convert it to chart data
    for (var bmiModel in bmiData) {
      String date = bmiModel.bmiTimeStamp!; // Extract date (assuming it's in format "YYYY-MM-DD")
      double bmiScore = double.parse(bmiModel.bmiScore!); // Convert BMI score to double
      Color color = _getColorForBMIScore(bmiScore); // Get color based on BMI score

      // DateFormat formatter = DateFormat('MM/dd/yyyy');

      // Extract the day of the week from the date
      DateTime dateTime = DateFormat('MM/dd/yyyy').parse(date);
      String dayOfWeek = dayNames[dateTime.weekday - 1]; // Adjust index to start from 0

      data.add(ChartData(dayOfWeek, bmiScore, color));
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
      height: 300, // Adjust height as needed
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: SfCartesianChart(
        primaryXAxis: const CategoryAxis(
          majorGridLines: MajorGridLines(width: 0), // Remove horizontal grid lines
          labelRotation: 45, // Rotate labels for better visibility
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
