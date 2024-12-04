import 'dart:developer';

enum WeightUnit { kg, lbs }

enum HeightUnit { cm, feet }

class BMICalculator {
  Map<String, String> calculateBMI({
    required double weight,
    required WeightUnit weightUnit,
    required double height,
    required HeightUnit heightUnit,
  }) {
    double weightInKg = 0.0;
    double heightInMeters = 0.0;

    /// if weight in lbs
    if (weightUnit == WeightUnit.lbs) {
      weightInKg = weight / 2.205;
    }

    if (weightUnit == WeightUnit.kg) {
      weightInKg = weight;
    }

    /// case 1: when height is in feet.inches
    if (heightUnit == HeightUnit.feet) {
      heightInMeters = height / 3.281;
    }

    /// case 2: when height is in centimeter
    if (heightUnit == HeightUnit.cm) {
      heightInMeters = height.ceil() / 100;
    }

    double bmi = weightInKg / (heightInMeters * heightInMeters);

    String bmiCategory = _getBMICategory(bmi);

    log("weight: $weightInKg");
    log("height in meter: $heightInMeters");

    return {'bmi': bmi.toStringAsFixed(1), 'category': bmiCategory};
  }

  String _getBMICategory(double bmi) {
    if (bmi < 18.5) {
      return 'Underweight';
    } else if (bmi < 24.9) {
      return 'Normal weight';
    } else if (bmi < 29.9) {
      return 'Overweight';
    } else {
      return 'Obesity';
    }
  }
}
