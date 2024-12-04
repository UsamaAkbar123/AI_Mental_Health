import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/screens/questions/model/listed_questions_model.dart';

class SquaredQuestionView extends StatefulWidget {
  final bool? isMultipleAllow;
  final QuestionsModelList? listedQuestionsModel;
  final List<QuestionsModelList>? listOfAnswers;
  final Function? updateList;

  const SquaredQuestionView(
      {super.key,
      this.listedQuestionsModel,
      this.listOfAnswers,
      this.isMultipleAllow,
      this.updateList});

  @override
  State<SquaredQuestionView> createState() => _SquaredQuestionViewState();
}

class _SquaredQuestionViewState extends State<SquaredQuestionView> {

  @override
  Widget build(BuildContext context) {
    log("CheckMultipleSelection :: ${widget.isMultipleAllow}");

    return medicationTypeView();
  }

  ///Medication Type View
  Widget medicationTypeView() {
    return GestureDetector(
      onTap: () {
        setState(() {
          CommonWidgets().vibrate();
          if (!widget.isMultipleAllow!) {

            /// Update the isSelected property of each item
            for (var item in widget.listOfAnswers!) {
              if (item == widget.listedQuestionsModel) {


                item.isSelected = true;
                widget.updateList!.call(item.questionText);

                log("forLoop :: ${item.questionText}");
                log("forLoop :: ${item.isSelected}");
              } else {

                item.isSelected = false;
                log("forLoopelse :: ${item.questionText}");
                log("forLoopelse :: ${item.isSelected}");
              }
            }

          } else {
            widget.listedQuestionsModel!.isSelected = !widget.listedQuestionsModel!.isSelected!;
            widget.updateList!.call(widget.listedQuestionsModel!.questionText!);

          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: widget.listedQuestionsModel!.isSelected!
              ? AppTheme.cT!.greenColor
              : AppTheme.cT!.whiteColor,
          borderRadius: BorderRadius.circular(30.w),
          border: Border.all(color: Colors.transparent, width: 2),
          boxShadow: [
            const BoxShadow(
              color: Color(0x0C4B3425),
              blurRadius: 16,
              offset: Offset(0, 8),
              spreadRadius: 0,
            ),
            widget.listedQuestionsModel!.isSelected!
                ? const BoxShadow(
                    color: Color(0x3F9BB068),
                    blurRadius: 0,
                    offset: Offset(0, 0),
                    spreadRadius: 4,
                  )
                : const BoxShadow(color: Colors.transparent)
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///Replace icon later dynamically it will changed
                Padding(
                  padding: EdgeInsets.all(16.w.h),
                  child: CommonWidgets()
                      .customRadioButton(widget.listedQuestionsModel!.isSelected!)
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.all(16.w.h),
                  child: CommonWidgets().makeDynamicText(
                      text: widget.listedQuestionsModel!.questionText,
                      size: 14,
                      weight: FontWeight.bold,
                      color: widget.listedQuestionsModel!.isSelected!
                          ? AppTheme.cT!.whiteColor
                          : AppTheme.cT!.appColorLight),
                ),
              ],
            ),
            Positioned(
              bottom: -10,
              right: -25.w,
              child: Padding(
                padding: EdgeInsets.only(bottom: 5.h, left: 10.w),
                child: Opacity(
                  opacity: 0.04,
                  child: SvgPicture.asset(
                      widget.listedQuestionsModel!.itemIcon ?? "",
                      width: 100.w,
                      height: 100.h,
                      fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      !widget.listedQuestionsModel!.isSelected!
                          ? AppTheme.cT!.appColorLight ?? Colors.transparent
                          : AppTheme.cT!.whiteColor ?? Colors.transparent,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
