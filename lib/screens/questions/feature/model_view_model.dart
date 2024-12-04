import 'package:flutter/cupertino.dart';

class FeatureViewModel {
  String? text1;
  String? text2;
  String? text3;
  String? text4;
  String? animation;
  Color? text1Color;
  Color? text2Color;
  Color? text3Color;
  Color? text4Color;
  String? background;
  bool? isAnimationFill;
  String? parentFeatureName;
  List<Widget>? listOfWidgets;

  FeatureViewModel(
      {this.text1,
      this.text2,
      this.text3,
      this.text4,
      this.animation,
      this.text1Color,
      this.text2Color,
      this.text3Color,
      this.text4Color,
      this.background,
      this.listOfWidgets,
      this.parentFeatureName,
      this.isAnimationFill});
}
