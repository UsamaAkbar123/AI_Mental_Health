import 'package:freud_ai/application/app_info_model.dart';

abstract class  AppInfoEvent {}

class GetAppInfoEvent extends AppInfoEvent {}


class UpdateAppInfoEvent extends AppInfoEvent {
  CompleteAppInfoModel  completeAppInfoModel;

  UpdateAppInfoEvent(this.completeAppInfoModel);

}
