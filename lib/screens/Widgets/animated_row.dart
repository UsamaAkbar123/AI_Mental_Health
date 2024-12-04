import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class AnimatedRowWrapper extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment? mainAxisAlignment;
  final CrossAxisAlignment? crossAxisAlignment;

  const AnimatedRowWrapper(
      {super.key,
        required this.children,
        this.mainAxisAlignment,
        this.crossAxisAlignment});

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.center,
        crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
        children: AnimationConfiguration.toStaggeredList(
          duration: const Duration(milliseconds: 357),
          childAnimationBuilder: (widget) => SlideAnimation(
            horizontalOffset: 50.0,
            curve: Curves.easeInOut,
            duration: const Duration(milliseconds: 357),
            child: FadeInAnimation(
              child: widget,
            ),
          ),
          children: children,
        ),
      ),
    );
  }
}
