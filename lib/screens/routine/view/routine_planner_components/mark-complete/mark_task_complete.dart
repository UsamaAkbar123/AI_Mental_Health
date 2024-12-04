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
import 'package:freud_ai/screens/routine/view/routine_planner_components/add_task_components/create_new_task.dart';
import 'package:freud_ai/screens/routine/view/routine_planner_components/subtask_item_view.dart';
import 'package:intl/intl.dart';

class MarkTaskAsComplete extends StatefulWidget {
  final RoutineTaskModel? routineTaskModel;
  final String dayId;

  const MarkTaskAsComplete({
    super.key,
    this.routineTaskModel,
    required this.dayId,
  });

  @override
  State<MarkTaskAsComplete> createState() => _MarkTaskAsCompleteState();
}

class _MarkTaskAsCompleteState extends State<MarkTaskAsComplete> {
  late RoutineTaskModel routineTaskModel;

  @override
  void initState() {
    super.initState();

    routineTaskModel = widget.routineTaskModel!;
  }

  @override
  Widget build(BuildContext context) {
    return createNewTaskScreenBody();
  }

  ///Here We will define  the body of the screen
  Widget createNewTaskScreenBody() {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 50.h),
                child: CommonWidgets().customAppBar(
                  text: "Task Progress",
                  actionWidget: appBarCancelButton(),
                ),
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
              scheduleButton(
                  heading: "Date Schedule",
                  text: routineTaskModel.scheduleTotalDays,
                  isShowForwardIcon: false,
                  icon: "routine/clock.svg"),
              taskReminderView(routineTaskModel),
              scheduleButton(
                  heading: routineTaskModel.tagName,
                  text: "",
                  icon: "routine/no_tag.svg"),
              30.height,
              CommonWidgets().customButton(
                  text: !routineTaskModel.isTaskCompleted!
                      ? "Mark as Completed!"
                      : "Mark as InCompleted!",
                  callBack: () => markTaskAsCompleted())
            ],
          ),
        ),
      ),
    );
  }


  ///Task Reminder View
  Widget taskReminderView(RoutineTaskModel model) {
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

          ///Task and Reminder
          model.timeSpanForTask!.isEmpty
              ? taskReminderRow(
                  icon: AssetsItems.clockRoutine,
                  heading: "Time and Reminder",
                  text: "No")
              : const SizedBox(),

          ///Time
          model.timeSpanForTask!.isNotEmpty
              ? taskReminderRow(
                  icon: AssetsItems.clockRoutine,
                  heading: "Time",
                  text: model.timeSpanForTask!)
              : const SizedBox(),



          ///Reminder At
          model.timeSpanForTask!.isNotEmpty
              ? taskReminderRow(
                  icon: AssetsItems.alarm,
                  heading: "Reminder at",
                  text: model.reminderAt!)
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
              )),
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
    );
  }

  ///AppBar Cancel Button
  Widget appBarCancelButton() {
    return !routineTaskModel.isTaskCompleted!
        ? Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
            decoration: BoxDecoration(
              border:
                  Border.all(width: 1.w, color: AppTheme.cT!.appColorLight!),
              borderRadius: BorderRadius.circular(20.w),
            ),
            child: CommonWidgets().makeDynamicText(
              text: "Edit",
              size: 16,
              weight: FontWeight.w500,
              color: AppTheme.cT!.appColorLight,
            ),
          ).clickListener(click: () {
            Navigate.pushNamed(CreateNewRoutineTask(
                dayId: widget.dayId,
                routineTaskModel: routineTaskModel,
                fromWhere: Constants.fromEditScreen,
                    ),
                  ).then((value) {
                    if (value != null) {
                      routineTaskModel = value;
                      setState(() => {});
                    }
                  });
          })
        : const SizedBox();
  }

  ///Add Task Title
  Widget addTaskTitle() {
    return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: AppTheme.cT!.whiteColor,
            borderRadius: BorderRadius.circular(22.w)),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 12.w),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: AppTheme.cT!.whiteColor,
              borderRadius: BorderRadius.circular(22.w)),
          child: Row(
            children: [
              Container(
                width: 40.w,
                height: 40.h,
                padding: EdgeInsets.all(8.w.h),
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: AppTheme.cT!.scaffoldLight),
                child: SvgPicture.asset("assets/routine/file.svg",
                  colorFilter: ColorFilter.mode(
                    AppTheme.cT!.appColorLight ?? Colors.transparent,
                    BlendMode.srcIn,
                  ),
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
        ));
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
            itemCount: routineTaskModel.subTaskModelList!.length,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              SubTaskModel subTaskModel = routineTaskModel.subTaskModelList![index];
              return SubTaskItemView(subTaskModel: subTaskModel);
            },
          ),

          ///
          Row(
            children: [
              const Icon(
                Icons.add,
                color: Colors.transparent,
              ),
              5.width,
              Expanded(
                child: CommonWidgets().makeDynamicText(
                    size: 16,
                    weight: FontWeight.w700,
                    text: "Subtasks",
                    color: AppTheme.cT!.appColorLight),
              ),
              10.width,
            ],
          ),
        ],
      ),
    );
  }

  ///Make Schedule Button
  Widget scheduleButton({heading, String? text, icon, isShowForwardIcon}) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
      decoration: BoxDecoration(
          color: AppTheme.cT!.whiteColor,
          borderRadius: BorderRadius.circular(22.w)),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.h,
            padding: EdgeInsets.all(8.w.h),
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: AppTheme.cT!.scaffoldLight),
            child: SvgPicture.asset("assets/$icon",
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
    );
  }

  ///Create a new Task
  markTaskAsCompleted() async {
    DateTime modelDate = DateFormat("d MMMM y").parse(widget.dayId);

    /// 15 August 2024
    ///
    /// if the mark as completed routine task, is not today task
    /// and below to future date then task should not be mark as complete

    if (modelDate.isAfter(DateTime.now())) {
      CommonWidgets().showSnackBar(
        context,
        "Let`s focus on your today`s routine",
      );
    } else {
      routineTaskModel = routineTaskModel.copyWith(
        isTaskCompleted:
            routineTaskModel.isTaskCompleted == false ? true : false,
      );

      BlocProvider.of<RoutineBloc>(context).add(
        MarkAsCompleteOrUnCompleteTheRoutineTaskEvent(
          dayId: widget.dayId,
          routineTaskModel: routineTaskModel,
        ),
      );

      CommonWidgets().showSnackBar(
        context,
        routineTaskModel.isTaskCompleted == true
            ? "Task Mark as Completed"
            : "Task Mark as In Completed",
      );

      Navigate.pop();
    }
  }
}
