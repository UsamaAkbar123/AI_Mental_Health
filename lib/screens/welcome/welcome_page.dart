import 'package:flutter/material.dart';
import 'package:freud_ai/screens/welcome/views/welcome_view.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: WelcomeView(),
    );
  }
}
