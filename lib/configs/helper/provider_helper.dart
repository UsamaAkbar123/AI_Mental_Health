import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freud_ai/provider/app_provider.dart';
import 'package:freud_ai/screens/questions/bloc/questions_bloc.dart';
import 'package:provider/provider.dart';

class ProviderHelper {
  static List<ChangeNotifierProvider> providers = [
    ChangeNotifierProvider(create: (_) => AppProvider()),
  ];
}




class BlocProviderHelper{

  static List<BlocProvider> providers = [
    BlocProvider<QuestionBloc>(create: (context) => QuestionBloc()),
  ];

}