import 'dart:developer';

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
import 'package:freud_ai/screens/routine/bloc/routine_bloc.dart';
import 'package:freud_ai/screens/routine/bloc/routine_event.dart';
import 'package:freud_ai/screens/routine/model/day_daily_routine_planner_model.dart';
import 'package:freud_ai/screens/routine/view/routine_planner_components/add_task_components/alarm_reminder_notification.dart';
import 'package:freud_ai/screens/routine/view/routine_planner_components/add_task_components/select_date_range_page.dart';
import 'package:freud_ai/screens/routine/view/routine_planner_components/add_task_components/show_added_tags.dart';
import 'package:freud_ai/screens/routine/view/routine_planner_components/add_task_components/time_specified.dart';
import 'package:freud_ai/screens/routine/view/routine_planner_components/subtask_item_view.dart';
import 'package:intl/intl.dart';

class CreateNewRoutineTask extends StatefulWidget {
  final String? fromWhere;
  final String? dayId;
  final RoutineTaskModel? routineTaskModel;

  const CreateNewRoutineTask({
    super.key,
    this.routineTaskModel,
    this.dayId,
    this.fromWhere,
  });

  @override
  State<CreateNewRoutineTask> createState() => _CreateNewRoutineTaskState();
}

class _CreateNewRoutineTaskState extends State<CreateNewRoutineTask> {

  bool isTitleFieldShow = false;
  bool isShowTextField = false;

  FocusNode subTaskFocus = FocusNode();
  FocusNode taskTitleFocus = FocusNode();
  List<SubTaskModel> subTasksModelList = [];
  TextEditingController taskTitleEditingController = TextEditingController();
  TextEditingController subTaskEditingController = TextEditingController();

  /// new routine implementation
  late RoutineTaskModel routineTaskModel;
  late RoutineBloc routineBloc;

  /// already added routine planner task start and  end schedule dates
  late String startScheduleDate;
  late String endScheduleData;

  @override
  void initState() {
    super.initState();

    routineTaskModel = RoutineTaskModel().initial();
    startScheduleDate = routineTaskModel.scheduleStartDate ?? "";
    endScheduleData = routineTaskModel.scheduleStartDate ?? "";
    routineBloc = BlocProvider.of<RoutineBloc>(context, listen: false);
    updateTheCreateNewTask();
  }

  ///Update The Routine task if comes from Edit
  updateTheCreateNewTask() {
    if (widget.routineTaskModel != null) {
      routineTaskModel = widget.routineTaskModel!;
      subTasksModelList = routineTaskModel.subTaskModelList!;
      routineTaskModel = routineTaskModel.copyWith(taskId: widget.routineTaskModel!.taskId);
      taskTitleEditingController.text = widget.routineTaskModel!.taskName!;
      startScheduleDate = widget.routineTaskModel?.scheduleStartDate ?? "";
      endScheduleData = widget.routineTaskModel?.scheduleEndDate ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 50.h),
                child: CommonWidgets().customAppBar(text: "Create new task"),
              ),
              20.height,
              CommonWidgets().makeDynamicText(
                  size: 16,
                  weight: FontWeight.w700,
                  text: "Task Title",
                  color: AppTheme.cT!.appColorLight),
              10.height,
              addTaskTitle(),
              10.height,
              addSubTaskOfTheDailyPlan(),
              /// new routine implementation
              scheduleButton(
                heading: "Date Schedule",
                text: routineTaskModel.scheduleTotalDays,
                isShowForwardIcon: false,
                icon: "routine/clock.svg",
                callBack: () => Navigate.pushNamed(SelectDateRangePage(dates: (
                    // routineTaskModel.scheduleStartDate!,
                    // routineTaskModel.scheduleEndDate!
                    startScheduleDate,
                    endScheduleData,
                  ),
                  isFromMain: widget.fromWhere == Constants.fromEditScreen,
                  isEditMode: widget.routineTaskModel != null ? true : false,
                )).then((value) {
                  if(value != null){
                    if (value["startingDate"] != "" && value["endingDate"] != "") {
                      routineTaskModel = routineTaskModel.copyWith(
                          scheduleStartDate: value["startingDate"],
                          scheduleEndDate: value["endingDate"],
                          scheduleTotalDays:
                          "${CommonWidgets().getTheDateRangeDays(value)} days");

                      if (!mounted) return;
                      setState(() => {});
                    }
                  }

                }),
              ),
              taskReminderView(),
              scheduleButton(
                heading: routineTaskModel.tagName,
                text: "",
                icon: "routine/no_tag.svg",
                callBack: () => Navigate.pushNamed(ShowAddedTags(
                  selectedTag: routineTaskModel.tagName,
                )).then((value) {
                  routineTaskModel = routineTaskModel.copyWith(
                    tagName: value ?? routineTaskModel.tagName,
                  );

                  if (!mounted) return;
                  setState(() => {});
                }),
              ),
              30.height,
              CommonWidgets().customButton(
                  text: widget.routineTaskModel != null
                      ? "Save Changes!"
                      : "Create Task",
                  showIcon: widget.routineTaskModel != null ? null : false,
                  callBack: () => createNewTask(),
                  icon: "assets/common/plus_ic.svg"),
              // 10.height,
              // CommonWidgets().customButton(
              //     text: "Cancel All Notification",
              //     showIcon: widget.routineTaskModel != null ? null : false,
              //     callBack: () async {
              //
              //       await LocalRemainderNotification.cancelAll();
              //     },
              //     icon: "assets/common/plus_ic.svg"),
              // 10.height,
              // CommonWidgets().customButton(
              //     text: "Delete Table",
              //     showIcon: widget.routineTaskModel != null ? null : false,
              //     callBack: () async {
              //       Database database = await databaseHelper.database;
              //       try {
              //         await database.execute(
              //             'DROP TABLE IF EXISTS ${Constants.dailyRoutinePlannerTagsTableName}');
              //         log("Table ${Constants.dailyRoutinePlannerTagsTableName} deleted successfully.");
              //       } catch (e) {
              //         log("Error in deleting table ${Constants.dailyRoutinePlannerTagsTableName}: $e");
              //       }
              //     },
              //     icon: "assets/common/plus_ic.svg"),
            ],
          ),
        ),
      ),
    );
  }

  ///Add Task Title
  Widget addTaskTitle() {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: AppTheme.cT!.whiteColor,
          borderRadius: BorderRadius.circular(22.w)),
      child: Column(
        children: [
          ///TextField
          isTitleFieldShow
              ? SizedBox(
                  height: 56.h,
                  child: TextField(
                    focusNode: taskTitleFocus,
                    controller: taskTitleEditingController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 16.w, top: 14.h),
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        padding: EdgeInsets.only(top: 10.h),
                        alignment: Alignment.center,
                        onPressed: () {
                          if (taskTitleEditingController.text.isNotEmpty) {
                            routineTaskModel = routineTaskModel.copyWith(
                              taskName: taskTitleEditingController.text,
                            );

                            isTitleFieldShow = false;
                          } else {
                            isTitleFieldShow = false;
                          }

                          if (!mounted) return;
                          setState(() => {});
                        },
                        icon: const Icon(Icons.check_circle_outline),
                      ), // Replace with your desired icon
                    ),
                  ),
                )
              : const SizedBox(),

          ///
          !isTitleFieldShow
              ? Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 15.h, horizontal: 12.w),
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: AppTheme.cT!.whiteColor,
                      borderRadius: BorderRadius.circular(22.w)),
                  child: Row(
                    children: [
                      SvgPicture.asset("assets/routine/file.svg",
                        colorFilter: ColorFilter.mode(
                          AppTheme.cT!.appColorLight ?? Colors.transparent,
                          BlendMode.srcIn,
                        ),
                      ),
                      10.width,
                      CommonWidgets().makeDynamicText(
                          text: routineTaskModel.taskName,
                          size: 16,
                          weight: FontWeight.w700,
                          color: AppTheme.cT!.appColorLight),
                      const Spacer(),
                      Icon(Icons.add_circle_outline_outlined,
                          color: AppTheme.cT!.appColorLight!)
                    ],
                  ),
                ).clickListener(click: () {
                  isTitleFieldShow = true;
                  taskTitleFocus.requestFocus();
                  setState(() => {});
                })
              : const SizedBox(),
        ],
      ),
    );
  }

  ///Add Sub Tasks of the Daily plan
  Widget addSubTaskOfTheDailyPlan() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
      decoration: BoxDecoration(
          color: AppTheme.cT!.whiteColor,
          borderRadius: BorderRadius.circular(22.w)),
      child: Column(
        children: [
          ///SubTasks List
          ListView.builder(
            shrinkWrap: true,
            itemCount: subTasksModelList.length,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {

              return SubTaskItemView(

                  subTaskModel: subTasksModelList[index],

                  saveProgressFunction: (value) {

                    subTasksModelList[index] = subTasksModelList[index].copyWith(isCompleted: value);

                    setState(() => {});

                  },
                  voidCallback: (value) => updateTheSubTaskModel(value, index));

            },
          ),

          ///TextField
          isShowTextField
              ? Container(
                  height: 52.h,
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: TextField(
                    focusNode: subTaskFocus,
                    controller: subTaskEditingController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 12.w),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(width: 0.5.h),
                          borderRadius: BorderRadius.circular(12.w)),
                      suffixIcon: IconButton(
                        alignment: Alignment.center,
                        onPressed: () => addSubTaskItemToList(),
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.check_circle_outline),
                      ), // Replace with your desired icon
                    ),
                  ),
                )
              : const SizedBox(),

          Row(
            children: [
              const Icon(Icons.add),
              10.width,
              Expanded(
                child: CommonWidgets().makeDynamicText(
                    size: 16,
                    weight: FontWeight.w700,
                    text: "Add Subtask",
                    color: AppTheme.cT!.appColorLight),
              ),
              10.width,
            ],
          ).clickListener(click: () {
            isShowTextField = true;
            subTaskFocus.requestFocus();
            setState(() => {});
          }),
        ],
      ),
    );
  }

  ///SubTasks Model
  updateTheSubTaskModel(Map<String, dynamic> map, index) {

    // subTasksModelList[index] = subTasksModelList[index]
    //     .copyWith(reminderTime: map['selectedAlarmTime']);
    // subTasksModelList[index] = subTasksModelList[index]
    //     .copyWith(isNotifyReminder: map['isNotifyReminder']);
    //
    // setState(() => {});
  }

  ///Add SubTasks Item to List
  addSubTaskItemToList() {
    if (subTaskEditingController.text.isNotEmpty) {
      SubTaskModel subTaskModel = SubTaskModel(
          subTaskName: subTaskEditingController.text,
          isCompleted: false,
      );

      subTasksModelList.add(subTaskModel);

      routineTaskModel = routineTaskModel.copyWith(subTaskModelList: subTasksModelList);

      subTaskEditingController.clear();

      isShowTextField = false;
    } else {
      subTaskEditingController.clear();
      isShowTextField = false;
    }

    if (!mounted) return;
    setState(() => {});
  }

  ///Make Schedule Button
  Widget scheduleButton({
    heading,
    String? text,
    icon,
    callBack,
    isShowForwardIcon,
  }) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
      decoration: BoxDecoration(
          color: AppTheme.cT!.whiteColor,
          borderRadius: BorderRadius.circular(22.w)),
      child: Row(
        children: [
          SvgPicture.asset(
            "assets/$icon",
            colorFilter: ColorFilter.mode(
              AppTheme.cT!.appColorLight ?? Colors.transparent,
              BlendMode.srcIn,
            ),
          ),
          10.width,
          Expanded(
            child: CommonWidgets().makeDynamicText(
                size: 16,
                weight: FontWeight.w700,
                text: heading,
                color: AppTheme.cT!.appColorLight),
          ),
          text!.isNotEmpty
              ? CommonWidgets().makeDynamicText(
                  size: 16,
                  weight: FontWeight.w500,
                  text: text,
                  color: AppTheme.cT!.appColorLight)
              : const SizedBox(),
          isShowForwardIcon == null
              ? SvgPicture.asset("assets/common/forward_icon.svg",
                  colorFilter: ColorFilter.mode(
                    AppTheme.cT!.appColorLight ?? Colors.transparent,
                    BlendMode.srcIn,
                  ),
                )
              : const SizedBox(),
          10.width
        ],
      ),
    ).clickListener(click: () {
      if (callBack != null) {
        callBack();
      }
    });
  }

  ///Task Reminder Widget, here we will decide the task reminder
  Widget taskReminderView() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
      decoration: BoxDecoration(
        color: AppTheme.cT!.whiteColor,
        borderRadius: BorderRadius.circular(22.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          routineTaskModel.timeSpanForTask!.isEmpty
              ? taskReminderRow(
              icon: AssetsItems.clockRoutine,
                  heading: "Time and Reminder",
                  callback: () => Navigate.pushNamed(
                              TimeSpecifiedPage(routineTaskModel: routineTaskModel))
                          .then((value) {
                        if (value != null) {
                          routineTaskModel = routineTaskModel.copyWith(
                              timeSpanForTask: value['selectedDateString'],
                              isPointTimeSelected:
                              value['isPointTimeSelected']);
                        }

                        setState(() => {});
                      }),
                  text: "No")
              : const SizedBox(),
          routineTaskModel.timeSpanForTask!.isNotEmpty
              ? taskReminderRow(
              icon: AssetsItems.clockRoutine,
                  heading: "Time",
                  callback: () => Navigate.pushNamed(
                              TimeSpecifiedPage(routineTaskModel: routineTaskModel))
                          .then((value) {
                        if (value != null) {
                          routineTaskModel = routineTaskModel.copyWith(
                              timeSpanForTask: value['selectedDateString'],
                              isPointTimeSelected:
                              value['isPointTimeSelected']);
                          log(
                              "UserCurrentTimeSpan :: ${value['selectedDateString']}");
                        }

                        setState(() => {});
                      }),
                  text: routineTaskModel.timeSpanForTask!)
              : const SizedBox(),
          routineTaskModel.timeSpanForTask!.isNotEmpty
              ? taskReminderRow(
              icon: AssetsItems.alarm,
                  heading: "Reminder at",
                  callback: () => Navigate.pushNamed(TaskNotificationReminder(
                              reminderTime: routineTaskModel.reminderAt,
                          isReminderSet: routineTaskModel.isNotifyReminder,
                        ),
                      ).then((value) {
                        if (value != null) {
                          routineTaskModel = routineTaskModel.copyWith(
                              reminderAt: value['selectedAlarmTime'],
                              isNotifyReminder: value['isNotifyReminder']);
                        }

                        if (!mounted) return;
                        setState(() => {});
                      }),
                  text: routineTaskModel.reminderAt)
              : const SizedBox(),
        ],
      ),
    );
  }

  ///This Will be the View of Task Reminder  Rows
  Widget taskReminderRow({icon, heading, text, VoidCallback? callback}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        children: [
          SizedBox(
              width: 24.w,
              height: 24.h,
            child: SvgPicture.asset(
              icon,
              colorFilter: ColorFilter.mode(
                AppTheme.cT!.appColorLight ?? Colors.transparent,
                BlendMode.srcIn,
              ),
            ),
          ),
          10.width,
          Expanded(
            child: CommonWidgets().makeDynamicText(
                size: 16,
                weight: FontWeight.w700,
                text: heading,
                color: AppTheme.cT!.appColorLight),
          ),
          text!.isNotEmpty
              ? CommonWidgets().makeDynamicText(
                  size: 16,
                  weight: FontWeight.w500,
                  text: text,
                  color: AppTheme.cT!.appColorLight)
              : const SizedBox(),
        ],
      ),
    ).clickListener(click: callback);
  }

  ///Create a new Task
  createNewTask() async {
    if (widget.fromWhere == Constants.fromEditScreen) {
      routineBloc.add(
        UpdateOrDeleteRoutineTaskEvent(
          dayId: widget.dayId!,
          updateRoutineTaskModel: routineTaskModel,
        ),
      );

      CommonWidgets().showSnackBar(context, "Task Updated Successfully");
      Navigate.pop(routineTaskModel);

    } else {
      log("routine task model: ${routineTaskModel.toJson()}");

      DayDailyRoutinePlannerModel dailyRoutinePlannerModel =
          DayDailyRoutinePlannerModel(
        dayId: DateFormat('d MMMM y').format(DateTime.now()),
        routineTaskModelList: [routineTaskModel],
      );

      routineBloc.add(AddDailyRoutineTaskEvent(
        dailyRoutinePlannerModel: dailyRoutinePlannerModel,
      ));
      CommonWidgets().showSnackBar(context, "Task added in Routine Plan");
      Navigate.pop();
    }
  }
}
