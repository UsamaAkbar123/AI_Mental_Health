import 'package:flutter/material.dart';
import 'package:freud_ai/screens/sleep/view/sleep_item_view.dart';

class AllStepsView extends StatelessWidget {
  const AllStepsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return const SleepItemView(isFromStat: true);
      },
    );
  }
}
