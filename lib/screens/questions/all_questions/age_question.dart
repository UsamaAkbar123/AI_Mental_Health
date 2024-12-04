import 'package:flutter/material.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';

class AgeQuestion extends StatefulWidget {
  const AgeQuestion({super.key});

  @override
  State<AgeQuestion> createState() => _AgeQuestionState();
}

class _AgeQuestionState extends State<AgeQuestion>
    with AutomaticKeepAliveClientMixin {
  final _items = List.generate(100, (index) => index + 1);
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          CommonWidgets().makeDynamicText(
              text: "Whats your age ?",
              size: 26,
              align: TextAlign.center,
              weight: FontWeight.bold,
              color: AppTheme.cT!.appColorDark),
          const SizedBox(height: 40),
          SizedBox(
            height: 400,
            child: ListWheelScrollView.useDelegate(
              onSelectedItemChanged: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              itemExtent: 100, // Height of each item
              diameterRatio: 10.25, // Adjust spacing between items
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: _items.length,
                builder: (context, index) {
                  final isSelected = index == _selectedIndex;
                  return monthItemView(index, isSelected);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///Month ItemView
  Widget monthItemView(int index, bool isSelected) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        alignment: Alignment.center,
        width: 200,
        clipBehavior: Clip.antiAlias,
        decoration: isSelected
            ? BoxDecoration(
                color: const Color(0xFF9BB067),
                border:
                    Border.all(width: 5, color: AppTheme.cT!.lightGreenColor!),
                borderRadius: BorderRadius.circular(50),
              )
            : const BoxDecoration(),
        child: CommonWidgets().makeDynamicText(
            text: _items[index].toString(),
            size: isSelected ? 60 : 28,
            align: TextAlign.center,
            weight: isSelected ? FontWeight.bold : FontWeight.normal,
            color:
                isSelected ? AppTheme.cT!.whiteColor : AppTheme.cT!.greyColor),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
