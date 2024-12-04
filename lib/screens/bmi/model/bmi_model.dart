import 'package:equatable/equatable.dart';

class AddBMIModel extends Equatable {
  final int? id;
  final String? bmiHeight;
  final String? bmiWeight;
  final String? heightSymbol;
  final String? weightSymbol;
  final String? bmiScore;
  final String? dateBMI;
  final String? bmiStatus;
  final String? bmiTimeStamp;

  const AddBMIModel(
      {this.id,
      this.bmiHeight,
      this.bmiWeight,
      this.heightSymbol,
      this.weightSymbol,
      this.bmiScore,
      this.dateBMI,
      this.bmiStatus,
      this.bmiTimeStamp});

  static AddBMIModel initial() => const AddBMIModel(
        bmiHeight: "",
        bmiWeight: "",
        heightSymbol: "",
        weightSymbol: "",
        bmiScore: "",
        dateBMI: "",
        bmiStatus: "",
        bmiTimeStamp: "",
      );

  // Constructor to create an AddBMIModel instance from a JSON map
  factory AddBMIModel.fromJson(Map<String, dynamic> json) {
    return AddBMIModel(
      id: json['id'],
      bmiHeight: json['bmiHeight'],
      bmiWeight: json['bmiWeight'],
      heightSymbol: json['heightSymbol'],
      weightSymbol: json['weightSymbol'],
      bmiScore: json['bmiScore'],
      dateBMI: json['dateBMI'],
      bmiStatus: json['bmiStatus'],
      bmiTimeStamp: json['bmiTimeStamp'],
    );
  }

  // Method to convert AddBMIModel instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'bmiHeight': bmiHeight,
      'bmiWeight': bmiWeight,
      'heightSymbol': heightSymbol,
      'weightSymbol': weightSymbol,
      'bmiScore': bmiScore,
      'dateBMI': dateBMI,
      'bmiStatus': bmiStatus,
      'bmiTimeStamp': bmiTimeStamp,
    };
  }

  // Method to create a new instance of AddBMIModel with updated properties
  AddBMIModel copyWith({
    String? bmiHeight,
    String? bmiWeight,
    String? heightSymbol,
    String? weightSymbol,
    String? bmiScore,
    String? dateBMI,
    String? bmiStatus,
    String? bmiTimeStamp,
  }) {
    return AddBMIModel(
      bmiHeight: bmiHeight ?? this.bmiHeight,
      bmiWeight: bmiWeight ?? this.bmiWeight,
      heightSymbol: heightSymbol ?? this.heightSymbol,
      weightSymbol: weightSymbol ?? this.weightSymbol,
      bmiScore: bmiScore ?? this.bmiScore,
      dateBMI: dateBMI ?? this.dateBMI,
      bmiStatus: bmiStatus ?? this.bmiStatus,
      bmiTimeStamp: bmiTimeStamp ?? this.bmiTimeStamp,
    );
  }

  @override
  List<Object?> get props => [
        id,
        bmiHeight,
        bmiWeight,
        heightSymbol,
        weightSymbol,
        bmiScore,
        dateBMI,
        bmiStatus,
        bmiTimeStamp
      ];
}
