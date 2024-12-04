import 'dart:convert';

import 'package:equatable/equatable.dart';

class SleepModel extends Equatable {
  final int? id;
  final String? sleepAt;
  final String? wokeUpAt;
  final String? graceSleepPeriod;
  final List<String>? selectedDaysList;
  final bool? isRepeatDaily;
  final bool? autoSetAlarm;
  final String? saveDateTime;

  ///Sleep Model constructor
  const SleepModel({
    this.id,
    this.sleepAt,
    this.wokeUpAt,
    this.graceSleepPeriod,
    this.selectedDaysList,
    this.isRepeatDaily,
    this.autoSetAlarm,
    this.saveDateTime,
  });

  ///Sleep FromJson
  factory SleepModel.fromJson(Map<String, dynamic> json) {
    return SleepModel(
      id: json['id'],
      sleepAt: json['sleepAt'],
      wokeUpAt: json['wokeUpAt'],
      graceSleepPeriod: json['graceSleepPeriod'],
      isRepeatDaily: json['isRepeatDaily'] == 0 ? false : true,
      autoSetAlarm: json['autoSetAlarm'] == 0 ? false : true,
      saveDateTime: json['saveDateTime'],
      selectedDaysList: json['selectedDaysList'] != null
          ? List<String>.from(jsonDecode(json['selectedDaysList']))
          : null,
    );
  }

  ///ToJson
  Map<String, dynamic> toJson() {
    return {
      'sleepAt': sleepAt,
      'wokeUpAt': wokeUpAt,
      'graceSleepPeriod': graceSleepPeriod,
      'isRepeatDaily': isRepeatDaily! ? 1 : 0,
      'autoSetAlarm': autoSetAlarm! ? 1 : 0,
      'saveDateTime': saveDateTime,
      'selectedDaysList':
          selectedDaysList != null ? jsonEncode(selectedDaysList) : null,
    };
  }

  ///CopyWith
  SleepModel copyWith(
      {int? id,
      String? sleepAt,
      String? wokeUpAt,
      String? graceSleepPeriod,
      List<String>? selectedDaysList,
      bool? autoSetAlarm,
      bool? isRepeatDaily,
      String? saveDateTime}) {
    return SleepModel(
      id: id ?? this.id,
      sleepAt: sleepAt ?? this.sleepAt,
      wokeUpAt: wokeUpAt ?? this.wokeUpAt,
      autoSetAlarm: autoSetAlarm ?? this.autoSetAlarm,
      graceSleepPeriod: graceSleepPeriod ?? this.graceSleepPeriod,
      isRepeatDaily: isRepeatDaily ?? this.isRepeatDaily,
      saveDateTime: saveDateTime ?? this.saveDateTime,
      selectedDaysList: selectedDaysList ?? this.selectedDaysList,
    );
  }

  @override
  List<Object?> get props => [
        id,
        sleepAt,
        wokeUpAt,
        graceSleepPeriod,
        selectedDaysList,
        autoSetAlarm,
        isRepeatDaily,
        saveDateTime
      ];
}
