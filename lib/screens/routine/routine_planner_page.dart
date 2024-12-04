import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freud_ai/configs/constants/constants.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/routes/routes.dart';
import 'package:freud_ai/screens/routine/bloc/routine_bloc.dart';
import 'package:freud_ai/screens/routine/bloc/routine_event.dart';
import 'package:freud_ai/screens/routine/bloc/routine_state.dart';
import 'package:freud_ai/screens/routine/model/day_daily_routine_planner_model.dart';
import 'package:freud_ai/screens/routine/view/routine_planner_components/add_task_components/create_new_task.dart';
import 'package:freud_ai/screens/routine/view/routine_planner_components/calender_view.dart';
import 'package:freud_ai/screens/routine/view/routine_planner_components/routine_planner_item_view.dart';
import 'package:intl/intl.dart';

class RoutinePlannerPage extends StatefulWidget {
  const RoutinePlannerPage({super.key});

  @override
  State<RoutinePlannerPage> createState() => _RoutinePlannerPageState();
}

/// just minor update

class _RoutinePlannerPageState extends State<RoutinePlannerPage> {
  List<RoutineTaskModel> displayedRoutines = [];
  List<RoutineTaskModel> filterRoutinesByTag = [];
  int selectedTagIndex = 0;
  List<String> tagList = [];
  String selectedTagName = "All";
  late RoutineBloc routineBloc;
  @override
  void initState() {
    routineBloc = context.read<RoutineBloc>();
    Constants.selectedTag = "All";
    routineBloc.add((GetSingleDailyRoutineTaskByDataEvent(
      filterDate: DateFormat('d MMMM y').format(DateTime.now()),
    )));
    super.initState();
  }

  filterRoutineByTag(String tag) {
    filterRoutinesByTag = [];
    if (tag != "All") {
      if (displayedRoutines.isNotEmpty) {
        for (RoutineTaskModel routineTaskModel in displayedRoutines) {
          if (routineTaskModel.tagName == tag) {
            filterRoutinesByTag.add(routineTaskModel);
          }
        }
      }
    }
  }

  /// the purpose of this filter is that i will reduce the iterations
  /// like i will return list
  /// Create a sublist starting from that index to the end of the original list.
  List<DayDailyRoutinePlannerModel> filterRoutinePlansStartingFromDayId({
    required List<DayDailyRoutinePlannerModel> routinePlans,
    required String selectedDayId,
  }) {
    // Find the index of the selected dayId
    int startIndex =
        routinePlans.indexWhere((plan) => plan.dayId == selectedDayId);

    // If the dayId is found, return the sublist starting from that index
    if (startIndex != -1) {
      return routinePlans.sublist(startIndex);
    }

    // If the dayId is not found, return an empty list
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: 330.h,
              bottom: 0,
              child: BlocBuilder<RoutineBloc, RoutinePlannerState>(
                  builder: (context, state) {
                if (state.status == RoutinePlannerStatus.loaded) {
                  /// this list is for routine task list

                  displayedRoutines =
                          state.filterDailyRoutineByDate
                              ?.routineTaskModelList ?? [];

                  /// this is for list of routine task tag
                  Set<String> uniqueTags = {"All"};
                  for (var task in displayedRoutines) {
                    uniqueTags.add(task.tagName ?? "");
                  }

                  tagList = uniqueTags.toList();

                  /// the purpose of this function call here is
                  /// because
                  /// when user change the date, the previously filter routine
                  /// tag list is showing in next date, which is not incorrect
                  filterRoutineByTag(selectedTagName);

                  /// this is because
                      /// if one date has the routine with name A
                      /// if other date routine have not the routine with
                      /// name A , so in this case 0 index will be selected,
                      /// its mean default All tag is selected
                      if (filterRoutinesByTag.isEmpty) {
                        selectedTagIndex = 0;
                      }

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          height: 50.h,
                          alignment: Alignment.centerLeft,
                          child: ListView.builder(
                              itemCount: displayedRoutines.isNotEmpty
                                  ? tagList.length
                                  : 0,
                              shrinkWrap: true,
                              padding: EdgeInsets.only(left: 16.w),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedTagIndex = index;
                                      selectedTagName = tagList[index];
                                    });
                                    filterRoutineByTag(selectedTagName);
                                  },
                                  child: Container(
                                    height: 33.h,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(
                                        right: 12.w, top: 5.h, bottom: 5.h),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.w),
                                    decoration: ShapeDecoration(
                                      color: selectedTagIndex == index
                                          ? AppTheme.cT!.greenColor
                                          : AppTheme.cT!.lightBrownColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.w),
                                      ),
                                      shadows: selectedTagIndex == index
                                          ? [
                                              BoxShadow(
                                                color: AppTheme
                                                    .cT!.lightGreenColor!,
                                                blurRadius: 0,
                                                offset: const Offset(0, 0),
                                                spreadRadius: 4.w,
                                              )
                                            ]
                                          : [],
                                    ),
                                    child: CommonWidgets().makeDynamicText(
                                      text: tagList[index],
                                      size: 16,
                                      weight: FontWeight.bold,
                                      color: selectedTagIndex == index
                                          ? AppTheme.cT!.whiteColor
                                          : AppTheme.cT!.appColorLight,
                                    ),
                                  ),
                                );
                              }),
                        ),
                        10.height,
                        displayedRoutines.isNotEmpty
                            ? ListView.builder(
                                itemCount: filterRoutinesByTag.isEmpty
                                    ? displayedRoutines.length
                                    : filterRoutinesByTag.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.symmetric(horizontal: 12.w),
                                itemBuilder: (context, index) {
                                  RoutineTaskModel routineModel =
                                      filterRoutinesByTag.isEmpty
                                          ? displayedRoutines[index]
                                          : filterRoutinesByTag[index];
                                  return Dismissible(
                                    key: Key(routineModel.taskId!),
                                    direction: DismissDirection.endToStart,
                                    dismissThresholds: const {
                                      DismissDirection.endToStart: 0.9,
                                    },
                                    background: Container(
                                      color: Colors.red,
                                      alignment: Alignment.centerRight,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.w),
                                      child: const Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                    ),
                                    confirmDismiss: (direction) async {
                                      return await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text("Confirm"),
                                            content: const Text("Are you sure you want to delete this item?"),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () => Navigator.of(context).pop(false),
                                                child: const Text("Cancel"),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  /// when user grant the permission to delete the routine
                                                  /// then
                                                  /// call the DeleteSpecificRoutineTaskEvent event, it will delete all the routine task
                                                  routineBloc.add(
                                                    DeleteSpecificRoutineTaskEvent(
                                                      commonId: routineModel
                                                          .taskRoutineCommonId!,
                                                      routinePlans:
                                                          filterRoutinePlansStartingFromDayId(
                                                        routinePlans: routineBloc
                                                                .state
                                                                .dailyRoutinePlannerList ??
                                                            [],
                                                        selectedDayId: state
                                                                .filterDailyRoutineByDate
                                                                ?.dayId ??
                                                            "",
                                                      ),
                                                      dayId: state
                                                              .filterDailyRoutineByDate
                                                              ?.dayId ??
                                                          "",
                                                    ),
                                                  );
                                                  Navigator.of(context)
                                                      .pop(true);
                                                },
                                                child: const Text("Delete"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: RoutinePlannerItemView(
                                      index: index + 1,
                                      dayId: state.filterDailyRoutineByDate
                                              ?.dayId ??
                                          "",
                                      routineTaskModel: routineModel,
                                    ),
                                  );
                                },
                              )
                            : const Center(
                                child: Text(
                                  "No Routines Found",
                                ),
                              ),
                      ],
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
            ),
            Container(
              width: MediaQuery.sizeOf(context).width,
              padding: EdgeInsets.only(bottom: 20.h),
              decoration: BoxDecoration(
                // color: AppTheme.cT!.brownColor,
                color: const Color(0xff4F3422),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.w),
                  bottomRight: Radius.circular(20.w),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 50.h,
                      left: 12.w,
                      right: 12.w,
                      bottom: 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CommonWidgets()
                            .backButton(borderColor: AppTheme.cT!.whiteColor),
                        // Container(
                        //   width: 48.w,
                        //   height: 48.h,
                        //   decoration: BoxDecoration(
                        //     shape: BoxShape.circle,
                        //     border: Border.all(width: 1.h.w,color: AppTheme.cT!.whiteColor!),
                        //     boxShadow: const [
                        //       BoxShadow(
                        //         color: Color(0x264B3425),
                        //         blurRadius: 32,
                        //         offset: Offset(0, 16),
                        //         spreadRadius: 0,
                        //       )
                        //     ],
                        //   ),
                        //   child: Icon(Icons.add, size: 32, color: AppTheme.cT!.whiteColor!),
                        // ).clickListener(click: ()=> Navigate.pushNamed(CreateNewRoutineTask(fromWhere: Constants.createNewRoutine))),
                      ],
                    ),
                  ),
                  const RoutineWeeklyCalenderView(),
                  20.height,
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigate.pushNamed(CreateNewRoutineTask(fromWhere: Constants.createNewRoutine));
        },
        shape: const CircleBorder(),
        child:  Icon(Icons.add, size: 32, color: AppTheme.cT!.whiteColor!),
      ),
    );
  }
}
