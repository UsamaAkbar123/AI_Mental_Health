import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:freud_ai/configs/helper/extensions.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';

class AnimatedSwitch extends StatefulWidget {

  final bool? isChecked;
  final Function? callBack;
  const AnimatedSwitch({super.key,this.isChecked,this.callBack});

  @override
  AnimatedSwitchState createState() => AnimatedSwitchState();
}

class AnimatedSwitchState extends State<AnimatedSwitch>
    with TickerProviderStateMixin {
  bool isChecked = false;
  final Duration _duration = const Duration(milliseconds: 370);
  Animation<Alignment>? _animation;
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();

    isChecked = widget.isChecked ?? false;

    _animationController =
        AnimationController(vsync: this, duration: _duration);

    if (isChecked) {
      _animationController!.forward();
    }

    _animation =
        AlignmentTween(begin: Alignment.centerLeft, end: Alignment.centerRight)
            .animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn,
      ),
    );
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController!,
      builder: (context, child) {
        return Center(
          child: Container(
            width: 50.w,
            height: 25.h,
            padding: EdgeInsets.symmetric(vertical: 2.h),
            decoration: BoxDecoration(
              color: isChecked
                  ? AppTheme.cT!.greenColor
                  : AppTheme.cT!.lightBrownColor,
              borderRadius: BorderRadius.all(Radius.circular(25.w)),
            ),
            child: Stack(
              children: [
                Align(
                  alignment: _animation!.value,
                  child: Container(
                    width: 30,
                    height: 35,
                    alignment: Alignment.centerLeft,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ).clickListener(
          click: () {
            setState(
              () {
                if (_animationController!.isCompleted) {
                  _animationController!.reverse();
                } else {
                  _animationController!.forward();
                }

                log("PrintedValue 1:: $isChecked");

                isChecked = !isChecked;

                log("PrintedValue 2:: $isChecked");

                widget.callBack!.call(isChecked);
              },
            );
          },
        );
      },
    );
  }
}
