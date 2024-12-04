import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class WeeklySleepStatView extends StatefulWidget {
  const WeeklySleepStatView({super.key});

  @override
  State<WeeklySleepStatView> createState() => _WeeklySleepStatViewState();
}

class _WeeklySleepStatViewState extends State<WeeklySleepStatView> {


  DateTime? selectedDay;
  DateTime? _focusedDay;

  @override
  void initState() {
    super.initState();
  }


  Widget topWeeklyCalender(){
    return SizedBox(
      height: 150,
      child: TableCalendar(
        headerVisible: false,
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: DateTime.now(),
        selectedDayPredicate: (day) {
          return isSameDay(_focusedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
        calendarFormat: CalendarFormat.week,
      ),
    );

  }


  @override
  Widget build(BuildContext context) {
    return topWeeklyCalender();
  }

}

/// Class representing a user's BMI event
class UserBmiEvent {
  final DateTime date;
  final double bmi;

  UserBmiEvent(this.date, this.bmi);
}
