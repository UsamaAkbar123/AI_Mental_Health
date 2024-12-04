import 'package:bloc/bloc.dart';
import 'package:freud_ai/configs/database/database_helper.dart';
import 'package:freud_ai/screens/sleep/bloc/sleep_event.dart';
import 'package:freud_ai/screens/sleep/bloc/sleep_state.dart';
import 'package:freud_ai/screens/sleep/data/data_resources.dart';
import 'package:freud_ai/screens/sleep/model/sleep_model.dart';
import 'package:sqflite/sqlite_api.dart';

class SleepBloc extends Bloc<SleepEvent, SleepState> {
  SleepBloc() : super(SleepState.initial()) {
    on<AddSleepEvent>(_addSleepEvent);
    on<GetSleepEvent>(_getAllMoods);
  }

  ///Here we will get the all Moods
  _getAllMoods(GetSleepEvent event, Emitter<SleepState> emit) async {
    emit(state.copyWith(status: SleepStateStatus.initial));

    Database database = await databaseHelper.database;

    SleepDataResources moodDataResources = SleepDataResources(database);

    SleepModel? model = await moodDataResources.getStoredSleepSchedule();

    if (model != null) {
      emit(state.copyWith(
          status: SleepStateStatus.loaded, sleepSchedule: model));
    } else {
      emit(state.copyWith(
          status: SleepStateStatus.initial, sleepSchedule: null));
    }
  }

  ///Add Mood Event where user can add daily mood
  _addSleepEvent(AddSleepEvent event, Emitter<SleepState> emit) async {
    emit(state.copyWith(status: SleepStateStatus.initial));

    Database database = await databaseHelper.database;

    SleepDataResources moodDataResources = SleepDataResources(database);

    await moodDataResources.addSleepToTheDatabase(event.sleepModel!);

    final sleepSchedule = await moodDataResources.getStoredSleepSchedule();

    emit(state.copyWith(
        status: SleepStateStatus.loaded, sleepSchedule: sleepSchedule));


  }
}
