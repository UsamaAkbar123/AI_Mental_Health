class MoodModel {
  int? id;
  String? moodName;
  String? moodEmoji;
  String? moodDate;
  String? moodTimeStamp;
  String? moodQuotation;

  MoodModel({
    this.id,
    this.moodName,
    this.moodEmoji,
    this.moodDate,
    this.moodTimeStamp,
    this.moodQuotation,
  });

  factory MoodModel.fromJson(Map<String, dynamic> json) {
    return MoodModel(
      id: json['id'],
      moodName: json['moodName'],
      moodEmoji: json['moodEmoji'],
      moodDate: json['moodDate'],
      moodTimeStamp: json['moodTimeStamp'],
      moodQuotation: json['moodQuotation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'moodName': moodName,
      'moodEmoji': moodEmoji,
      'moodDate': moodDate,
      'moodTimeStamp': moodTimeStamp,
      'moodQuotation': moodQuotation,
    };
  }

  MoodModel copyWith({
    int? id,
    String? moodName,
    String? moodEmoji,
    String? moodDate,
    String? moodTimeStamp,
    String? moodQuotation,
  }) {
    return MoodModel(
      id: id ?? this.id,
      moodName: moodName ?? this.moodName,
      moodEmoji: moodEmoji ?? this.moodEmoji,
      moodDate: moodDate ?? this.moodDate,
      moodTimeStamp: moodTimeStamp ?? this.moodTimeStamp,
      moodQuotation: moodQuotation ?? this.moodQuotation,
    );
  }
}
