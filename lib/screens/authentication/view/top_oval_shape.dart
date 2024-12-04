import 'package:flutter/material.dart';

class TopOvalShape extends StatelessWidget {
  const TopOvalShape({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: -MediaQuery
              .sizeOf(context)
              .width / 1.35,
          top: -MediaQuery
              .sizeOf(context)
              .height / 1.2,
          child: SizedBox(
            width: 960,
            height: 960,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  child: Container(
                    width: 960,
                    height: 960,
                    decoration: const ShapeDecoration(
                      color: Color(0xFF9BB067),
                      shape: OvalBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
