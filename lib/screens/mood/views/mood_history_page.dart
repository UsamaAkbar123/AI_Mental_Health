import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/routes/routes.dart';
import 'package:freud_ai/screens/mood/bloc/mood_bloc.dart';
import 'package:freud_ai/screens/mood/bloc/mood_state.dart';
import 'package:freud_ai/screens/mood/mood_stat/view/mood_detail.dart';
import 'package:freud_ai/screens/mood/views/mood_history_item_view.dart';

class MoodHistoryPage extends StatefulWidget {
  const MoodHistoryPage({super.key});

  @override
  State<MoodHistoryPage> createState() => _MoodHistoryPageState();

}

class _MoodHistoryPageState extends State<MoodHistoryPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            moodHistoryHeader(),
            12.height,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: CommonWidgets().makeDynamicText(
                  text: "All",
                  size: 22,
                  align: TextAlign.left,
                  weight: FontWeight.w700,
                  color: AppTheme.cT!.appColorLight),
            ),
            BlocBuilder<MoodBloc, MoodState>(builder: (context, state) {
              if (state.status == MoodStateStatus.loaded) {
                return ListView.builder(
                  itemCount: state.moodModelList!.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  itemBuilder: (context, index) {
                    return MoodHistoryItemView(
                        isFromMain: false,
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
            })
          ],
        ),
      ),
    );
  }

  ///Mood History Header
  Widget moodHistoryHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: ShapeDecoration(
        color: AppTheme.cT!.appColorLight!,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(40.w),
              bottomLeft: Radius.circular(40.w)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          40.height,
          CommonWidgets().customAppBar(
              borderColor: AppTheme.cT!.whiteColor),
          12.height,
          CommonWidgets().makeDynamicText(
              text: "My Mood",
              size: 28,
              align: TextAlign.left,
              weight: FontWeight.w700,
              color: AppTheme.cT!.whiteColor),
          12.height,
          Container(
            height: 42.h,
            alignment: Alignment.center,
            width: MediaQuery.sizeOf(context).width,
            decoration: BoxDecoration(
                color: AppTheme.cT!.whiteColor,
                borderRadius: BorderRadius.circular(32.w),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.cT!.appShadow!,
                    blurRadius: 0,
                    offset: const Offset(0, 0),
                    spreadRadius: 4.w,
                  )
                ]),
            child: CommonWidgets().makeDynamicText(
                text: "History",
                size: 22,
                align: TextAlign.left,
                weight: FontWeight.w700,
                color: AppTheme.cT!.appColorLight),
          ),
          12.height
        ],
      ),
    );
  }
}
