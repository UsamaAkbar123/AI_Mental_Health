class PersonalInformationModel {
  int? id;
  String? name;
  String? gender;
  String? dateOfBirth;
  String? dateOfBirthStamp;
  String? selectedAvatar;


  ///Personal information Model
  PersonalInformationModel({
    this.name,
    this.id,
    this.gender,
    this.dateOfBirth,
    this.dateOfBirthStamp,
    this.selectedAvatar,
  });




  /// Method to create a PersonalInformationModel instance with initial values
  factory PersonalInformationModel.initial() {
    return PersonalInformationModel(
      name: '',
      gender: '',
      dateOfBirth: '',
      dateOfBirthStamp: '',
      selectedAvatar: '',
    );
  }




  ///Personal Information Model
  factory PersonalInformationModel.fromJson(Map<String, dynamic> json) {
    return PersonalInformationModel(
      id: json['id'],
      name: json['name'],
      gender: json['gender'],
      dateOfBirth: json['dateOfBirth'],
      dateOfBirthStamp: json['dateOfBirthStamp'],
      selectedAvatar: json['selectedAvatar'],
    );
  }



  ///Personal Information Model toJson
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
      'dateOfBirthStamp': dateOfBirthStamp,
      'selectedAvatar': selectedAvatar,
    };
  }


  ///Personal Information CopyWith
  PersonalInformationModel copyWith({
    int? id,
    String? name,
    String? gender,
    String? dateOfBirth,
    String? dateOfBirthStamp,
    String? selectedAvatar,
  }) {
    return PersonalInformationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      dateOfBirthStamp: dateOfBirthStamp ?? this.dateOfBirthStamp,
      selectedAvatar: selectedAvatar ?? this.selectedAvatar,
    );
  }
}
