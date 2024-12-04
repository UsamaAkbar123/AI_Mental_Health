import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/extensions.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/screens/personal_information/bloc/personal_bloc.dart';

class HeightQuestion extends StatefulWidget {
  final Function? onHeightSelected;

  const HeightQuestion({super.key, this.onHeightSelected});

  @override
  State<HeightQuestion> createState() => _HeightQuestionState();
}

class _HeightQuestionState extends State<HeightQuestion>
    with AutomaticKeepAliveClientMixin {
  final _items = List.generate(
    11 * 11, // 8 feet with each foot having 12 inches
    (index) => index / 12.0, // Increment by 0.1 to represent 0.1 feet as 1 inch
  );
  int _selectedIndex = 0; // Initial middle index
  final ScrollController _scrollController = ScrollController();

  String heightUnit = "Feet";
  bool isFirstClick = true;
  double personHeight = 300;
  bool isFeetSelected = true;
  double bottomHeight = 0;
  bool isCMSelected = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final personalInformationState =
        context.read<PersonalInformationBloc>().state;
    super.build(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              CommonWidgets().makeDynamicText(
                  text: "What’s your Height?",
                  size: 26,
                  align: TextAlign.center,
                  weight: FontWeight.bold,
                  color: AppTheme.cT!.appColorDark),
              30.height,
              selectWeightType(),
              30.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height / 2.2,
                    width: 80,
                    child: Stack(
                      children: [
                        NotificationListener<ScrollNotification>(
                          onNotification: (notification) {
                            if (notification is ScrollUpdateNotification) {

                              CommonWidgets().addVibration();

                              final centerIndex =
                              calculateCenterIndex(notification.metrics);
                              setState(() {
                                _selectedIndex = centerIndex;
                              });
                            } else if (notification is ScrollEndNotification) {
                              /// End haptic feedback when scrolling ends
                              HapticFeedback.lightImpact();

                              widget.onHeightSelected!({
                                "selectedHeight": removeDecimalIfWhole(
                                    _items[_selectedIndex] > 8.6
                                            ? 8.6
                                            : _items[_selectedIndex],
                                        isFeetSelected ? "Feet" : "CM"),
                                "selectedSymbol": isFeetSelected ? "feet" : "cm"
                              });
                            }
                            return false;
                          },
                          child: ListView.builder(
                            controller: _scrollController,
                            scrollDirection: Axis.vertical,
                            reverse: true,
                            itemCount: _items.length,
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              final isSelected = index == _selectedIndex;
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 5.h),
                                child: weightSliderView(index, isSelected),
                              );
                            },
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: personHeight - 300,
                          child: Container(
                            width: 120.w,
                            height: 2.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.w),
                                color: AppTheme.cT!.greenColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.cT!.lightGreenColor!,
                                    blurRadius: 0,
                                    offset: const Offset(0, 0),
                                    spreadRadius: 4.w,
                                  )
                                ]),
                          ).centralized(),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: -100.h,
            left: 0,
            right: 100.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CommonWidgets().makeDynamicTextSpan(
                    text1: removeDecimalIfWhole(_items[_selectedIndex] > 8.6
                        ? 8.6
                        : _items[_selectedIndex],isFeetSelected ? "Feet" : "CM"),
                    text2: isFeetSelected ? "Feet" : "CM",
                    color2: AppTheme.cT!.lightGrey,
                    size1: 52,
                    size2: 22,
                    align: TextAlign.center,
                    weight1: FontWeight.bold,
                    color1: AppTheme.cT!.appColorDark),
                AnimatedContainer(
                  height: personHeight.h,
                  duration: const Duration(microseconds: 300),
                  child: SvgPicture.asset(
                    getImageBasedOnGender(
                        gender: personalInformationState
                                .personalInformationModel?.gender ??
                            ""),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// select image based on gender
  String getImageBasedOnGender({required String gender}) {
    switch (gender) {
      case "Male":
        return "assets/bmi/person.svg";
      case "Female":
        return "assets/bmi/bmiFemale.svg";
      default:
        return "assets/bmi/otherTypeGender.svg";
    }
  }

  ///
  int calculateCenterIndex(ScrollMetrics metrics) {
    final middleIndex = (metrics.pixels * 0.1).round();
    changePersonHeight();
    return middleIndex.round().clamp(0, _items.length - 1);
  }

  ///
  changePersonHeight() {
    double feet = _items[_selectedIndex]; // Assuming _items contains feet
    personHeight = 300; // Default height
    for (int i = 1; i <= feet * 12; i++) {
      personHeight += 3.6; // Increment by 5 for every inch
    }
  }

  ///
  Widget weightSliderView(int index, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: SizedBox(
        width: 80.w,
        child: Container(
          height: 2.h,
          margin: const EdgeInsets.only(left: 20),
          decoration: BoxDecoration(
            color: AppTheme.cT!.lightGrey,
            borderRadius: BorderRadius.circular(50),
          ),
        ),
      ),
    );
  }

  ///
  String removeDecimalIfWhole(double value,String unit) {
    ///final dietProvider = Provider.of<DietPlanProvider>(context, listen: false);
    String height;
    if (value % 1 == 0) {
      height = value.toInt().toString();
    } else {
      height = value.toStringAsFixed(1);
    }

    if (heightUnit == "CM") {
      final feet = feetToCm(double.parse(height));
      height = feet.toStringAsFixed(0);
    }

    return height;
  }

  bool hasDecimal(double value) {
    return value % 1 != 0;
  }

  double feetToCm(double feet) {
    // 1 foot = 30.48 centimeters
    return feet * 30.48;
  }

  ///
  Widget selectWeightType() {
    return Container(
      height: 48.h,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.w),
        ),
      ),
      child: Row(
        children: [
          selectedTypeButton(
              isItemSelected: isFeetSelected,
              isFeetSelect: true,
              viewText: "Feet"),
          selectedTypeButton(
              isItemSelected: isCMSelected,
              isFeetSelect: false,
              viewText: "CM"),
        ],
      ),
    );
  }

  ///
  Widget selectedTypeButton({isItemSelected, isFeetSelect, viewText}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {

          isFirstClick = false ;


          setState(() {
            if (isFeetSelect) {
              isFeetSelected = true;
              isCMSelected = false;
              heightUnit = "Feet";
            } else {
              heightUnit = "CM";
              isFeetSelected = false;
              isCMSelected = true;
            }
          });

          widget.onHeightSelected!({
            "selectedHeight": isFeetSelected
                ? _items[_selectedIndex].toString()
                : (_items[_selectedIndex] * 30.48).toString(),
            "selectedSymbol": isFeetSelected ? "feet" : "cm"
          });

          log(
              "PrintedHeightSelection :: ${_items[_selectedIndex].toString()}");
        },
        child: Container(
          height: 48.h,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration:
              isItemSelected ? selectedDecoration() : const BoxDecoration(),
          child: CommonWidgets().makeDynamicText(
              text: viewText,
              size: 26,
              align: TextAlign.center,
              weight: FontWeight.bold,
              color: isItemSelected
                  ? AppTheme.cT!.whiteColor
                  : AppTheme.cT!.appColorDark),
        ),
      ),
    );
  }

  ///
  BoxDecoration selectedDecoration() {
    return BoxDecoration(
      color: AppTheme.cT!.orangeColor,
      borderRadius: BorderRadius.circular(30.w),
      boxShadow: [
        BoxShadow(
          color: const Color(0x3FFE814B),
          blurRadius: 0,
          offset: const Offset(0, 0),
          spreadRadius: 4.w,
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
