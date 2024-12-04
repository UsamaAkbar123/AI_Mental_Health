class SleepListModel  {
  String? date;
  String? timeStamp;
  String? sleepQuotation;
  String? sleepStatus;

  SleepListModel({
    this.date,
    this.timeStamp,
    this.sleepQuotation,
    this.sleepStatus,
  });

  factory SleepListModel.fromJson(Map<String, dynamic> json) {
    return SleepListModel(
      date: json['date'] as String?,
      timeStamp: json['timeStamp'] as String?,
      sleepQuotation: json['sleepQuotation'] as String?,
      sleepStatus: json['sleepStatus'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['timeStamp'] = timeStamp;
    data['sleepQuotation'] = sleepQuotation;
    data['sleepStatus'] = sleepStatus;
    return data;
  }

  SleepListModel copyWith({
    String? date,
    String? timeStamp,
    String? sleepQuotation,
    String? sleepStatus,
  }) {
    return SleepListModel(
      date: date ?? this.date,
      timeStamp: timeStamp ?? this.timeStamp,
      sleepQuotation: sleepQuotation ?? this.sleepQuotation,
      sleepStatus: sleepStatus ?? this.sleepStatus,
    );
  }
}
