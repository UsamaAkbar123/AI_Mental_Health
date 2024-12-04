import 'package:flutter/material.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/screens/home/view/header/header_text.dart';

class HomeHeaderView extends StatelessWidget {
  const HomeHeaderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 12.w,
        right: 12.w,
        top: 66.h,
        bottom: 12.h,
      ),
      decoration: ShapeDecoration(
        color: AppTheme.cT!.appColorLight!,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(32.w),
            bottomLeft: Radius.circular(32.w),
          ),
        ),
        shadows: [
          const BoxShadow(
            color: Color(0x0C4B3425),
            blurRadius: 0,
            offset: Offset(0, 0),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: const Color(0x0C4B3425),
            blurRadius: 15.w,
            offset: const Offset(0, 7),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: const Color(0x0A4B3425),
            blurRadius: 28.w,
            offset: const Offset(0, 28),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: const Color(0x074B3425),
            blurRadius: 37.w,
            offset: const Offset(0, 62),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: const Color(0x024B3425),
            blurRadius: 44.w,
            offset: const Offset(0, 110),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: const Color(0x004B3425),
            blurRadius: 48.w,
            offset: const Offset(0, 172),
            spreadRadius: 0,
          )
        ],
      ),
      child: const HeaderText(),
    );
  }






}
