import 'package:equatable/equatable.dart';
import 'package:freud_ai/screens/sleep/model/sleep_model.dart';

enum SleepStateStatus { initial, loading, loaded, error }

class SleepState extends Equatable {
  final SleepStateStatus? status;
  final SleepModel? sleepSchedule;
  final List<SleepModel>? sleepModelList;

  const SleepState({this.status, this.sleepModelList, this.sleepSchedule});



  /// Factory method to create an initial SleepState with initial status and an empty Sleep model list
  static SleepState initial() => const SleepState(
      status: SleepStateStatus.initial,
      sleepModelList:  [],
      sleepSchedule: SleepModel());



  /// The copyWith method allows us to easily update one or more properties while creating a new instance
  SleepState copyWith(
      {SleepStateStatus? status,
      List<SleepModel>? sleepModelList,
      SleepModel? sleepSchedule}) {
    return SleepState(
      status: status ?? this.status,
      sleepSchedule: sleepSchedule ?? this.sleepSchedule,
      sleepModelList: sleepModelList ?? this.sleepModelList,
    );
  }




  /// Override the props getter from Equatable to provide a list of properties for comparison
  @override
  List<Object?> get props => [status, sleepModelList, sleepModelList];
}
