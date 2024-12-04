import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/screens/questions/model/listed_questions_model.dart';

class QuestionItemView extends StatefulWidget {
  final bool? isMultipleAllow;
  final QuestionsModelList? listedQuestionsModel;
  final List<QuestionsModelList>? listOfAnswers;
  final Function? updateList;

  const QuestionItemView(
      {super.key,
      this.listedQuestionsModel,
      this.listOfAnswers,
      this.isMultipleAllow,
      this.updateList});

  @override
  State<QuestionItemView> createState() => _QuestionItemViewState();
}

class _QuestionItemViewState extends State<QuestionItemView> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          CommonWidgets().vibrate();
          widget.listedQuestionsModel!.isSelected =
              !widget.listedQuestionsModel!.isSelected!;

          if (!widget.isMultipleAllow!) {
            /// Update the isSelected property of each item
            for (var item in widget.listOfAnswers!) {
              if (item != widget.listedQuestionsModel) {
                item.isSelected = false;
              } else if (item == widget.listedQuestionsModel) {
                widget.updateList!.call(item.questionText);
              }
            }
          } else {
            widget.updateList!.call(widget.listedQuestionsModel!.questionText!);
          }
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: ShapeDecoration(
              color: widget.listedQuestionsModel!.isSelected!
                  ? AppTheme.cT!.greenColor
                  : AppTheme.cT!.whiteColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.w),
              ),
              shadows: widget.listedQuestionsModel!.isSelected!
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
                widget.listedQuestionsModel!.itemIcon != null
                    ? SvgPicture.asset(widget.listedQuestionsModel!.itemIcon!,
                        width: 24.w,
                        height: 24.h,
                        colorFilter: ColorFilter.mode(
                          widget.listedQuestionsModel!.isSelected!
                              ? AppTheme.cT!.whiteColor ?? Colors.transparent
                              : AppTheme.cT!.lightGrey ?? Colors.transparent,
                          BlendMode.srcIn,
                        ),
                      )
                    : const SizedBox(),
                10.width,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonWidgets().makeDynamicText(
                          text: widget.listedQuestionsModel!.questionText,
                          size: 16,
                          lines: 2,
                          weight: FontWeight.w600,
                          color: widget.listedQuestionsModel!.isSelected!
                              ? AppTheme.cT!.whiteColor
                              : AppTheme.cT!.appColorLight),
                      widget.listedQuestionsModel!.questionSubText != null
                          ? CommonWidgets().makeDynamicText(
                              text:
                                  widget.listedQuestionsModel!.questionSubText,
                              size: 14,
                              lines: 2,
                              weight: FontWeight.w400,
                              color: widget.listedQuestionsModel!.isSelected!
                                  ? AppTheme.cT!.whiteColor
                                  : AppTheme.cT!.appColorLight)
                          : const SizedBox(),
                    ],
                  ),
                ),
                10.width,
                CommonWidgets()
                    .customRadioButton(widget.listedQuestionsModel!.isSelected!)
              ],
            ),
          ),
          widget.listedQuestionsModel!.isSelected! &&
                  widget.listedQuestionsModel!.itemSubText != null
              ? Padding(
                  padding: EdgeInsets.only(left: 12.w, right: 12.w, top: 10.h),
                  child: CommonWidgets().makeDynamicText(
                      text: widget.listedQuestionsModel!.itemSubText,
                      size: 16,
                      lines: 2,
                      weight: FontWeight.bold,
                      color: AppTheme.cT!.orangeDark))
              : const SizedBox(),
        ],
      ),
    );
  }
}
