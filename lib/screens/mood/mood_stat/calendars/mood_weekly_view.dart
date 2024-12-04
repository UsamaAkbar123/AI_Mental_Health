import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freud_ai/screens/mood/bloc/mood_bloc.dart';
import 'package:freud_ai/screens/mood/bloc/mood_state.dart';
import 'package:freud_ai/screens/mood/mood_stat/calendars/bar_chart_weekly.dart';

class MoodWeeklyView extends StatefulWidget {
  const MoodWeeklyView({super.key});

  @override
  State<MoodWeeklyView> createState() => _MoodWeeklyViewState();
}

class _MoodWeeklyViewState extends State<MoodWeeklyView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300, // Adjust height as needed
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: BlocBuilder<MoodBloc,MoodState>(builder: (context,state){
        return BarChartSample3(moodData: state.moodModelList!);
      }),
    );
  }
}
