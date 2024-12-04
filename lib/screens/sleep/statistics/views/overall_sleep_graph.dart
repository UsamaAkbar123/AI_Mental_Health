import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/extensions.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/screens/bmi/statistics/calendar/bmi_yearly_view.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class OverAllSleepGraph extends StatelessWidget {
  OverAllSleepGraph({super.key});

  final List<ChartData> chartData = [
    ChartData('David', 50, AppTheme.cT!.greenColor!),
    ChartData('Steve', 15, AppTheme.cT!.purpleColor!),
    ChartData('Jack', 15, AppTheme.cT!.orangeColor!),
    ChartData('hev', 10, AppTheme.cT!.yellowColor!),
    ChartData('Others', 10, AppTheme.cT!.appColorLight!),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          40.height,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: CommonWidgets().customAppBar(),
          ),
          CommonWidgets().makeDynamicText(
              text: "Sleep Quality!",
              size: 42,
              weight: FontWeight.w600,
              color: AppTheme.cT!.appColorLight!),
          20.height,
          CommonWidgets().makeDynamicTextSpan(
              text1: "87% ",
              text2: "better from last month.",
              size1: 16,
              size2: 15,
              weight1: FontWeight.w700,
              weight2: FontWeight.normal,
              color1: AppTheme.cT!.appColorLight!,
              color2: AppTheme.cT!.brownColor!),
          30.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CommonWidgets()
                  .makeDot(color: AppTheme.cT!.greenColor!, size: 12),
              CommonWidgets().makeDynamicText(
                  text: "Light Sleep",
                  size: 14,
                  weight: FontWeight.w600,
                  color: AppTheme.cT!.greyColor!),
              const SizedBox(width: 40),
              CommonWidgets()
                  .makeDot(color: AppTheme.cT!.appColorLight!, size: 12),
              CommonWidgets().makeDynamicText(
                  text: "Deep Sleep",
                  size: 14,
                  weight: FontWeight.w600,
                  color: AppTheme.cT!.greyColor!),
            ],
          ),
          10.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CommonWidgets()
                  .makeDot(color: AppTheme.cT!.yellowColor!, size: 12.w.h),
              CommonWidgets().makeDynamicText(
                  text: "REM",
                  size: 14,
                  weight: FontWeight.w600,
                  color: AppTheme.cT!.greyColor!),
              const SizedBox(width: 40),
              CommonWidgets()
                  .makeDot(color: AppTheme.cT!.purpleColor!, size: 12),
              CommonWidgets().makeDynamicText(
                  text: "Insomaniac",
                  size: 14,
                  weight: FontWeight.w600,
                  color: AppTheme.cT!.greyColor!),
            ],
          ),
          SizedBox(
            height: MediaQuery.sizeOf(context).height / 2,
            child: Stack(
              children: [
                SfCircularChart(
                  series: <CircularSeries>[
                    // Render pie chart
                    PieSeries<ChartData, String>(
                        dataSource: chartData,
                        pointColorMapper: (ChartData data, _) => data.color,
                        xValueMapper: (ChartData data, _) => data.x,
                        yValueMapper: (ChartData data, _) => data.y)
                  ],
                ),
                SizedBox(
                  width: 60.w,
                  height: 60.h,
                  child: SvgPicture.asset("assets/common/white_round_check.svg",
                      width: 40.w, height: 40.h),
                ).centralized()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
