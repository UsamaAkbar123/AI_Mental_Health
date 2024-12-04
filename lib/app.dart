import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freud_ai/application/bloc/app_info_bloc.dart';
import 'package:freud_ai/provider/app_provider.dart';
import 'package:freud_ai/routes/routes.dart';
import 'package:freud_ai/screens/ai_therapy/bloc/conversation_bloc.dart';
import 'package:freud_ai/screens/bmi/bloc/bmi_bloc.dart';
import 'package:freud_ai/screens/bottom_navbar/provider.dart';
import 'package:freud_ai/screens/mood/bloc/mood_bloc.dart';
import 'package:freud_ai/screens/personal_information/bloc/personal_bloc.dart';
import 'package:freud_ai/screens/questions/bloc/questions_bloc.dart';
import 'package:freud_ai/screens/questions/bloc/questions_provider.dart';
import 'package:freud_ai/screens/routine/bloc/routine_bloc.dart';
import 'package:freud_ai/screens/splash/splash_screen.dart';
import 'package:freud_ai/screens/steps/bloc/steps_bloc.dart';
import 'package:provider/provider.dart';

import 'configs/theme/core_theme.dart' as theme;
import 'screens/sleep/bloc/sleep_bloc.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(

      providers: [
        BlocProvider<ConversationBloc>(create: (context) => ConversationBloc()),
        BlocProvider<StepsBloc>(create: (context) => StepsBloc()),
        BlocProvider<AppInfoBloc>(create: (context) => AppInfoBloc()),
        BlocProvider<QuestionBloc>(create: (context) => QuestionBloc()),
        BlocProvider<RoutineBloc>(create: (context) => RoutineBloc()),
        BlocProvider<BMIBloc>(create: (context) => BMIBloc()),
        BlocProvider<MoodBloc>(create: (context) => MoodBloc()),
        BlocProvider<SleepBloc>(create: (context) => SleepBloc()),
        BlocProvider<PersonalInformationBloc>(create: (context) => PersonalInformationBloc()),
      ],

      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppProvider()),
          ChangeNotifierProvider(create: (_) => QuestionsProvider()),
          ChangeNotifierProvider(create: (_) => BottomNavBarProvider()),
        ],
        child: Consumer<AppProvider>(
          builder: (context, value, _) => MyAppCoreWidget(
            provider: value,
          ),
        ),
      ),
    );
  }
}

class MyAppCoreWidget extends StatelessWidget {
  final AppProvider provider;

  const MyAppCoreWidget({super.key, required this.provider});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Mental Health',
      theme: theme.themeLight,
      darkTheme: theme.themeDark,
      navigatorKey: Navigate.navigatorKey,
      themeMode: provider.themeMode,
      home: const SplashScreen(),
    );
  }
}