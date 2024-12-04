import 'package:equatable/equatable.dart';
import 'package:freud_ai/screens/bmi/model/bmi_model.dart';

/// Define an enum to represent different states of BMIState
enum BMIStateStatus { initial, loading, loaded, error }



/// Define the BMIState class which extends Equatable for easy comparison
class BMIState extends Equatable {
  final BMIStateStatus? status;
  final List<AddBMIModel>? bmiModelList;

  const BMIState({this.status, this.bmiModelList});





  /// Factory method to create an initial BMIState with initial status and an empty BMI model
  static BMIState initial() => const BMIState(status: BMIStateStatus.initial, bmiModelList: []);






  /// The copyWith method allows us to easily update one or more properties while creating a new instance
  BMIState copyWith({BMIStateStatus? status, List<AddBMIModel>? bmiModelList}) {
    return BMIState(
      status: status ?? this.status,
      bmiModelList: bmiModelList ?? this.bmiModelList,
    );
  }





  /// Override the props getter from Equatable to provide a list of properties for comparison
  @override
  List<Object?> get props => [status, bmiModelList];
}
