import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/configs/constants/assets.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/screens/questions/model/listed_questions_model.dart';

class InterestItemView extends StatelessWidget {
  final QuestionsModelList listedQuestionsModel;
  final bool isInterestSelected;
  final VoidCallback onInterestTap;

  const InterestItemView({
    required this.listedQuestionsModel,
    required this.isInterestSelected,
    required this.onInterestTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onInterestTap,
      child: Stack(
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.only(bottom: 10.h),
            decoration: ShapeDecoration(
              image: DecorationImage(
                  image: AssetImage(listedQuestionsModel.itemIcon!),
                fit: BoxFit.fill,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.w),
              ),
            ),
            child: CommonWidgets().makeDynamicText(
                text: listedQuestionsModel.questionText!,
                size: 18,
                weight: FontWeight.w600,
                align: TextAlign.center,
                color: AppTheme.cT!.appColorLight),
          ),
          isInterestSelected
              ? Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFF9BB168).withOpacity(0.7),
                    borderRadius: BorderRadius.circular(32.w),
                  ),
                  child: SvgPicture.asset(AssetsItems.tickCircle),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
