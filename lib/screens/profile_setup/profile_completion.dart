import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/configs/database/database_helper.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/extensions.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/routes/routes.dart';
import 'package:freud_ai/screens/routine/bloc/routine_bloc.dart';
import 'package:freud_ai/screens/routine/bloc/routine_event.dart';
import 'package:freud_ai/screens/splash/splash_screen.dart';

class ProfileCompletion extends StatefulWidget {
  const ProfileCompletion({super.key});

  @override
  State<ProfileCompletion> createState() => _ProfileCompletionState();
}

class _ProfileCompletionState extends State<ProfileCompletion> {
  RoutineBloc? routineBloc;

  @override
  void initState() {
    super.initState();

    databaseHelper.printDataBase();

    BlocProvider.of<RoutineBloc>(context).add(RoutinePlannerCreatingAfterOnboardingEvent());

    compilingData();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          color: AppTheme.cT!.appColorDark,
          child: SvgPicture.asset("assets/splash/loading_screen_progress.svg"),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CommonWidgets().makeDynamicText(
                text: "Compiling Data...",
                size: 28,
                weight: FontWeight.bold,
                align: TextAlign.center,
                color: AppTheme.cT!.whiteColor),
            const SizedBox(height: 5),
            CommonWidgets().makeDynamicText(
                text:
                "Please wait... We’re calculating the\ndata based on your assessment.",
                size: 14,
                weight: FontWeight.normal,
                align: TextAlign.center,
                color: AppTheme.cT!.whiteColor),
          ],
        ).centralized()
      ],
    );
  }

  ///Splash Timer which change after every 3 seconds
  compilingData() {
    Timer.periodic(const Duration(seconds: 8), (timer) {
      timer.cancel();
      Navigate.pushAndRemoveUntil(const SplashScreen());
    });
  }

}
