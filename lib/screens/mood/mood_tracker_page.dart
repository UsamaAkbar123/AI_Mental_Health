import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/configs/constants/assets.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/extensions.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/routes/routes.dart';
import 'package:freud_ai/screens/Widgets/cliper.dart';
import 'package:freud_ai/screens/mood/bloc/mood_bloc.dart';
import 'package:freud_ai/screens/mood/bloc/mood_event.dart';
import 'package:freud_ai/screens/mood/bloc/mood_state.dart';
import 'package:freud_ai/screens/mood/mood_stat/mood_statistic_page.dart';
import 'package:freud_ai/screens/mood/mood_stat/view/mood_detail.dart';
import 'package:freud_ai/screens/mood/views/add_mood_page.dart';
import 'package:freud_ai/screens/mood/views/mood_history_item_view.dart';
import 'package:lottie/lottie.dart';

class MoodTrackerPage extends StatelessWidget {
  const MoodTrackerPage({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<MoodBloc>(context).add(GetMoodEvent());

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    ClipPath(
                      clipper: ClipperClass(),
                      child: SizedBox(
                        height: MediaQuery.sizeOf(context).height / 1.7.h,
                        width: MediaQuery.sizeOf(context).width,
                        child: Stack(
                          children: [
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width,
                              height: MediaQuery.sizeOf(context).height,
                              child: SvgPicture.asset(
                                "assets/mood/mood_bg.svg",
                                fit: BoxFit.cover,
                              ),
                            ),
                            BlocBuilder<MoodBloc, MoodState>(
                              builder: (context, state) {
                                return state.moodModelList!.isEmpty
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Lottie.asset(AssetsItems.emptyBMIJson)
                                              .centralized(),
                                          20.height,
                                          CommonWidgets().makeDynamicText(
                                              text: "Click Button to add",
                                              size: 22,
                                              weight: FontWeight.w700,
                                              color: AppTheme.cT!.appColorLight)
                                        ],
                                      )
                                    : CurrentMode(moodState: state);
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: CommonWidgets().ovalButton(
                        iconData: Icons.add,
                        callBack: () => Navigate.pushNamed(
                          const AddMoodPage(),
                        ),
                      ),
                    ),
                  ],
                ),
                const ScoreHistory(),
              ],
            ),
          ),

          /// Mental health mood app bar
          Padding(
            padding: EdgeInsets.only(
              top: 50.h,
              left: 12.w,
              right: 12.w,
            ),
            child: CommonWidgets().customAppBar(
              text: "Mood",
              borderColor: AppTheme.cT!.appColorLight,
            ),
          ),
        ],
      ),
    );
  }
}

class CurrentMode extends StatelessWidget {
  final MoodState moodState;

  const CurrentMode({
    super.key,
    required this.moodState,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: 0,
        top: 0,
        left: 0,
        right: 0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              moodState.moodModelList!.last.moodEmoji!,
              fit: BoxFit.cover,
              width: 160.w,
              height: 160.h,
            ),
            16.height,
            CommonWidgets().makeDynamicText(
              text: moodState.moodModelList!.last.moodName!,
              color: AppTheme.cT!.appColorLight,
              weight: FontWeight.w600,
              size: 30,
            )
          ],
        ).centralized());
  }
}

class ScoreHistory extends StatelessWidget {
  const ScoreHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        BlocBuilder<MoodBloc, MoodState>(
          builder: (context, state) {
            return state.moodModelList!.isNotEmpty
                ? CommonWidgets().listViewAboveRow(
                    context: context,
                    text1: "Mood Statistics",
                    text2: "See All",
                    callBack: () => Navigate.pushNamed(
                      const MoodStatisticPage(),
                    ),
                  )
                : const SizedBox();
          },
        ),

        ///Bloc Builder of Mood Model list
        BlocBuilder<MoodBloc, MoodState>(
          builder: (context, state) {
            if (state.status == MoodStateStatus.loaded) {
              return ListView.builder(
                itemCount: state.moodModelList!.length,
                shrinkWrap: true,
                reverse: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                itemBuilder: (context, index) {
                  return MoodHistoryItemView(
                    isFromMain: true,
                    moodModel: state.moodModelList![index],
                    onTap: () {
                      Navigate.pushNamed(
                        MoodDetailScreen(
                          moodModel: state.moodModelList![index],
                        ),
                      );
                    },
                  );
                },
              );
            } else {
              return const SizedBox();
            }
          },
        )
      ],
    );
  }
}
