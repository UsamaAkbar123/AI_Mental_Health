import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/screens/mood/model/mood_model.dart';
import 'package:intl/intl.dart';

class _BarChart extends StatelessWidget {
  final List<MoodModel> moodData;

  const _BarChart({required this.moodData});

  @override
  Widget build(BuildContext context) {
    List<BarChartGroupData> barGroups = generateBarGroups();

    return BarChart(
      BarChartData(
        barTouchData: barTouchData,
        titlesData: titlesData,
        borderData: borderData,
        barGroups: barGroups,
        gridData: const FlGridData(show: false),
        alignment: BarChartAlignment.spaceAround,
        maxY: 20,
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (group) => Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              const TextStyle(
                color: Colors.transparent,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    final style = TextStyle(
      color: AppTheme.cT!.appColorLight,
      fontWeight: FontWeight.w600,
      fontSize: 14,
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

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  List<BarChartGroupData> generateBarGroups() {
    /// Get the current date
    DateTime currentDate = DateTime.now();

    /// Initialize an empty list to hold the data for the previous 7 days
    List<MoodModel> filteredMoodData = [];

    /// Filter moodData for the previous 7 days
    for (int i = 0; i < moodData.length; i++) {
      DateTime previousDate = currentDate.subtract(Duration(days: i));
      String formattedDate = DateFormat('yyyy-MM-dd').format(previousDate);

      /// Find the MoodModel instance for the current date
      MoodModel? mood = moodData.firstWhere(
        (element) => element.moodDate == formattedDate,
        orElse: () => MoodModel(),
      );

      filteredMoodData.add(mood);
    }

    /// Initialize an empty list to hold the BarChartGroupData instances
    List<BarChartGroupData> barGroups = [];

    /// Iterate over the filteredMoodData and create BarChartGroupData accordingly
    for (int i = 0; i < moodData.length; i++) {

      /// these logic get the week day based on datetime
      ///
      /// because on week chart weekday is also show

      DateTime dateTime = DateTime.parse(moodData[i].moodDate ?? "");

      DateFormat formatter = DateFormat('EEE');

      String weekday = formatter.format(dateTime);

      /// Add the BarChartGroupData to the barGroups list
      barGroups.add(
        BarChartGroupData(
          x: _getWeekDayInInteger(weekday),
          barRods: [
            BarChartRodData(
              toY: _getMoodValue(moodData[i].moodName ?? ""),
              color: _getColorForBMIScore(moodData[i].moodName ?? ""),
            ),
          ],
          showingTooltipIndicators: [0],
        ),
      );
    }

    return barGroups;
  }

  /// get integer from 0 to 6 based of weekday
  int _getWeekDayInInteger(String weekday) {
    switch (weekday) {
      case "Mon":
        return 0;
      case "Tue":
        return 1;
      case "Wed":
        return 2;
      case "Thu":
        return 3;
      case "Fri":
        return 4;
      case "Sat":
        return 5;
      default:
        return 6;
    }
  }

  ///Get Colors from BMI Score
  Color _getColorForBMIScore(String mood) {
    // Define your logic to assign color based on BMI score
    // Example logic:
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

    // Define your logic to assign color based on BMI score
    // Example logic:
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





}

class BarChartSample3 extends StatelessWidget {
  final List<MoodModel> moodData;

  const BarChartSample3({super.key, required this.moodData});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.6,
      child: _BarChart(moodData: moodData),
    );
  }
}
