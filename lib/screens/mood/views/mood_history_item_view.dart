import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/screens/mood/model/mood_model.dart';
import 'package:intl/intl.dart';

class MoodHistoryItemView extends StatelessWidget {
  final MoodModel? moodModel;
  final bool? isFromMain;
  final VoidCallback onTap;

  const MoodHistoryItemView({
    super.key,
    this.moodModel,
    this.isFromMain,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.parse(moodModel!.moodDate!);
    String dayName = DateFormat('EEEE').format(date);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonWidgets().makeDynamicText(
              text: dayName,
              size: 16,
              weight: FontWeight.w800,
            color: AppTheme.cT!.greyColor,
          ),
          Container(
              margin: EdgeInsets.symmetric(
              horizontal: isFromMain! ? 0.w : 0,
              vertical: 5.h,
            ),
            padding: EdgeInsets.all(10.w),
            width: MediaQuery.sizeOf(context).width,
            decoration: ShapeDecoration(
                color: AppTheme.cT!.whiteColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22.w),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 5.h,
                  ),
                  alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppTheme.cT!.scaffoldLight,
                        borderRadius: BorderRadius.circular(12.w),
                      ),
                      child: CommonWidgets().makeDynamicTextSpan(
                          text1:
                              '${CommonWidgets().splitDateFormat(moodModel!.moodTimeStamp!)["month"]}\n',
                          text2:
                              '${CommonWidgets().splitDateFormat(moodModel!.moodTimeStamp!)["day"]}',
                          size1: 16,
                          size2: 16,
                          weight2: FontWeight.w500,
                          weight1: FontWeight.w500,
                          align: TextAlign.center,
                          color1: AppTheme.cT!.greyColor,
                    color2: AppTheme.cT!.appColorDark,
                  ),
                ),
                12.width,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CommonWidgets().makeDynamicText(
                                text: moodModel!.moodName,
                                size: 16,
                                weight: FontWeight.w600,
                            color: AppTheme.cT!.appColorLight,
                          ),
                          const Spacer(),
                          SizedBox(
                            width: 50.w,
                            height: 50,
                            child: SvgPicture.asset(moodModel!.moodEmoji!),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          20.height
        ],
      ),
    );
  }
}
