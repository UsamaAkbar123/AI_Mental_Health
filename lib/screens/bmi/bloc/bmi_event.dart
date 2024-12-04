import 'package:freud_ai/screens/bmi/model/bmi_model.dart';

abstract class BMIEvent {}


class GetBMIEvent extends BMIEvent{}


class AddBMIEvent extends BMIEvent{
  AddBMIModel addBMIModel;
  AddBMIEvent(this.addBMIModel);
}


class DeleteBMIEvent extends BMIEvent{
  String bmiUniqueId;
  DeleteBMIEvent(this.bmiUniqueId);
}
