import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freud_ai/application/app_info_model.dart';
import 'package:freud_ai/application/bloc/app_info_event.dart';
import 'package:freud_ai/application/bloc/app_info_state.dart';
import 'package:freud_ai/application/data/app_info_data_resources.dart';
import 'package:freud_ai/configs/database/database_helper.dart';

class AppInfoBloc extends Bloc<AppInfoEvent, AppInfoState> {
  CompleteAppInfoModel? completeAppInfoModel;

  AppInfoBloc() : super(AppInfoInitialState()) {
    on<GetAppInfoEvent>(_getAppInfoEvent);
    on<UpdateAppInfoEvent>(_updateAppInfo);
  }

  _updateAppInfo(UpdateAppInfoEvent event, Emitter<AppInfoState> emit) async {
    final database = await databaseHelper.database;

    await AppInfoDataResources(database).insertOrUpdateAppInfo(event.completeAppInfoModel);




    completeAppInfoModel = await AppInfoDataResources(database).getAppInfo() ?? setAnEmptyModelWhenNoRecordExist();

    log("NotEmptyCalling :: ${completeAppInfoModel!.isStepCounterGoalSet}");


    emit(AppInfoLoadedState(completeAppInfoModel: completeAppInfoModel));

  }

  ///Here We will Get The Complete App Info
  _getAppInfoEvent(GetAppInfoEvent event, Emitter<AppInfoState> emit) async {
    final database = await databaseHelper.database;

    completeAppInfoModel = await AppInfoDataResources(database).getAppInfo() ?? setAnEmptyModelWhenNoRecordExist();


    log("NotEmptyCalling 11:: ${completeAppInfoModel!.isStepCounterGoalSet}");


    emit(AppInfoLoadedState(completeAppInfoModel: completeAppInfoModel));
  }

  ///This will call only Once when app Started
  CompleteAppInfoModel setAnEmptyModelWhenNoRecordExist() {

    return const CompleteAppInfoModel(
        isStepCounterGoalSet: false,
        isBMISetupComplete: false,
        isRoutinePlannerCreated: false,
        isConversationStated: false,
        isSleepQualityAdded: false,
        isPersonalInformationSet: false,
        isMoodTrackerStarted: false);


  }
}
