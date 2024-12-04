import 'package:freud_ai/application/app_info_model.dart';

abstract class AppInfoState {}

class AppInfoInitialState extends AppInfoState{}

class AppInfoLoadedState extends AppInfoState{

  CompleteAppInfoModel?  completeAppInfoModel;

  AppInfoLoadedState({this.completeAppInfoModel});

}