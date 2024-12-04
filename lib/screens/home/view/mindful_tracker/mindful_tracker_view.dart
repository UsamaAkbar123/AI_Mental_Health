import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/routes/routes.dart';
import 'package:freud_ai/screens/routine/bloc/routine_bloc.dart';
import 'package:freud_ai/screens/routine/bloc/routine_state.dart';
import 'package:freud_ai/screens/routine/model/day_daily_routine_planner_model.dart';
import 'package:freud_ai/screens/routine/view/routine_planner_components/routine_planner_item_view.dart';
import 'package:freud_ai/screens/routine/routine_planner_page.dart';
import 'package:intl/intl.dart';

class MindfulTracker extends StatelessWidget {
  const MindfulTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          10.height,
          CommonWidgets().listViewAboveRow(
            context: context,
            text1: "Mindful Tracker",
            text2: "See All",
            callBack: () => Navigate.pushNamed(
              const RoutinePlannerPage(),
            ),
          ),
          BlocBuilder<RoutineBloc, RoutinePlannerState>(
            builder: (context, state) {
              if (state.status == RoutinePlannerStatus.loaded) {
                DayDailyRoutinePlannerModel? dayDailyRoutinePlannerModel;
                List<RoutineTaskModel> displayedRoutines = [];

                if (state.dailyRoutinePlannerList!.isNotEmpty) {
                  dayDailyRoutinePlannerModel =
                      state.dailyRoutinePlannerList?.firstWhere(
                    (element) =>
                        element.dayId ==
                        DateFormat('d MMMM y').format(DateTime.now()),
                    orElse: () => DayDailyRoutinePlannerModel(
                      dayId: "",
                      routineTaskModelList: [],
                    ),
                  );
                }

                displayedRoutines =
                    dayDailyRoutinePlannerModel?.routineTaskModelList ?? [];

                return ListView.builder(
                  itemCount: displayedRoutines.length > 3
                      ? 3
                      : displayedRoutines.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    RoutineTaskModel routineModel = displayedRoutines[index];
                    return RoutinePlannerItemView(
                      index: index + 1,
                      dayId: state.filterDailyRoutineByDate?.dayId ?? "",
                      routineTaskModel: routineModel,
                    );
                  },
                );
              } else {
                return Center(
                  child: Container(
                    height: 250.h,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(),
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }
}
