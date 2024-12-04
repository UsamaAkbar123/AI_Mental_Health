import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/configs/constants/assets.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/screens/languages/model/language_model.dart';

class LanguagesItemView extends StatefulWidget {
  final LanguageModel? languageModel;
  final List<LanguageModel>? languageList;
  final Function? updateList;

  const LanguagesItemView(
      {super.key, this.languageModel, this.languageList, this.updateList});

  @override
  State<LanguagesItemView> createState() => _LanguagesItemViewState();
}

class _LanguagesItemViewState extends State<LanguagesItemView> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          setState(() {
            widget.languageModel!.isSelected = true;

            /// Update the isSelected property of each item
            for (var item in widget.languageList!) {
              if (item != widget.languageModel) {
                item.isSelected = false;
              } else if (item == widget.languageModel) {
                widget.updateList!.call(widget.languageModel);
              }
            }
          });
        });
      },
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: ShapeDecoration(
          color: widget.languageModel!.isSelected!
              ? AppTheme.cT!.greenColor
              : AppTheme.cT!.whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32.w),
          ),
          shadows: widget.languageModel!.isSelected!
              ? [
                  const BoxShadow(
                    color: Color(0x3F9BB068),
                    blurRadius: 0,
                    offset: Offset(0, 0),
                    spreadRadius: 4,
                  )
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 48.w,
              height: 48.h,
              padding: EdgeInsets.all(12.w.h),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.languageModel!.isSelected!
                      ? AppTheme.cT!.whiteColor
                      : AppTheme.cT!.scaffoldLight),
              child: SvgPicture.asset(
                  widget.languageModel!.languageFlag ??
                      AssetsItems.flagOutLined,
                colorFilter: ColorFilter.mode(
                  widget.languageModel!.isSelected!
                      ? AppTheme.cT!.greenColor ?? Colors.transparent
                      : AppTheme.cT!.appColorLight ?? Colors.transparent,
                  BlendMode.srcIn,
                ),
              ),
            ),
            12.width,
            Expanded(
              child: CommonWidgets().makeDynamicText(
                  text: widget.languageModel!.languageName,
                  size: 16,
                  lines: 2,
                  weight: FontWeight.bold,
                  color: widget.languageModel!.isSelected!
                      ? AppTheme.cT!.whiteColor
                      : AppTheme.cT!.appColorLight),
            ),
            CommonWidgets().customRadioButton(widget.languageModel!.isSelected!)
          ],
        ),
      ),
    );
  }
}
