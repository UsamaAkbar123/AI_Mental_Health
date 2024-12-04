import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freud_ai/application/bloc/app_info_bloc.dart';
import 'package:freud_ai/application/bloc/app_info_event.dart';
import 'package:freud_ai/application/bloc/app_info_state.dart';
import 'package:freud_ai/configs/constants/constants.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/extensions.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/routes/routes.dart';
import 'package:freud_ai/screens/bmi/bloc/bmi_bloc.dart';
import 'package:freud_ai/screens/bmi/bloc/bmi_event.dart';
import 'package:freud_ai/screens/main/main_screen.dart';
import 'package:freud_ai/screens/mood/bloc/mood_bloc.dart';
import 'package:freud_ai/screens/mood/bloc/mood_event.dart';
import 'package:freud_ai/screens/personal_information/bloc/personal_bloc.dart';
import 'package:freud_ai/screens/personal_information/bloc/personal_event.dart';
import 'package:freud_ai/screens/routine/bloc/routine_bloc.dart';
import 'package:freud_ai/screens/routine/bloc/routine_event.dart';
import 'package:freud_ai/screens/steps/bloc/steps_bloc.dart';
import 'package:freud_ai/screens/steps/bloc/steps_event.dart';
import 'package:freud_ai/screens/welcome/welcome_page.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int counter = 0;

  late StepsBloc stepsBloc;
  late RoutineBloc routineBloc;
  late MoodBloc moodBloc;

  @override
  void initState() {
    super.initState();

    stepsBloc = BlocProvider.of<StepsBloc>(context, listen: false);
    routineBloc = BlocProvider.of<RoutineBloc>(context, listen: false);
    moodBloc =  BlocProvider.of<MoodBloc>(context, listen: false);

    getLocalData();
    startCounter();
  }

  ///Get Local Data
  Future<void> getLocalData() async {

    context.read<AppInfoBloc>().add(GetAppInfoEvent());

    ///  Access the BloC state stream and wait for the first emitted state
    final appInfoState = await context.read<AppInfoBloc>().stream.first;


    ///  Now you can perform actions based on the state
    if (appInfoState is AppInfoLoadedState) {
      Constants.completeAppInfoModel = appInfoState.completeAppInfoModel;


      ///We will only call this if step counter is already created
      if (Constants.completeAppInfoModel!.isStepCounterGoalSet!) {
        if (!mounted) return;

        // get the list of step counter added goal list
        stepsBloc.add(GetStepCounterGoalHistoryEvent());

        // listen and get the pedometer step value
        stepsBloc.add(GetPedometerStepValueEvent());

        // get the today current step value
        stepsBloc.add(GetTodayCurrentStepValueEvent());
      }

      ///We will only call this if Routine plan is created
      if (Constants.completeAppInfoModel!.isRoutinePlannerCreated!) {
        if (!mounted) return;
        // get the list of routine task tags
        routineBloc.add(GetRoutinePlanTagEvent());

        // Dispatch the event to load all routine tasks
        routineBloc.add(GetDailyRoutineTaskListEvent());
      }




      ///We will only call this if BMI is Created
      if (Constants.completeAppInfoModel!.isBMISetupComplete!) {
        if (!mounted) return;
        context.read<BMIBloc>().add(GetBMIEvent());
      }

      ///This will only call when personal information Set
      if (Constants.completeAppInfoModel!.isPersonalInformationSet!) {
        if (!mounted) return;
        context.read<PersonalInformationBloc>().add(PersonalInformationGetEvent());
      }

      ///This will only call when mood content is set up.
      if (Constants.completeAppInfoModel!.isMoodTrackerStarted!) {
        if (!mounted) return;
        moodBloc.add(GetMoodEvent());
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    App.init(context);
    Size.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SafeArea(
        child: Container(
          alignment: Alignment.center,
          height: 50.h,
          padding: EdgeInsets.only(left: 12.w, right: 12.w, bottom: 20.h),
          child: CommonWidgets().makeDynamicTextSpan(
              text1: counter.toString(),
              text2: "%",
              size1: 26,
              size2: 26,
              weight1: FontWeight.w800,
              weight2: FontWeight.w800,
              color1: AppTheme.cT!.appColorLight,
              color2: AppTheme.cT!.brownColor),
        ),
      ),
      body: SizedBox(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset("assets/common/splash1.json",
                    width: 120.w, height: 120)
                .centralized(),
            CommonWidgets().makeDynamicText(
                text: "Mental Health",
                color: AppTheme.cT!.appColorLight,
                weight: FontWeight.w800,
                size: 42),
          ],
        ),
      ),
    );
  }



  ///Counter from 1 to 100
  void startCounter() {
    const duration = Duration(milliseconds: 16); /// Adjust speed as needed

    Timer.periodic(duration, (Timer timer) {
      setState(() {
        counter++;
        if (counter == 100) {
          timer.cancel();

          if (Constants.completeAppInfoModel!.isRoutinePlannerCreated!) {
            Navigate.pushAndRemoveUntil(const MainScreen());
          } else {
            Navigate.pushAndRemoveUntil(const WelcomePage());
          }
        }
      });
    });
  }
}
