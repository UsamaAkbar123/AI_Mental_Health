import 'package:flutter/material.dart';

class BackGroundView extends StatelessWidget {
  final Color? borderColor;
  final double? borderWidth;
  final double? containerHeight;

  const BackGroundView(
      {super.key, this.borderColor, this.borderWidth, this.containerHeight});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: containerHeight,
      height: containerHeight,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
        border: Border.all(
          width: borderWidth!,
          color: borderColor!,
        ),
      ),
    );
  }
}
