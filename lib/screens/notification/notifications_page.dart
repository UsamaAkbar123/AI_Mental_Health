import 'package:flutter/material.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/screens/notification/model/notifications_model.dart';
import 'package:freud_ai/screens/notification/view/notification_item_view.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<NotificationsModel> notificationModelList = [
      NotificationsModel(
        title: "Message from Dr freud AI",
        notification: "52 total unread messages",
        prefixIcon: "bmi/calender.svg",
        prefixIconColor: AppTheme.cT!.greenColor,
        suffixIconColor: AppTheme.cT!.lightGreenColor,
      ),
      NotificationsModel(
        title: "To Do!",
        notification: "12 total tasks to do",
        prefixIcon: "routine/routine.svg",
        prefixIconColor: AppTheme.cT!.brownColor,
        suffixIconColor: AppTheme.cT!.lightBrownColor,
      ),
      NotificationsModel(
        title: "Sleep Quality",
        notification: "You slept for 8 hours today",
        prefixIcon: "routine/routine.svg",
        prefixIconColor: AppTheme.cT!.purpleColor,
        suffixIconColor: AppTheme.cT!.purpleShadow,
      ),
      NotificationsModel(
        title: "Goal Achieved!",
        notification: "your step count is 2342",
        prefixIcon: "routine/routine.svg",
        prefixIconColor: AppTheme.cT!.blueColor,
        suffixIconColor: AppTheme.cT!.blueColorLight,
      ),
      NotificationsModel(
        title: "Mood Improved",
        notification: "Your mood is neutral to happy",
        prefixIcon: "routine/routine.svg",
        prefixIconColor: AppTheme.cT!.yellowColor,
        suffixIconColor: AppTheme.cT!.lightYellowColor,
      )
    ];

    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            notificationsAppbar(),
            30.height,
            notificationsItemView(notificationModelList)
          ],
        ),
      ),
    );
  }

  ///Notifications AppBar
  Widget notificationsAppbar() {
    return Padding(
      padding: EdgeInsets.only(top: 50.h, left: 12.w, right: 12.w),
      child: CommonWidgets().customAppBar(
        text: "Notifications",
        actionWidget:
            Image.asset("assets/home/profile.png", width: 60.w, height: 60.h),
      ),
    );
  }

  ///Select Notifications ItemView
  Widget notificationsItemView(List<NotificationsModel> notificationModelList) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: notificationModelList.length,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      itemBuilder: (context, index) {
        return NotificationsItemView(
            notificationsModel: notificationModelList[index]);
      },
    );
  }
}
