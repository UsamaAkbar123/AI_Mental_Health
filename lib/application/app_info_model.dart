import 'package:equatable/equatable.dart';

class CompleteAppInfoModel extends Equatable {
  final bool? isStepCounterGoalSet;
  final bool? isBMISetupComplete;
  final bool? isRoutinePlannerCreated;
  final bool? isConversationStated;
  final bool? isSleepQualityAdded;
  final bool? isMoodTrackerStarted;
  final bool? isPersonalInformationSet;

  const CompleteAppInfoModel({
    this.isStepCounterGoalSet,
    this.isBMISetupComplete,
    this.isRoutinePlannerCreated,
    this.isConversationStated,
    this.isSleepQualityAdded,
    this.isMoodTrackerStarted,
    this.isPersonalInformationSet,
  });

  /// Constructor to create an instance from a JSON object
  factory CompleteAppInfoModel.fromJson(Map<String, dynamic> json) {

    return CompleteAppInfoModel(
      isStepCounterGoalSet: json['isStepCounterGoalSet'] == 1 ? true : false,
      isBMISetupComplete: json['isBMISetupComplete'] == 1 ? true : false,
      isRoutinePlannerCreated:
          json['isRoutinePlannerCreated'] == 1 ? true : false,
      isConversationStated: json['isConversationStated'] == 1 ? true : false,
      isSleepQualityAdded: json['isSleepQualityAdded'] == 1 ? true : false,
      isMoodTrackerStarted: json['isMoodTrackerStarted'] == 1 ? true : false,
      isPersonalInformationSet:
          json['isPersonalInformationSet'] == 1 ? true : false,
    );
  }

  /// Method to convert the object to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'isStepCounterGoalSet': isStepCounterGoalSet! ? 1 : 0,
      'isBMISetupComplete': isBMISetupComplete! ? 1 : 0,
      'isRoutinePlannerCreated': isRoutinePlannerCreated! ? 1 : 0,
      'isConversationStated': isConversationStated! ? 1 : 0,
      'isSleepQualityAdded': isSleepQualityAdded! ? 1 : 0,
      'isMoodTrackerStarted': isMoodTrackerStarted! ? 1 : 0,
      'isPersonalInformationSet': isPersonalInformationSet! ? 1 : 0,
    };
  }

  /// Method to create a copy of the object with some fields updated
  CompleteAppInfoModel copyWith({
    bool? isStepCounterGoalSet,
    bool? isBMISetupComplete,
    bool? isRoutinePlannerCreated,
    bool? isConversationStated,
    bool? isSleepQualityAdded,
    bool? isMoodTrackerStarted,
    bool? isPersonalInformationSet,
  }) {
    return CompleteAppInfoModel(
      isStepCounterGoalSet: isStepCounterGoalSet ?? this.isStepCounterGoalSet,
      isBMISetupComplete: isBMISetupComplete ?? this.isBMISetupComplete,
      isRoutinePlannerCreated:
          isRoutinePlannerCreated ?? this.isRoutinePlannerCreated,
      isConversationStated: isConversationStated ?? this.isConversationStated,
      isSleepQualityAdded: isSleepQualityAdded ?? this.isSleepQualityAdded,
      isMoodTrackerStarted: isMoodTrackerStarted ?? this.isMoodTrackerStarted,
      isPersonalInformationSet:
          isPersonalInformationSet ?? this.isPersonalInformationSet,
    );
  }

  @override
  List<Object?> get props =>
      [
        isStepCounterGoalSet,
        isBMISetupComplete,
        isRoutinePlannerCreated,
        isConversationStated,
        isSleepQualityAdded,
        isMoodTrackerStarted,
        isPersonalInformationSet,
      ];
}
