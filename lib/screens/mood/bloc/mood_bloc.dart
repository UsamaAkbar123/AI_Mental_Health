import 'package:bloc/bloc.dart';
import 'package:freud_ai/configs/database/database_helper.dart';
import 'package:freud_ai/screens/mood/bloc/mood_event.dart';
import 'package:freud_ai/screens/mood/bloc/mood_state.dart';
import 'package:freud_ai/screens/mood/data/mood_resources.dart';
import 'package:sqflite/sqlite_api.dart';

class MoodBloc extends Bloc<MoodEvent, MoodState> {
  MoodBloc() : super(MoodState.initial()) {
    on<AddMoodEvent>(_addMoodEvent);
    on<GetMoodEvent>(_getAllMoods);
    on<DeleteMoodByIdEvent>(_deleteMoodByIdEvent);
  }

  ///Here we will get the all Moods
  _getAllMoods(GetMoodEvent event, Emitter<MoodState> emit) async {
    emit(state.copyWith(status: MoodStateStatus.initial));
    Database database = await databaseHelper.database;

    MoodDataResources moodDataResources = MoodDataResources(database);

    final list = await moodDataResources.getStoredMoods();


    if(list!=null){
      emit(state.copyWith(status:MoodStateStatus.loaded, moodModelList: list));
    }else{
      emit(state.copyWith(status:MoodStateStatus.initial, moodModelList: list));
    }


  }

  // Delete mood by id
  void _deleteMoodByIdEvent(
      DeleteMoodByIdEvent event, Emitter<MoodState> emit) async {
    Database database = await databaseHelper.database;
    MoodDataResources moodDataResources = MoodDataResources(database);

    emit(state.copyWith(status: MoodStateStatus.loading));

    await moodDataResources.deleteMoodBYId(event.moodId);

    final list = await moodDataResources.getStoredMoods();

    emit(state.copyWith(
      status: MoodStateStatus.loaded,
      moodModelList: list,
    ));
  }

  ///Add Mood Event where user can add daily mood
  _addMoodEvent(AddMoodEvent event, Emitter<MoodState> emit) async {
    emit(state.copyWith(status: MoodStateStatus.initial));

    Database database = await databaseHelper.database;

    MoodDataResources moodDataResources = MoodDataResources(database);

    await moodDataResources.addMoodToTheDatabase(event.moodModel!);

    final list = await moodDataResources.getStoredMoods();

    emit(state.copyWith(status: MoodStateStatus.loaded, moodModelList: list));
  }

}