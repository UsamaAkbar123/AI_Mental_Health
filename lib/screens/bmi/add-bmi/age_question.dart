import 'package:flutter/material.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';

class AgeQuestion extends StatefulWidget {
  const AgeQuestion({super.key});

  @override
  State<AgeQuestion> createState() => _AgeQuestionState();
}

class _AgeQuestionState extends State<AgeQuestion> {
  final _items = List.generate(100, (index) => index + 1);
  int _selectedIndex = 17;
  late FixedExtentScrollController _scrollController;


  @override
  void initState() {
    super.initState();
    _scrollController = FixedExtentScrollController(initialItem: _selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          CommonWidgets().makeDynamicText(
              text: "Whats your age ?",
              size: 26,
              align: TextAlign.center,
              weight: FontWeight.bold,
              color: AppTheme.cT!.appColorDark),
          40.height,
          SizedBox(
            height: 400,
            child: ListWheelScrollView.useDelegate(
              controller: _scrollController,
              onSelectedItemChanged: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              itemExtent: 85, // Height of each item
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
    return GestureDetector(
      onTap: () {
        CommonWidgets().vibrate();
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
                color: AppTheme.cT!.greenColor!,
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
}
