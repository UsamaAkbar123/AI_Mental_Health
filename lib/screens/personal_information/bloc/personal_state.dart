import 'package:equatable/equatable.dart';

import '../model/personal_information_model.dart';

enum PersonalInformationStatus { initial, loading, loaded, error }

class PersonalInformationState extends Equatable {

  final PersonalInformationStatus? status;
  final PersonalInformationModel? personalInformationModel;




  const PersonalInformationState({this.status, this.personalInformationModel});




  /// Factory method to create an initial BMIState with initial status and an empty BMI model
  static PersonalInformationState initial() =>  PersonalInformationState(
        status: PersonalInformationStatus.initial,
    personalInformationModel: PersonalInformationModel.initial()
      );




  /// The copyWith method allows us to easily update one or more properties while creating a new instance
  PersonalInformationState copyWith(
      {PersonalInformationStatus? status,
      PersonalInformationModel? personalInformationModel}) {
    return PersonalInformationState(
      status: status ?? this.status,
      personalInformationModel:
          personalInformationModel ?? this.personalInformationModel,
    );
  }




  /// Override the props getter from Equatable to provide a list of properties for comparison
  @override
  List<Object?> get props => [status, personalInformationModel];
}
