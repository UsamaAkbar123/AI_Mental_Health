import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';

class WeeklyReport extends StatefulWidget {
  const WeeklyReport({super.key});

  @override
  State<WeeklyReport> createState() => _WeeklyReportState();
}

class _WeeklyReportState extends State<WeeklyReport> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
          itemCount: 6,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: CommonWidgets().dotedLine());
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            makeWeeklyGraph(
                height: 120,
                color: AppTheme.cT!.lightBrownColor,
                emoji: "poor.svg",
                text: "MON"),
            const SizedBox(width: 15),
            makeWeeklyGraph(
                height: 90,
                color: AppTheme.cT!.lightBrownColor,
                emoji: "poor.svg",
                text: "TUE"),
            const SizedBox(width: 15),
            makeWeeklyGraph(
                height: 140,
                color: AppTheme.cT!.orangeColor,
                emoji: "poor.svg",
                text: "WED"),
            const SizedBox(width: 15),
            makeWeeklyGraph(
                height: 120,
                color: AppTheme.cT!.greenColor,
                emoji: "poor.svg",
                text: "THU"),
            const SizedBox(width: 15),
            makeWeeklyGraph(
                height: 90,
                color: AppTheme.cT!.greenColor,
                emoji: "poor.svg",
                text: "FRI"),
            const SizedBox(width: 15),
            makeWeeklyGraph(
                height: 80,
                color: AppTheme.cT!.lightBrownColor,
                emoji: "poor.svg",
                text: "SAT"),
            const SizedBox(width: 15),
            makeWeeklyGraph(
                height: 85,
                color: AppTheme.cT!.lightBrownColor,
                emoji: "poor.svg",
                text: "SUN"),
          ],
        ),
      ],
    );
  }

  makeWeeklyGraph({double? height, color,text, emoji}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 36,
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          alignment: Alignment.topCenter,
          decoration: ShapeDecoration(
            color: color,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
          ),
          child: SvgPicture.asset("assets/assessment/$emoji"),
        ),
        CommonWidgets().makeDynamicText(text: text,size: 14)
      ],
    );
  }
}
