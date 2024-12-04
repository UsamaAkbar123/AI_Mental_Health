import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/configs/constants/assets.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/screens/Widgets/animated_column.dart';
import 'package:freud_ai/screens/Widgets/animated_switch.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: SingleChildScrollView(
          child: AnimatedColumnWrapper(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              50.height,
              CommonWidgets().customAppBar(text: "Notification Settings"),
              32.height,

              ///===================== Headings =================

              CommonWidgets().makeDynamicText(
                  text: "Chatbot",
                  size: 16,
                  weight: FontWeight.w800,
                  color: AppTheme.cT!.appColorLight),
              12.height,

              ///===================== Items =================

              notificationItemView(
                  text: "Push Notifications", icon: AssetsItems.notification),
              notificationItemView(
                  text: "Support Notification", icon: AssetsItems.chat),
              notificationItemView(
                  text: "Alert Notification",
                  icon: AssetsItems.alertNotification),
              notificationItemView(
                  text: "Sound",
                  subText:
                      "When Sound Notifications are on, your phone will always check for sounds."),
              notificationItemView(
                  text: "Vibration",
                  subText:
                      "When Vibration Notifications are on, your phone will vibrate."),

              ///===================== Headings =================
              32.height,
              CommonWidgets().makeDynamicText(
                  text: "MISC.",
                  size: 16,
                  weight: FontWeight.w800,
                  color: AppTheme.cT!.appColorLight),
              12.height,

              ///===================== Items =================
              ///
              notificationItemView(
                  text: "Offers",
                  isShowText: true,
                  trailText: "50% off",
                  icon: AssetsItems.cart),

              notificationItemView(
                  text: "App Updates", icon: AssetsItems.upArrow),

              notificationItemView(
                  text: "Resources",
                  subText:
                      "Browse our collection of resources to tailor your mental health."),
              50.height
            ],
          ),
        ),
      ),
    );
  }

  ///Notification Container
  Widget notificationItemView({text, subText, isShowText, trailText, icon}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: AppTheme.cT!.whiteColor,
          borderRadius: BorderRadius.circular(32.w)),
      child: Row(
        children: [
          icon != null
              ? Container(
                  width: 48.w,
                  height: 48.h,
                  padding: EdgeInsets.all(12.w.h),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.cT!.scaffoldLight),
                  child: SvgPicture.asset(icon),
                )
              : const SizedBox(),
          icon != null ? 12.width : 5.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonWidgets().makeDynamicText(
                    text: text,
                    size: 16,
                    weight: FontWeight.w700,
                    color: AppTheme.cT!.appColorLight),
                subText != null
                    ? CommonWidgets().makeDynamicText(
                        text: subText,
                        size: 14,
                        weight: FontWeight.w500,
                        color: AppTheme.cT!.greyColor)
                    : const SizedBox()
              ],
            ),
          ),
          80.width,
          isShowText != null
              ? Row(
                  children: [
                    CommonWidgets().makeDynamicText(
                        text: trailText,
                        size: 14,
                        weight: FontWeight.w600,
                        color: AppTheme.cT!.greyColor),
                    12.width,
                    SvgPicture.asset("assets/common/forward_icon.svg",
                      colorFilter: ColorFilter.mode(
                        AppTheme.cT!.appColorLight ?? Colors.transparent,
                        BlendMode.srcIn,
                      ),
                    ),
                  ],
                )
              : const AnimatedSwitch()
        ],
      ),
    );
  }
}
