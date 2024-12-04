import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/routes/routes.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TotalStepsGraph extends StatefulWidget {
  final double stepPercentageValue;
  final double caloriesPercentageValue;
  final double distancePercentageValue;
  final int currentStep;
  final double currentDistance;
  final double currentCalories;

  const TotalStepsGraph({
    super.key,
    required this.currentStep,
    required this.currentCalories,
    required this.currentDistance,
    required this.stepPercentageValue,
    required this.caloriesPercentageValue,
    required this.distancePercentageValue,
  });

  @override
  State<TotalStepsGraph> createState() => _TotalStepsGraphState();
}

class _TotalStepsGraphState extends State<TotalStepsGraph> {
  final List<ChartData> chartData = [];

  @override
  void initState() {
    chartData.add(ChartData(
        'Step',
        widget.stepPercentageValue > 1.0 ? 1.0 : widget.stepPercentageValue,
        AppTheme.cT!.blueColor!));

    chartData.add(ChartData(
        'Distance',
        widget.distancePercentageValue > 1.0
            ? 1.0
            : widget.distancePercentageValue,
        AppTheme.cT!.purpleColor!));

    chartData.add(ChartData(
        'Kcal',
        widget.caloriesPercentageValue > 1.0
            ? 1.0
            : widget.caloriesPercentageValue,
        AppTheme.cT!.orangeColor!));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          children: [
            84.height,
            // CommonWidgets().customAppBar(),
            CommonWidgets().makeDynamicTextSpan(
                text1: "Total Steps\n",
                text2: widget.currentStep.toString(),
                size1: 42,
                size2: 52,
                align: TextAlign.center,
                weight1: FontWeight.w700,
                weight2: FontWeight.bold,
                color1: AppTheme.cT!.appColorLight!,
                color2: AppTheme.cT!.appColorLight!),
            30.height,
            SfCircularChart(series: <CircularSeries>[
              // Renders radial bar chart
              RadialBarSeries<ChartData, String>(
                dataSource: chartData,
                xValueMapper: (ChartData data, _) => data.x,
                yValueMapper: (ChartData data, _) => data.y,
                cornerStyle: CornerStyle.bothCurve,
                pointColorMapper: (ChartData data, _) => data.color,
                maximumValue: 1,
                innerRadius: "30%",
                gap: "4%",
              )
              ],
            ),
            30.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                indications(
                    color: AppTheme.cT!.orangeColor,
                    text2: widget.currentCalories.toInt().toString(),
                    icon: "calory_ic.svg",
                    text1: "Kcal\n"),
                indications(
                    color: AppTheme.cT!.purpleColor,
                    text2: "${widget.currentDistance.toInt()}km".toString(),
                    icon: "distance.svg",
                    text1: "Distance\n"),
                indications(
                    color: AppTheme.cT!.blueColor,
                    text2: widget.currentStep.toString(),
                    icon: "time.svg",
                    text1: "Step\n"),
              ],
            ),
            const Spacer(),
            CommonWidgets().customButton(
              text: "Got It, Thanks!",
              showIcon: true,
              callBack: () => Navigate.pop(),
            ),
            24.height,
          ],
        ),
      ),
    );
  }

  ///Indications
  Widget indications({color, text1, text2, icon}) {
    return Column(
      children: [
        CommonWidgets().makeDynamicTextSpan(
            text1: text1,
            text2: text2,
            size1: 14,
            size2: 24,
            align: TextAlign.center,
            weight1: FontWeight.w700,
            weight2: FontWeight.w800,
            color1: AppTheme.cT!.greyColor,
            color2: AppTheme.cT!.appColorLight),
        10.height,
        Container(
          width: 64.h,
          height: 64.h,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: SvgPicture.asset("assets/steps/$icon"),
        )
      ],
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, this.color);

  final String x;
  final double y;
  final Color color;
}
