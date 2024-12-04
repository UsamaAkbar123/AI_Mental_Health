import 'package:freud_ai/screens/sleep/model/sleep_model.dart';

abstract class SleepEvent {}

/// Sleep initial Event
class SleepInitialEvent extends SleepEvent {}

/// Sleep Event
class GetSleepEvent extends SleepEvent {}

/// Add Sleep Event
class AddSleepEvent extends SleepEvent {
  SleepModel? sleepModel;

  AddSleepEvent({this.sleepModel});
}

/// Update Sleep Event
class UpdateSleepEvent extends SleepEvent {}
