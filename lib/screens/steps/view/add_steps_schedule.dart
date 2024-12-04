import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/application/bloc/app_info_bloc.dart';
import 'package:freud_ai/application/bloc/app_info_event.dart';
import 'package:freud_ai/configs/constants/constants.dart';
import 'package:freud_ai/configs/database/database_helper.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/screens/steps/bloc/steps_bloc.dart';
import 'package:freud_ai/screens/steps/bloc/steps_event.dart';
import 'package:freud_ai/screens/steps/bloc/steps_state.dart';
import 'package:freud_ai/screens/steps/data/step_counter_goal_data_resource.dart';
import 'package:freud_ai/screens/steps/model/step_counter_goal_model.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class AddStepsGoals extends StatefulWidget {
  const AddStepsGoals({super.key});

  @override
  State<AddStepsGoals> createState() => _AddStepsGoalsState();
}

class _AddStepsGoalsState extends State<AddStepsGoals> {
  final TextEditingController stepsEditingController = TextEditingController();

  final TextEditingController caloriesEditingController =
      TextEditingController();

  final TextEditingController distanceEditingController =
      TextEditingController();

  late final StepsBloc stepsBloc;

  StepCounterGoalModel? stepCounterGoalModel;

  final double stepLength = 0.8; // average step length in meters
  final double caloricBurnRate =
      0.04; // average caloric burn rate per step in kcal
  final double caloriesPerKm = 50.0; // average calories burned per km

  @override
  void initState() {
    super.initState();
    stepsBloc = context.read<StepsBloc>();
    stepsBloc.add(GetPedometerStepValueEvent());

    WidgetsBinding.instance.addPostFrameCallback((_) async{
      PermissionStatus status = await Permission.activityRecognition.request();

      if(mounted){
        if(status.isDenied){
          Navigator.pop(context);
        }
      }
    });



    setPreviouslyAddedData();
  }

  void _updateValues({String source = ''}) {
    setState(() {
      int steps = int.tryParse(stepsEditingController.text) ?? 0;
      double distance = double.tryParse(distanceEditingController.text) ?? 0.0;
      double calories = double.tryParse(caloriesEditingController.text) ?? 0.0;

      if (source == 'steps') {
        if (steps > 0) {
          distance = (steps * stepLength) / 1000;
          calories = distance * caloriesPerKm;
          distanceEditingController.text = distance.toStringAsFixed(2);
          caloriesEditingController.text = calories.toStringAsFixed(2);
        } else {
          distance = 0.0;
          calories = 0.0;
          distanceEditingController.clear();
          caloriesEditingController.clear();
        }

      } else if (source == 'distance') {
        if (distance > 0) {
          steps = (distance * 1000 / stepLength).round();
          calories = distance * caloriesPerKm;
          stepsEditingController.text = steps.toString();
          caloriesEditingController.text = calories.toStringAsFixed(2);
        } else {
          steps = 0;
          calories = 0.0;
          stepsEditingController.clear();
          caloriesEditingController.clear();
        }

      } else if (source == 'calories') {
        if (calories > 0) {
          distance = calories / caloriesPerKm;
          steps = (distance * 1000 / stepLength).round();
          stepsEditingController.text = steps.toString();
          distanceEditingController.text = distance.toStringAsFixed(2);
        } else {
          distance = 0.0;
          steps = 0;
          stepsEditingController.clear();
          distanceEditingController.clear();
        }

      }
    });
  }


  ///Set up Previously Added Data
  setPreviouslyAddedData() async {
    if (Constants.completeAppInfoModel!.isStepCounterGoalSet!) {
      stepsEditingController.text = stepsBloc.stepCounterGoalModelLastEntry!.goalStep.toString();
      caloriesEditingController.text =
          stepsBloc.stepCounterGoalModelLastEntry!.goalCalories.toString();
      distanceEditingController.text =
          stepsBloc.stepCounterGoalModelLastEntry!.goalDistance.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        body: BlocBuilder<StepsBloc, StepsState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 42),
              CommonWidgets().customAppBar(text: ""),
              20.height,
              CommonWidgets().makeDynamicText(
                  text: "Set Goals",
                  size: 32,
                  align: TextAlign.center,
                  weight: FontWeight.w800,
                  color: AppTheme.cT!.appColorLight),
              30.height,
              scheduleButton(
                  heading: "Steps",
                  text: "6000",
                  icon: "steps.svg",
                  context: context,
                  textEditingController: stepsEditingController,
                  onChanged: (value) {
                    _updateValues(source: "steps");
                      },
                      inputFormatters: [
                        NumericTextInputFormatter(maxLimit: 50000),
                      ]),
                  scheduleButton(
                      heading: "Calories",
                      text: "2000 Cal",
                      icon: "calory_ic.svg",
                  context: context,
                  textEditingController: caloriesEditingController,
                      inputFormatters: [
                        DecimalTextInputFormatter(maxLimit: 2000.00),
                      ],
                      onChanged: (value) {
                        _updateValues(source: "calories");
                  }),
              scheduleButton(
                  heading: "Distance",
                  text: "4 KM",
                  icon: "distance.svg",
                  context: context,
                  textEditingController: distanceEditingController,
                      inputFormatters: [
                        DecimalTextInputFormatter(maxLimit: 40.00),
                      ],
                      onChanged: (value) {
                        _updateValues(source: "distance");
                  }),
              const Spacer(),
              CommonWidgets().customButton(
                  text: "Set Goals",
                  showIcon: true,
                  callBack: addStepsGoalsButtonClick,
                  icon: "assets/steps/tick.svg"),
              30.height,
            ],
          ),
        );
      },
    ));
  }




  ///AddSteps Goals Button Function
  addStepsGoalsButtonClick() async {
    final database = await databaseHelper.database;

    PermissionStatus status = await Permission.activityRecognition.request();

    if (status == PermissionStatus.granted) {
      log("pedometer step value: ${stepsBloc.pedometerStep}");

      /// first check either step goal today entry added or not
      bool isAlreadyTodayStepGoalEntryExist =
          await StepCounterGoalDataResource(database).isTodayStepGoalEntryExist(
              DateFormat('MM/dd/yyyy').format(DateTime.now()));

      if (!isAlreadyTodayStepGoalEntryExist) {
        stepCounterGoalModel = StepCounterGoalModel(
          todayDateId: DateFormat('MM/dd/yyyy').format(DateTime.now()),
          goalStep: int.parse(stepsEditingController.text.trim().toString()),
          goalCalories:
          double.parse(caloriesEditingController.text.trim().toString()),
          goalDistance:
          double.parse(distanceEditingController.text.trim().toString()),
          dayStartStepValue:
          stepsBloc.pedometerStep > 0 ? stepsBloc.pedometerStep : 0,
          dayEndStepValue: 0,
          dayTotalSteps: 0,
          timeStamp: DateFormat('MMM dd').format(DateTime.now()),
        );

        Constants.completeAppInfoModel =
            Constants.completeAppInfoModel!.copyWith(isStepCounterGoalSet: true);

        if (!mounted) return;
        context
            .read<AppInfoBloc>()
            .add(UpdateAppInfoEvent(Constants.completeAppInfoModel!));
      } else {
        log("already added day start pedometer value: ${stepsBloc.stepCounterGoalModelLastEntry!.dayStartStepValue}");
        stepCounterGoalModel = StepCounterGoalModel(
          todayDateId: stepsBloc.stepCounterGoalModelLastEntry!.todayDateId,
          goalStep: int.parse(stepsEditingController.text.trim().toString()),
          goalCalories:
              double.parse(caloriesEditingController.text.trim().toString()),
          goalDistance:
              double.parse(distanceEditingController.text.trim().toString()),
          dayStartStepValue: stepsBloc.stepCounterGoalModelLastEntry!.dayStartStepValue,
          dayEndStepValue: 0,
          dayTotalSteps: 0,
          timeStamp: stepsBloc.stepCounterGoalModelLastEntry!.timeStamp,
        );
      }

      log("step counter goal model: $stepCounterGoalModel");

      if (!mounted) return;
      BlocProvider.of<StepsBloc>(context).add(StepCounterGoalAddOrUpdateEvent(
          stepCounterGoalModel: stepCounterGoalModel));

      if (!mounted) return;
      CommonWidgets().showSnackBar(context, "Goal Added Successfully");

      Navigator.pop(context);
    } else {
      if (!mounted) return;
      CommonWidgets().showSnackBar(context, "Permission Denied");
    }
  }


  ///Make BMI Button
  Widget scheduleButton(
      {heading,
      text,
      icon,
      textEditingController,
      context,
      required Function(String) onChanged,
      List<TextInputFormatter>? inputFormatters}) {
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
          height: 66.h,
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
          decoration: BoxDecoration(
              color: AppTheme.cT!.whiteColor,
            borderRadius: BorderRadius.circular(30.w),
          ),
          child: Row(
            children: [
              SvgPicture.asset("assets/steps/$icon",
                colorFilter: ColorFilter.mode(
                  AppTheme.cT!.appColorLight ?? Colors.transparent,
                  BlendMode.srcIn,
                ),
              ),
              10.width,
              Expanded(
                child: TextField(
                  maxLines: 1,
                  keyboardType: TextInputType.number,
                  controller: textEditingController,
                  inputFormatters: inputFormatters,
                  // inputFormatters: [
                  //   // FilteringTextInputFormatter.digitsOnly,
                  //   // NumericTextInputFormatter(),
                  // ],
                  onChanged: (value) {
                    onChanged(value);
                  },
                  onSubmitted: (value) {
                    CommonWidgets().hideSoftInputKeyboard(context);
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: text,
                    hintStyle: TextStyle(
                        color: AppTheme.cT!.lightGrey,
                        fontWeight: FontWeight.normal),
                    contentPadding: EdgeInsets.only(bottom: 12.h),
                  ),
                ),
              ),
              10.width,
            ],
          ),
        ),
        15.height
      ],
    );
  }
}


class NumericTextInputFormatter extends TextInputFormatter {
  final int maxLimit;

  NumericTextInputFormatter({required this.maxLimit});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue,
      TextEditingValue newValue) {
    // Remove any spaces from the input
    String newText = newValue.text.replaceAll(' ', '');

    // Allow empty value
    if (newText.isEmpty) {
      return newValue.copyWith(
          text: newText, selection: const TextSelection.collapsed(offset: 0));
    }

    // Use a regular expression to allow only digits
    final regExp = RegExp(r'^[0-9]*$');
    if (regExp.hasMatch(newText)) {
      int? value = int.tryParse(newText);
      if (value != null && value <= maxLimit) {
        int cursorPosition = newText.length;
        return newValue.copyWith(
          text: newText,
          selection: TextSelection.collapsed(offset: cursorPosition),
        );
      }
    }

    // If the input doesn't match the pattern or exceeds the limit, return the old value
    return oldValue;
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  final double maxLimit;

  DecimalTextInputFormatter({required this.maxLimit});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue,
      TextEditingValue newValue) {
    // Remove any spaces from the input
    String newText = newValue.text.replaceAll(' ', '');

    // Allow empty value
    if (newText.isEmpty) {
      return newValue.copyWith(
        text: newText,
        selection: const TextSelection.collapsed(offset: 0),
      );
    }

    // Use a regular expression to allow digits and one decimal point
    final regExp = RegExp(r'^\d*\.?\d{0,2}');
    if (regExp.hasMatch(newText)) {
      double? value = double.tryParse(newText);
      if (value != null && value <= maxLimit) {
        int cursorPosition = newText.length;
        return newValue.copyWith(
          text: newText,
          selection: TextSelection.collapsed(offset: cursorPosition),
        );
      }
    }

    // If the input doesn't match the pattern or exceeds the limit, return the old value
    return oldValue;
  }
}

// class NumericTextInputFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(
//       TextEditingValue oldValue,
//       TextEditingValue newValue,
//       ) {
//     // Use a regular expression to allow only digits
//     final regExp = RegExp(r'^[0-9]*$');
//     if (regExp.hasMatch(newValue.text)) {
//       return newValue;
//     }
//     // If the input doesn't match the pattern, return the old value
//     return oldValue;
//   }
// }
