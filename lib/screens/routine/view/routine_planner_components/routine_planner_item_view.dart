import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/configs/constants/assets.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/extensions.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/routes/routes.dart';
import 'package:freud_ai/screens/routine/model/day_daily_routine_planner_model.dart';
import 'package:freud_ai/screens/routine/view/routine_planner_components/mark-complete/mark_task_complete.dart';

class RoutinePlannerItemView extends StatelessWidget {
  final int? index;
  final RoutineTaskModel? routineTaskModel;
  final String dayId;

  const RoutinePlannerItemView({
    super.key,
    this.index,
    this.routineTaskModel,
    required this.dayId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Container(
          padding: EdgeInsets.all(16.w),
          clipBehavior: Clip.antiAlias,
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
                width: 50.w,
                height: 50.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: CommonWidgets().returnRandomColor(),
                    shape: BoxShape.circle),
                child: CommonWidgets().makeDynamicText(
                    text: index.toString(),
                    size: 16,
                    weight: FontWeight.w700,
                    color: AppTheme.cT!.appColorLight),
              ),
              12.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonWidgets().makeDynamicText(
                        text: routineTaskModel!.taskName,
                        size: 18,
                        weight: FontWeight.w700,
                        color: AppTheme.cT!.appColorLight),
                    const SizedBox(height: 8),
                    CommonWidgets().makeDynamicText(
                        // text: routineModel!.subTaskModelList!.isNotEmpty
                        //     ? routineModel!.subTaskModelList![0].subTaskName
                        //     : "",
                      text: routineTaskModel?.timeSpanForTask ?? "All Day",
                        size: 16,
                        lines: 2,
                        weight: FontWeight.w500,
                        color: AppTheme.cT!.greyColor),
                  ],
                ),
              ),
              SvgPicture.asset(AssetsItems.checkMark,
                  colorFilter: ColorFilter.mode(
                    routineTaskModel!.isTaskCompleted!
                        ? AppTheme.cT!.greenColor ?? Colors.transparent
                        : AppTheme.cT!.lightBrownColor ?? Colors.transparent,
                    BlendMode.srcIn,
                  ),
                  width: 32.w,
                  height: 32.h)
            ],
          )),
    ).clickListener(
        click: () => {
          Navigate.pushNamed(
            MarkTaskAsComplete(
              routineTaskModel: routineTaskModel,
              dayId: dayId,
            ),
          ),
        }
    );
  }
}
