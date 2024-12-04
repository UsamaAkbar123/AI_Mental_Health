import 'dart:convert';

import 'package:equatable/equatable.dart';

class QuestionSummaryModel extends Equatable {
  final String? selectedGoal;
  final String? question;
  final String? featureName;
  final List<String>? answersList;

  ///Constructor
  const QuestionSummaryModel(
      {this.selectedGoal, this.question, this.featureName, this.answersList});


  ///Order Summary Model to use just when and only param needs to change
  QuestionSummaryModel copyWith(
      {String? selectedGoal,
      String? question,
      String? featureName,
      List<String>? answersList}) {
    return QuestionSummaryModel(
      selectedGoal: selectedGoal ?? this.selectedGoal,
      question: question ?? this.question,
      featureName: featureName ?? this.featureName,
      answersList: answersList ?? this.answersList,
    );
  }

  ///This Method will convert this model to json format
  Map<String, dynamic> toJson() {
    return {
      'selectedGoal': selectedGoal,
      'question': question,
      'featureName': featureName,
      'answersList': answersList != null ? jsonEncode(answersList) : null,
    };
  }


  ///Order Summary model to get the values as json
  factory QuestionSummaryModel.fromJson(Map<String, dynamic> json) {

    return QuestionSummaryModel(
      selectedGoal: json['selectedGoal'],
      question: json['question'],
      featureName: json['featureName'],
      answersList: json['answersList'] != null
          ? List<String>.from(jsonDecode(json['answersList']))
          : null,
    );
  }




  @override
  List<Object?> get props => [selectedGoal, question, featureName, answersList];
}
