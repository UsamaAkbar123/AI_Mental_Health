import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:freud_ai/configs/database/database_helper.dart';
import 'package:freud_ai/screens/personal_information/bloc/personal_event.dart';
import 'package:freud_ai/screens/personal_information/bloc/personal_state.dart';
import 'package:freud_ai/screens/personal_information/data/date_resources.dart';
import 'package:freud_ai/screens/personal_information/model/personal_information_model.dart';
import 'package:sqflite/sqlite_api.dart';


/// Business logic component for managing BMI-related functionality.
class PersonalInformationBloc
    extends Bloc<PersonalInformationEvent, PersonalInformationState> {
  PersonalInformationBloc() : super(PersonalInformationState.initial()) {

    on<PersonalInformationGetEvent>(_getPersonalInformation);

    on<PersonalInformationUpdateEvent>(_updatePersonalInformation);

    on<PersonalInformationAddEvent>(_addBMIEvent);

  }






  /// Event handler for fetching BMI data.
  void _getPersonalInformation(PersonalInformationGetEvent event,
      Emitter<PersonalInformationState> emit) async {
    Database database = await databaseHelper.database;

    emit(state.copyWith(status: PersonalInformationStatus.loading));

    PersonalInformationModel? model =
        await PersonalInformationDataResources(database)
            .getStoredPersonalInformation();

    log("GetEventValue :: ${model!.name}");


    emit(state.copyWith(
        status: PersonalInformationStatus.loaded,
        personalInformationModel: model));
  }





  /// Event handler for fetching BMI data.
  void _updatePersonalInformation(PersonalInformationUpdateEvent event,
      Emitter<PersonalInformationState> emit) async {
    Database database = await databaseHelper.database;

    emit(state.copyWith(status: PersonalInformationStatus.loading));

    await PersonalInformationDataResources(database)
        .updatePersonalInformation(event.model);

    emit(state.copyWith(
        status: PersonalInformationStatus.loaded,
        personalInformationModel: event.model));
  }




  /// Event handler for adding new BMI data.
  void _addBMIEvent(PersonalInformationAddEvent event,
      Emitter<PersonalInformationState> emit) async {
    Database database = await databaseHelper.database;

    emit(state.copyWith(status: PersonalInformationStatus.loading));

    await PersonalInformationDataResources(database)
        .addPersonalInformation(event.model);

    emit(state.copyWith(
        status: PersonalInformationStatus.loaded,
        personalInformationModel: event.model));
  }
}
