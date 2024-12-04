import 'package:flutter/material.dart';
import 'package:freud_ai/screens/calender/show_events_calender.dart';

class MonthlySleepStat extends StatefulWidget {
  const MonthlySleepStat({super.key});

  @override
  State<MonthlySleepStat> createState() => _MonthlySleepStatState();
}

class _MonthlySleepStatState extends State<MonthlySleepStat> {

  @override
  Widget build(BuildContext context) {
    return const ShowEventsCalender();
  }
}

