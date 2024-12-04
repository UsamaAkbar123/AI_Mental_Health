import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/configs/constants/assets.dart';
import 'package:freud_ai/configs/constants/constants.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/extensions.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/routes/routes.dart';
import 'package:freud_ai/screens/Widgets/cliper.dart';
import 'package:freud_ai/screens/sleep/bloc/sleep_bloc.dart';
import 'package:freud_ai/screens/sleep/bloc/sleep_event.dart';
import 'package:freud_ai/screens/sleep/bloc/sleep_state.dart';
import 'package:freud_ai/screens/sleep/statistics/sleep_statistics_page.dart';
import 'package:freud_ai/screens/sleep/statistics/views/new_sleep_schedule.dart';
import 'package:freud_ai/screens/sleep/view/sleep_item_view.dart';
import 'package:lottie/lottie.dart';

import 'view/sleep_shedule_view.dart';

class SleepPage extends StatefulWidget {
  const SleepPage({super.key});

  @override
  State<SleepPage> createState() => _SleepPageState();
}

class _SleepPageState extends State<SleepPage> {
  @override
  void initState() {
    super.initState();

    BlocProvider.of<SleepBloc>(context).add(GetSleepEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.cT!.whiteColor, body: sleepPageBody());
  }

  ///Mental Health Body
  Widget sleepPageBody() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
        child: BlocBuilder<SleepBloc, SleepState>(builder: (context, state) {
          return Column(
            children: [
              Stack(
                children: [
                  ClipPath(
                    clipper: ClipperClass(),
                    child: Container(
                      height: MediaQuery.sizeOf(context).height / 2.h,
                      width: MediaQuery.sizeOf(context).width,
                      color: AppTheme.cT!.brownColor,
                      child: Stack(
                        children: [
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width,
                            height: MediaQuery.sizeOf(context).height,
                            child: SvgPicture.asset("assets/sleep/sleep_bg.svg",
                                fit: BoxFit.fitWidth),
                          ),
                          state.sleepModelList!.isEmpty
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Lottie.asset(AssetsItems.emptyBMIJson)
                                        .centralized(),
                                    20.height,
                                    CommonWidgets().makeDynamicText(
                                        text: "Click Button to add",
                                        size: 22,
                                        weight: FontWeight.w700,
                                        color: AppTheme.cT!.whiteColor)
                                  ],
                                )
                              : sleepScoreAndStatus(state),
                        ],
                      ),
                    ),
                  ),
                  sleepHeader(),
                  Constants.completeAppInfoModel!.isSleepQualityAdded!
                      ? const SizedBox()
                      : Positioned(
                          bottom: 0.h,
                          left: 0,
                          right: 0,
                          child: CommonWidgets().ovalButton(
                              iconData: Icons.add,
                              callBack: () =>
                                  Navigate.pushNamed(const NewSleepSchedule())),
                        ),
                ],
              ),
              scoreHistory(),
            ],
          );
        }));
  }

  ///Mental Health Score
  Widget sleepScoreAndStatus(SleepState state) {
    return state.sleepModelList!.isEmpty
        ? Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: CommonWidgets()
                .makeDynamicTextSpan(
              text1: '20.6\n',
              text2: "You're Insomaniac",
              size1: 82,
              size2: 22,
              weight2: FontWeight.w400,
              weight1: FontWeight.bold,
              align: TextAlign.center,
          color1: AppTheme.cT!.whiteColor,
          color2: AppTheme.cT!.whiteColor)
                .centralized(),
          )
        : const SizedBox();
  }

  ///AppBar
  Widget sleepHeader() {
    return Padding(
      padding: EdgeInsets.only(left: 12.w, right: 12.w, top: 50.h),
      child: CommonWidgets().customAppBar(
          borderColor: AppTheme.cT!.whiteColor!,
          text: "Sleep Quality"),
    );
  }

  ///This Widget will show the history of mental health
  Widget scoreHistory() {
    return BlocBuilder<SleepBloc, SleepState>(builder: (context, state) {
      return Column(
        children: [



          ///SleepSchedule View
          Constants.completeAppInfoModel!.isSleepQualityAdded!
              ? const SleepScheduleView(isFromStat: false)
              : const SizedBox(),




          ///ListView Above Row
          CommonWidgets().listViewAboveRow(
              context: context,
              text1: "Sleep Overview",
              text2: "See All",
              callBack: () => Navigate.pushNamed(const SleepStatistics())),



          ///ListView Builder
          ListView.builder(
            itemCount: 10,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return const SleepItemView(isFromStat: false);
            },
          ),



        ],
      );
    });
  }
}
