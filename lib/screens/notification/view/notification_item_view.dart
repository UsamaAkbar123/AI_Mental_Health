import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/routes/routes.dart';
import 'package:freud_ai/screens/notification/model/notifications_model.dart';
import 'package:freud_ai/screens/notification/notification_detail_page.dart';

class NotificationsItemView extends StatelessWidget {
  final NotificationsModel? notificationsModel;

  const NotificationsItemView({super.key, this.notificationsModel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigate.pushNamed(const NotificationsDetailPage());
      },
      child: Padding(
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
                    color: notificationsModel!.prefixIconColor,
                    shape: BoxShape.circle),
                child: SvgPicture.asset(
                    "assets/${notificationsModel!.prefixIcon}",
                  colorFilter: ColorFilter.mode(
                    AppTheme.cT!.whiteColor ?? Colors.transparent,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              12.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonWidgets().makeDynamicText(
                      text: notificationsModel!.title,
                      size: 20,
                      weight: FontWeight.w700,
                      color: AppTheme.cT!.appColorLight),
                  const SizedBox(height: 8),
                  CommonWidgets().makeDynamicText(
                      text: notificationsModel!.notification,
                      size: 16,
                      weight: FontWeight.w500,
                      color: AppTheme.cT!.greyColor),
                ],
              ),
              const Spacer(),
              Container(
                width: 50.w,
                height: 50.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: notificationsModel!.suffixIconColor,
                    shape: BoxShape.circle),
                child: SvgPicture.asset("assets/common/tick.svg",
                  colorFilter: ColorFilter.mode(
                    AppTheme.cT!.whiteColor ?? Colors.transparent,
                    BlendMode.srcIn,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
