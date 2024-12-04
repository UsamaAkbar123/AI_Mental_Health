import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/configs/constants/assets.dart';
import 'package:freud_ai/configs/database/shared_pref.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/routes/routes.dart';
import 'package:freud_ai/screens/mood/bloc/mood_bloc.dart';
import 'package:freud_ai/screens/mood/bloc/mood_state.dart';
import 'package:freud_ai/screens/personal_information/bloc/personal_bloc.dart';
import 'package:freud_ai/screens/personal_information/bloc/personal_state.dart';
import 'package:freud_ai/screens/personal_information/personal_information.dart';
import 'package:freud_ai/screens/testing/step_counter_goal_list.dart';

class HeaderText extends StatelessWidget {
  const HeaderText({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            BlocBuilder<PersonalInformationBloc, PersonalInformationState>(
                builder: (context, state) {
              return SizedBox(
                width: 60.w,
                height: 60.h,
                child: GestureDetector(
                  onTap: () {
                    Navigate.pushNamed(
                      const PersonalInformation(
                        showBackButton: true,
                      ),
                    );
                  },
                  child: SvgPicture.asset(
                    state.personalInformationModel?.selectedAvatar != ""
                        ? state.personalInformationModel?.selectedAvatar ??
                            AssetsItems.profileAvatar1
                        : AssetsItems.profileAvatar1,
                  ),
                ),
              );
            }),
            12.width,
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder<PersonalInformationBloc,
                      PersonalInformationState>(
                    builder: (context, state) {
                      return CommonWidgets().makeDynamicText(
                        text:
                            "Hi ${state.personalInformationModel!.name!.isNotEmpty ? state.personalInformationModel!.name : "Guest user"}",
                        size: 22,
                        weight: FontWeight.w800,
                        color: AppTheme.cT!.whiteColor,
                      );
                    },
                  ),
                  4.height,
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/home/pro.svg",
                        width: 16.w,
                        height: 16.h,
                      ),
                      4.width,
                      CommonWidgets().makeDynamicText(
                        text: "Pro Member",
                        size: 12,
                        weight: FontWeight.w700,
                        color: AppTheme.cT!.whiteColor,
                      ),
                      8.width,
                      Container(
                        height: 4.h,
                        width: 4.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.cT!.brownColor,
                        ),
                      ),
                      8.width,
                      SvgPicture.asset(
                        "assets/home/percentage.svg",
                        width: 16.w,
                        height: 16.h,
                      ),
                      4.width,
                      CommonWidgets().makeDynamicText(
                          text: sharedPreferencesManager.getMentalHealthScore,
                          size: 12,
                          weight: FontWeight.w700,
                          color: AppTheme.cT!.whiteColor),
                      8.width,
                      Container(
                        height: 4.h,
                        width: 4.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.cT!.brownColor,
                        ),
                      ),
                      8.width,
                      BlocBuilder<MoodBloc, MoodState>(
                          builder: (context, state) {
                        return state.moodModelList!.isNotEmpty
                            ? SvgPicture.asset(
                                state.moodModelList?.last.moodEmoji ?? "",
                                width: 16.w,
                                height: 16.h,
                              )
                            : SvgPicture.asset(
                                "assets/assessment/fair.svg",
                                width: 16.w,
                                height: 16.h,
                              );
                      }),
                      4.width,
                      BlocBuilder<MoodBloc, MoodState>(
                        builder: (context, state) {
                          return state.moodModelList!.isNotEmpty
                              ? CommonWidgets().makeDynamicText(
                                  text: getLastWord(
                                      state.moodModelList?.last.moodName ?? ""),
                                  size: 12,
                                  weight: FontWeight.w700,
                                  color: AppTheme.cT!.whiteColor,
                                )
                              : CommonWidgets().makeDynamicText(
                                  text: "neutral",
                                  size: 12,
                                  weight: FontWeight.w700,
                                  color: AppTheme.cT!.whiteColor,
                                );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            calenderAndNotification(context),
          ],
        )
      ],
    );
  }

  String getLastWord(String input) {
    List<String> words = input.split(' ');
    return words.isNotEmpty ? words.last : '';
  }

  ///Calender and notification
  Widget calenderAndNotification(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const StepCounterGoalListWidget()),
            );
            // Navigate.pushNamed(const NotificationsPage());
          },
          child: Container(
            height: 48.h,
            width: 48.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.cT!.brownColor!,
              ),
            ),
            alignment: Alignment.center,
            child: Stack(
              children: [
                SvgPicture.asset(
                  AssetsItems.notification,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
                Positioned(
                  right: 0,
                  child: Container(
                    height: 14.h,
                    width: 14.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.cT!.greenColor!,
                    ),
                    alignment: Alignment.center,
                    child: CommonWidgets().makeDynamicText(
                      text: "8",
                      size: 10,
                      weight: FontWeight.bold,
                      color: AppTheme.cT!.whiteColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
