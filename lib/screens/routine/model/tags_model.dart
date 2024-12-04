
import 'package:equatable/equatable.dart';
class TagsModel  extends Equatable{
  final int? id;
  final String? title;
  final bool? isSelected;

  const TagsModel({this.id, this.title, this.isSelected});



  ///Tags Model Initial
  static TagsModel initial() => const TagsModel(title: "",isSelected: false);



  ///Tags Model fromJson function
  factory TagsModel.fromJson(Map<String, dynamic> json) {
    return TagsModel(
      id: json['id'],
      title: json['title'],
      isSelected: json['isSelected'] == 1 ? true : false,
    );
  }


  ///Tags Model ToJson Function
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'isSelected': isSelected! ? 1:0,
    };
  }


  ///Tags Model Copy with function
  TagsModel copyWith({
    String? title,
    bool? isSelected,
  }) {
    return TagsModel(
      title: title ?? this.title,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  List<Object?> get props => [id,title,isSelected];
}
