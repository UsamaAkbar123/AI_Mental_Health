import 'package:bloc/bloc.dart';
import 'package:freud_ai/configs/database/database_helper.dart';
import 'package:freud_ai/screens/bmi/bloc/bmi_event.dart';
import 'package:freud_ai/screens/bmi/bloc/bmi_state.dart';
import 'package:freud_ai/screens/bmi/data/data_resources.dart';
import 'package:freud_ai/screens/bmi/model/bmi_model.dart';
import 'package:sqflite/sqlite_api.dart';

/// Business logic component for managing BMI-related functionality.
class BMIBloc extends Bloc<BMIEvent, BMIState> {
  BMIBloc() : super(BMIState.initial()) {
    on<AddBMIEvent>(_addBMIEvent);

    on<GetBMIEvent>(_getBMIEvent);

    on<DeleteBMIEvent>(_deleteBMIEvent);
  }

  /// Delete bmi by id
  void _deleteBMIEvent(DeleteBMIEvent event, Emitter<BMIState> emit) async {
    Database database = await databaseHelper.database;

    emit(state.copyWith(status: BMIStateStatus.loading));

    await BMIDataResources(database).deleteBmiBYId(event.bmiUniqueId);

    List<AddBMIModel>? listOfBMIModel =
        await BMIDataResources(database).getStoredBMIs();

    emit(
      state.copyWith(
        status: BMIStateStatus.loaded,
        bmiModelList: listOfBMIModel,
      ),
    );
  }

  /// Event handler for fetching BMI data.
  void _getBMIEvent(GetBMIEvent event, Emitter<BMIState> emit) async {

    Database database = await databaseHelper.database;

    emit(state.copyWith(status: BMIStateStatus.loading));

    List<AddBMIModel>? listOfBMIModel =
    await BMIDataResources(database).getStoredBMIs();

    emit(state.copyWith(
        status: BMIStateStatus.loaded, bmiModelList: listOfBMIModel));


  }







  /// Event handler for adding new BMI data.
  void _addBMIEvent(AddBMIEvent event, Emitter<BMIState> emit) async {

    Database database = await databaseHelper.database;

    emit(state.copyWith(status: BMIStateStatus.loading));

    /// Add new BMI data to the database
    await BMIDataResources(database).addBMIToTheDatabase(event.addBMIModel);


    List<AddBMIModel>? listOfBMIModel =
        await BMIDataResources(database).getStoredBMIs();


    emit(state.copyWith(
        status: BMIStateStatus.loaded, bmiModelList: listOfBMIModel));

  }
}
