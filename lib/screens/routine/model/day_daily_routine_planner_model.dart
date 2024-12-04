import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

/// this model is for each day routine
///
/// like in each day, user can have list of routine plan
class DayDailyRoutinePlannerModel {
  final String? dayId;
  final List<RoutineTaskModel>? routineTaskModelList;

  DayDailyRoutinePlannerModel({
    this.dayId,
    this.routineTaskModelList,
  });

  /// Factory method for creating an instance from a JSON map
  factory DayDailyRoutinePlannerModel.fromJson(Map<String, dynamic> json) {
    return DayDailyRoutinePlannerModel(
      dayId: json['dayId'] as String?,
      routineTaskModelList: json['routineTaskModelList'] != null
          ? (jsonDecode(json['routineTaskModelList']) as List)
          .map((i) => RoutineTaskModel.fromJson(i))
          .toList()
          : null,
    );
  }

  /// Method for converting an instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'dayId': dayId,
      'routineTaskModelList':
      routineTaskModelList?.map((i) => i.toJson()).toList(),
    };
  }


  /// Method for creating a copy of the instance with optional changes
  DayDailyRoutinePlannerModel copyWith({
    String? dayId,
    List<RoutineTaskModel>? routineTaskModelList,
  }) {
    return DayDailyRoutinePlannerModel(
      dayId: dayId ?? this.dayId,
      routineTaskModelList: routineTaskModelList ?? this.routineTaskModelList,
    );
  }


}


/// this model is for individual routine plan of particular day
class RoutineTaskModel {
  final String? taskId;
  final String? taskRoutineCommonId;
  final String? taskName;
  final bool? isTaskCompleted;
  final String? tagName;
  final String? scheduleStartDate;
  final String? scheduleEndDate;
  final String? scheduleTotalDays;
  final String? timeSpanForTask;
  final String? reminderAt;
  final bool? isPointTimeSelected;
  final bool? isNotifyReminder;
  final List<SubTaskModel>? subTaskModelList;

  RoutineTaskModel({
    this.taskId,
    this.taskRoutineCommonId,
    this.taskName,
    this.isTaskCompleted,
    this.tagName,
    this.scheduleStartDate,
    this.scheduleEndDate,
    this.scheduleTotalDays,
    this.timeSpanForTask,
    this.reminderAt,
    this.isPointTimeSelected,
    this.isNotifyReminder,
    this.subTaskModelList,
  });


  ///Routine Task Model Initial
  RoutineTaskModel initial() => RoutineTaskModel(
        taskRoutineCommonId: const Uuid().v4(),
        taskName: "Task Title",
    isTaskCompleted: false,
        tagName: "Healthy lifestyle",
        scheduleStartDate: DateFormat('d MMMM y').format(DateTime.now()),
    scheduleEndDate: DateFormat('d MMMM y').format(DateTime.now()),
    scheduleTotalDays: "1",
    timeSpanForTask: "",
    reminderAt: "",
    isNotifyReminder: false,
    subTaskModelList: const [],
  );

  /// Factory method for creating an instance from a JSON map
  factory RoutineTaskModel.fromJson(Map<String, dynamic> json) {
    return RoutineTaskModel(
      taskId: json['taskId'] as String?,
      taskRoutineCommonId: json['taskRoutineCommonId'] as String?,
      taskName: json['taskName'] as String?,
      isTaskCompleted: json['isTaskCompleted'] as bool?,
      tagName: json['tagName'] as String,
      scheduleStartDate: json['scheduleStartDate'] as String?,
      scheduleEndDate: json['scheduleEndDate'] as String?,
      scheduleTotalDays: json['scheduleTotalDays'] as String?,
      timeSpanForTask: json['timeSpanForTask'] as String?,
      reminderAt: json['reminderAt'] as String?,
      isPointTimeSelected: json['isPointTimeSelected'] == 1 ? true : false,
      isNotifyReminder: json['isNotifyReminder'] == 1 ? true : false,
      subTaskModelList: json['subTaskModelList'] != null
          ? (json['subTaskModelList'] as List)
              .map((i) => SubTaskModel.fromJson(i))
              .toList()
          : null,
    );
  }

  /// Method for converting an instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'taskId': taskId,
      "taskRoutineCommonId": taskRoutineCommonId,
      'taskName': taskName,
      'isTaskCompleted': isTaskCompleted,
      'tagName': tagName,
      'scheduleStartDate': scheduleStartDate,
      'scheduleEndDate': scheduleEndDate,
      'scheduleTotalDays': scheduleTotalDays,
      'timeSpanForTask': timeSpanForTask,
      'reminderAt': reminderAt,
      'isPointTimeSelected': isPointTimeSelected == true ? 1 : 0,
      'isNotifyReminder': isNotifyReminder == true ? 1 : 0,
      'subTaskModelList': subTaskModelList?.map((i) => i.toJson()).toList(),
    };
  }

  /// Method for creating a copy of the instance with optional changes
  RoutineTaskModel copyWith({
    String? taskId,
    String ? taskRoutineCommonId,
    String? taskName,
    bool? isTaskCompleted,
    String? tagName,
    String? scheduleStartDate,
    String? scheduleEndDate,
    String? scheduleTotalDays,
    String? timeSpanForTask,
    String? reminderAt,
    bool? isPointTimeSelected,
    bool? isNotifyReminder,
    List<SubTaskModel>? subTaskModelList,
  }) {
    return RoutineTaskModel(
      taskId: taskId ?? this.taskId,
      taskRoutineCommonId: taskRoutineCommonId ?? this.taskRoutineCommonId,
      taskName: taskName ?? this.taskName,
      isTaskCompleted: isTaskCompleted ?? this.isTaskCompleted,
      tagName: tagName ?? this.tagName,
      scheduleStartDate: scheduleStartDate ?? this.scheduleStartDate,
      scheduleEndDate: scheduleEndDate ?? this.scheduleEndDate,
      scheduleTotalDays: scheduleTotalDays ?? this.scheduleTotalDays,
      timeSpanForTask: timeSpanForTask ?? this.timeSpanForTask,
      reminderAt: reminderAt ?? this.reminderAt,
      isPointTimeSelected: isPointTimeSelected ?? this.isPointTimeSelected,
      isNotifyReminder: isNotifyReminder ?? this.isNotifyReminder,
      subTaskModelList: subTaskModelList ?? this.subTaskModelList,
    );
  }
}

class SubTaskModel extends Equatable {
  final String? subTaskName;
  final bool? isCompleted;

  ///SubTasks Model Constructor
  const SubTaskModel({
    this.subTaskName,
    this.isCompleted,
  });

  /// Factory method to create a SubTaskModel instance from a JSON map
  factory SubTaskModel.fromJson(Map<String, dynamic> json) {
    return SubTaskModel(
      subTaskName: json['subTaskName'],
      isCompleted: json['isCompleted'] == 1 ? true : false,
    );
  }

  /// Convert the SubTaskModel instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'subTaskName': subTaskName ?? "",
      'isCompleted': isCompleted == true ? 1 : 0,
    };
  }

  /// Create a copy of the SubTaskModel with specified fields updated
  SubTaskModel copyWith({
    String? subTaskName,
    bool? isCompleted,
  }) {
    return SubTaskModel(
      subTaskName: subTaskName ?? this.subTaskName,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [
        subTaskName,
        isCompleted,
      ];
}
