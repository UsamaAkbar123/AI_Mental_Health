import 'package:freud_ai/screens/personal_information/model/personal_information_model.dart';

abstract class  PersonalInformationEvent {}


class PersonalInformationGetEvent extends PersonalInformationEvent {}

class PersonalInformationUpdateEvent extends PersonalInformationEvent {
  PersonalInformationModel model;

  PersonalInformationUpdateEvent(this.model);
}



class PersonalInformationAddEvent extends PersonalInformationEvent {
  PersonalInformationModel model;

  PersonalInformationAddEvent(this.model);
}
