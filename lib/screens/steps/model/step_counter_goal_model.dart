import 'package:equatable/equatable.dart';

class StepCounterGoalModel extends Equatable {
  final String? todayDateId;
  final int? goalStep;
  final double? goalCalories;
  final double? goalDistance;
  final int? dayStartStepValue;
  final int? dayEndStepValue;
  final int? dayTotalSteps;
  final String? timeStamp;

  const StepCounterGoalModel({
    this.todayDateId,
    this.goalStep,
    this.goalCalories,
    this.goalDistance,
    this.dayStartStepValue,
    this.dayEndStepValue,
    this.dayTotalSteps,
    this.timeStamp,
  });

  StepCounterGoalModel copyWith({
    String? todayDateId,
    int? goalStep,
    double? goalCalories,
    double? goalDistance,
    int? dayStartStepValue,
    int? dayEndStepValue,
    int? dayTotalSteps,
    String? timeStamp,
  }) {
    return StepCounterGoalModel(
      todayDateId: todayDateId ?? this.todayDateId,
      goalStep: goalStep ?? this.goalStep,
      goalCalories: goalCalories ?? this.goalCalories,
      goalDistance: goalDistance ?? this.goalDistance,
      dayStartStepValue: dayStartStepValue ?? this.dayStartStepValue,
      dayEndStepValue: dayEndStepValue ?? this.dayEndStepValue,
      dayTotalSteps: dayTotalSteps ?? this.dayTotalSteps,
      timeStamp: timeStamp ?? this.timeStamp,
    );
  }

  factory StepCounterGoalModel.fromJson(Map<String, dynamic> json) {
    return StepCounterGoalModel(
      todayDateId: json['todayDateId'],
      goalStep: json['goalStep'],
      goalCalories: json['goalCalories'],
      goalDistance: json['goalDistance'],
      dayStartStepValue: json['dayStartStepValue'],
      dayEndStepValue: json['dayEndStepValue'],
      dayTotalSteps: json['dayTotalSteps'],
      timeStamp: json['timeStamp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'todayDateId': todayDateId,
      'goalStep': goalStep,
      'goalCalories': goalCalories,
      'goalDistance': goalDistance,
      'dayStartStepValue': dayStartStepValue,
      'dayEndStepValue': dayEndStepValue,
      'dayTotalSteps': dayTotalSteps,
      'timeStamp': timeStamp,
    };
  }

  @override
  List<Object?> get props => [
        todayDateId,
        goalStep,
        goalCalories,
        goalDistance,
        dayStartStepValue,
        dayEndStepValue,
        dayTotalSteps,
        timeStamp,
      ];
}
