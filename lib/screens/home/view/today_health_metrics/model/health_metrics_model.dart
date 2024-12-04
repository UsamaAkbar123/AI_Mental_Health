import 'package:flutter/material.dart';

class HealthMetricsModel {
  String? emoji;
  String? name;
  String? type;
  String? subText;
  String? graph;
  Color? backgroundColor;

  HealthMetricsModel(
      {this.emoji,
      this.name,
      this.type,
      this.subText,
      this.graph,
      this.backgroundColor});
}
