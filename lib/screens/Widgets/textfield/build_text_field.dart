import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';

class CustomTextField extends StatelessWidget {
  final String? headingName;
  final String? hintName;
  final String? fieldType;
  final String? startIcon;
  final String? endIcon;
  final bool? isFocused;
  final int? maxLines;
  final Color? backgroundColor;
  final TextEditingController? controller;

  const CustomTextField(
      {super.key,
      this.headingName,
      this.hintName,
      this.controller,
      this.startIcon,
      this.endIcon,
      this.isFocused,
      this.maxLines,
      this.backgroundColor,
      this.fieldType});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        headingName != null
            ? CommonWidgets().makeDynamicText(
                text: headingName,
                size: 14,
                weight: FontWeight.w800,
                color: AppTheme.cT!.appColorLight)
            : const SizedBox(),
        12.height,
        Container(
          height: 52.h,
          alignment: Alignment.center,
          decoration: ShapeDecoration(
            color: backgroundColor??AppTheme.cT!.whiteColor,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                  width: 1.w,
                  color: isFocused == null
                      ? AppTheme.cT!.whiteColor!
                      : AppTheme.cT!.greenColor!),
              borderRadius: BorderRadius.circular(26.w),
            ),
            shadows: isFocused == null
                ? []
                : [
                    BoxShadow(
                      color: const Color(0x3F9BB068),
                      blurRadius: 0,
                      offset: const Offset(0, 0),
                      spreadRadius: 4.w,
                    )
                  ],
          ),
          child: TextField(
            maxLines: maxLines ?? 1,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintName,
                hintStyle: TextStyle(
                    color: AppTheme.cT!.lightGrey,
                    fontWeight: FontWeight.normal),
                prefixIcon: startIcon != null
                    ? IconButton(
                        onPressed: () {},
                        icon: SizedBox(
                            height: 24.h,
                            width: 24.w,
                            child: SvgPicture.asset(startIcon!)))
                    : const SizedBox(),
                /*suffixIcon: IconButton(
                  onPressed: () {},
                  icon: endIcon != null
                      ? SizedBox(
                          height: 24.h,
                          width: 24.w,
                          child: SvgPicture.asset("assets/$endIcon"))
                      : const SizedBox(),
                ),*/
                contentPadding: EdgeInsets.only(top: 4.h)),
          ),
        ),
      ],
    );
  }
}
