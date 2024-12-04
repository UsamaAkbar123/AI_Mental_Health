import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/configs/constants/constants.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/extensions.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/routes/routes.dart';
import 'package:freud_ai/screens/Widgets/animated_switch.dart';
import 'package:freud_ai/screens/sleep/bloc/sleep_bloc.dart';
import 'package:freud_ai/screens/sleep/bloc/sleep_event.dart';
import 'package:freud_ai/screens/sleep/bloc/sleep_state.dart';
import 'package:freud_ai/screens/sleep/model/schedule_sleep_model.dart';
import 'package:freud_ai/screens/sleep/model/sleep_model.dart';

class NewSleepSchedule extends StatefulWidget {
  const NewSleepSchedule({super.key});

  @override
  State<NewSleepSchedule> createState() => _NewSleepScheduleState();
}

class _NewSleepScheduleState extends State<NewSleepSchedule> {
  final List<ScheduleSleepModel> weekDaysList = [
    ScheduleSleepModel(dayName: "Mon", isSelected: false),
    ScheduleSleepModel(dayName: "TUE", isSelected: false),
    ScheduleSleepModel(dayName: "WED", isSelected: false),
    ScheduleSleepModel(dayName: "THU", isSelected: false),
    ScheduleSleepModel(dayName: "FRI", isSelected: false),
    ScheduleSleepModel(dayName: "SAT", isSelected: false),
    ScheduleSleepModel(dayName: "SUN", isSelected: false)
  ];

  bool autoSetAlarmValue = false;
  bool isRepeatEveryDay = false;

  String sleepAtTime = "10:00 PM";
  String wokeUpAtTime = "6:00 AM";

  SleepModel sleepModel = const SleepModel();

  List<String> listOfDays = [];

  @override
  void initState() {
    super.initState();
    setUpPreviouslyAddedData();
  }

  ///Set up previously added data
  setUpPreviouslyAddedData() {
    SleepState sleepState = context.read<SleepBloc>().state;

    if (sleepState.sleepSchedule!.sleepAt != null) {
      sleepAtTime = sleepState.sleepSchedule!.sleepAt!;
      wokeUpAtTime = sleepState.sleepSchedule!.wokeUpAt!;
      listOfDays = sleepState.sleepSchedule!.selectedDaysList!;
      autoSetAlarmValue = sleepState.sleepSchedule!.autoSetAlarm!;
      isRepeatEveryDay = sleepState.sleepSchedule!.isRepeatDaily!;

      for (int i = 0; i < weekDaysList.length; i++) {
        if (listOfDays.contains(weekDaysList[i].dayName)) {
          weekDaysList[i].isSelected = true;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 42),
              CommonWidgets().customAppBar(text: ""),
              20.height,
              CommonWidgets().makeDynamicText(
                  text: Constants.completeAppInfoModel!.isSleepQualityAdded!
                      ? "Update Sleep Schedule"
                      : "New Sleep Schedule",
                  size: 32,
                  align: TextAlign.center,
                  weight: FontWeight.w800,
                  color: AppTheme.cT!.appColorLight),
              30.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                      child: scheduleButton(
                          heading: "Sleep At", text: sleepAtTime)),
                  30.width,
                  Expanded(
                      child: scheduleButton(
                          heading: "Woke Up At", text: wokeUpAtTime)),
                ],
              ),
              30.height,
              scheduleButton(heading: "Grace Sleep Period", text: "20 Minutes"),
              30.height,
              setUpDays(),
              20.height,
              autoSetAlarm(),
              40.height,
              CommonWidgets().customButton(
                  buttonColor: AppTheme.cT!.orangeColor,
                  text: Constants.completeAppInfoModel!.isSleepQualityAdded!
                      ? "Update Sleep Schedule"
                      : "Set Sleep Schedule",
                  showIcon: true,
                  callBack: () => setSleepSchedule(),
                  icon: "assets/common/plus_ic.svg")
            ],
          ),
        ),
      ),
    );
  }

  ///Make BMI Button
  Widget scheduleButton({heading, text}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CommonWidgets().makeDynamicText(
            size: 16,
            weight: FontWeight.w600,
            text: heading,
            color: AppTheme.cT!.appColorLight),
        10.height,
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
          decoration: BoxDecoration(
              color: AppTheme.cT!.whiteColor,
              borderRadius: BorderRadius.circular(30.w)),
          child: Row(
            children: [
              SvgPicture.asset("assets/bmi/arrows.svg"),
              10.width,
              Expanded(
                child: CommonWidgets().makeDynamicText(
                    size: 16,
                    weight: FontWeight.w600,
                    text: text,
                    color: AppTheme.cT!.greyColor),
              ),
              10.width,
              heading == "Grace Sleep Period"
                  ? const SizedBox()
                  : SvgPicture.asset("assets/common/arrow_down.svg"),
            ],
          ),
        ),
      ],
    ).clickListener(click: () => _showTimePicker(heading));
  }

  ///Notification View
  Widget setUpDays({text, icon}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CommonWidgets().makeDynamicText(
                text: "Repeat EveryDay",
                size: 16,
                weight: FontWeight.w600,
                color: AppTheme.cT!.appColorLight),
            const Spacer(),
            AnimatedSwitch(
              isChecked: isRepeatEveryDay,
              callBack: (value) {
                isRepeatEveryDay = value;

                if (!mounted) return;
                setState(() {});
              },
            ),
          ],
        ),
        20.height,
        SizedBox(
          height: 70,
          child: ListView.builder(
              itemCount: weekDaysList.length,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return selectUnSelectDays(weekDaysList[index]);
              }),
        )
      ],
    );
  }

  ///Selected Unselected Days
  Widget selectUnSelectDays(ScheduleSleepModel model) {
    return GestureDetector(
      onTap: () {
        setState(() {
          model.isSelected = !model.isSelected!;

          if (model.isSelected!) {
            listOfDays.add(model.dayName!);
          } else {
            listOfDays.remove(model.dayName);
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 20, top: 10, bottom: 10),
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: ShapeDecoration(
          color: model.isSelected!
              ? AppTheme.cT!.greenColor
              : AppTheme.cT!.whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.w),
          ),
          shadows: model.isSelected!
              ? [
                  BoxShadow(
                    color: AppTheme.cT!.lightGreenColor!,
                    blurRadius: 0,
                    offset: const Offset(0, 0),
                    spreadRadius: 4.w,
                  )
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CommonWidgets().makeDynamicText(
                text: model.dayName,
                size: 16,
                weight: FontWeight.bold,
                color: model.isSelected!
                    ? AppTheme.cT!.whiteColor
                    : AppTheme.cT!.appColorLight),
            const SizedBox(width: 40),
            CommonWidgets().customRadioButton(model.isSelected!)
          ],
        ),
      ),
    );
  }

  ///Auto set Alarm
  Widget autoSetAlarm() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CommonWidgets().makeDynamicText(
            text: "Auto Set Alarm",
            size: 16,
            weight: FontWeight.w600,
            color: AppTheme.cT!.appColorLight),
        const Spacer(),
        AnimatedSwitch(
          isChecked: autoSetAlarmValue,
          callBack: (value) {
            autoSetAlarmValue = value;

            if (!mounted) return;
            setState(() => {});
          },
        ),
      ],
    );
  }

  ///Set Timer
  void _showTimePicker(String fromWhere) async {
    if (fromWhere != "Grace Sleep Period") {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        if (!mounted) return;

        if (fromWhere == "Sleep At") {
          sleepAtTime = pickedTime.format(context);
        } else {
          wokeUpAtTime = pickedTime.format(context);
        }

        if (!mounted) return;
        setState(() {});
      }
    }
  }

  ///Set Sleep Schedule Here
  setSleepSchedule() {
    if (listOfDays.isNotEmpty) {
      sleepModel = sleepModel.copyWith(
          sleepAt: sleepAtTime,
          wokeUpAt: wokeUpAtTime,
          graceSleepPeriod: "20 minutes",
          isRepeatDaily: isRepeatEveryDay,
          selectedDaysList: listOfDays,
          saveDateTime: DateTime.now().toString(),
          autoSetAlarm: autoSetAlarmValue);

      BlocProvider.of<SleepBloc>(context)
          .add(AddSleepEvent(sleepModel: sleepModel));

      CommonWidgets().showSnackBar(
          context,
          Constants.completeAppInfoModel!.isSleepQualityAdded!
              ? "Your schedule updated."
              : "Your schedule Created.");

      Navigate.pop();
    } else {
      CommonWidgets().showSnackBar(context, "Please select Day");
    }
  }
}
