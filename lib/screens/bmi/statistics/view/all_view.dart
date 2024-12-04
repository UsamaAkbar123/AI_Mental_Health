import 'package:flutter/material.dart';
import 'package:freud_ai/screens/bmi/statistics/all_item_view.dart';

class AllView extends StatefulWidget {
  const AllView({super.key});

  @override
  State<AllView> createState() => _AllViewState();
}

class _AllViewState extends State<AllView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        return const AllItemView();
      },
    );
  }
}
