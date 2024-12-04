import 'package:equatable/equatable.dart';
import 'package:freud_ai/screens/mood/model/mood_model.dart';

enum MoodStateStatus {initial , loading ,loaded , error }

class MoodState extends Equatable {

  final MoodStateStatus? status;
  final List<MoodModel>? moodModelList;

  const MoodState({this.status, this.moodModelList});



  /// Factory method to create an initial BMIState with initial status and an empty BMI model
  static MoodState initial() =>
      const MoodState(status: MoodStateStatus.initial, moodModelList: []);




  /// The copyWith method allows us to easily update one or more properties while creating a new instance
  MoodState copyWith(
      {MoodStateStatus? status, List<MoodModel>? moodModelList}) {
    return MoodState(
      status: status ?? this.status,
      moodModelList: moodModelList ?? this.moodModelList,
    );
  }





  /// Override the props getter from Equatable to provide a list of properties for comparison
  @override
  List<Object?> get props => [status, moodModelList];
}