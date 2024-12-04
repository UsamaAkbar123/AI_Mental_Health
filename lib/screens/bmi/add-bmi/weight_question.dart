import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/extensions.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';

class WeightQuestion extends StatefulWidget {
  final Function? onWeightSelected;

  const WeightQuestion({super.key, this.onWeightSelected});

  @override
  State<WeightQuestion> createState() => _WeightQuestionState();
}

class _WeightQuestionState extends State<WeightQuestion> with AutomaticKeepAliveClientMixin{
  final _items = List.generate(
    200 ~/ 0.1,
    /// Generate weights from 0.1 kg to 200 kg with increments of 0.1 kg
    (index) => (index * 0.2) + 0.2,
  );

  int _selectedIndex = 8; // Initial middle index

  final ScrollController _scrollController = ScrollController();

  bool isKgSelected = true;

  bool isLbsSelected = false;

  double selectedWeight = 0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            CommonWidgets().makeDynamicText(
                text: "What’s your weight?",
                size: 26,
                align: TextAlign.center,
                weight: FontWeight.bold,
                color: AppTheme.cT!.appColorDark),
            30.height,
            selectWeightType(),
            30.height,
            CommonWidgets().makeDynamicTextSpan(
                text1: selectedWeight.toString(),
                text2: isKgSelected ? "Kg" : "lbs",
                color2: AppTheme.cT!.lightGrey,
                size1: 82,
                size2: 22,
                align: TextAlign.center,
                weight1: FontWeight.bold,
                color1: AppTheme.cT!.appColorLight),
            30.height,
            SizedBox(
              height: 200,
              child: Stack(
                children: [
                  NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification is ScrollStartNotification) {
                        /// Start haptic feedback when scrolling starts

                      } else if (notification is ScrollEndNotification) {
                        /// End haptic feedback when scrolling ends
                        HapticFeedback.lightImpact();

                        // widget.onWeightSelected!({
                        //   // "selectedWeight": _items[_selectedIndex].toString(),
                        //   "selectedWeight" : selectedWeight.toString(),
                        //   "selectedSymbol": isKgSelected ? "Kg" : "lbs"
                        // });

                      }

                      if (notification is ScrollUpdateNotification) {

                        CommonWidgets().addVibration();

                        final centerIndex = calculateCenterIndex(
                          notification.metrics,
                          _scrollController,
                        );

                        // if(isKgSelected){
                        //   _items[_selectedIndex] = lbsToKg(
                        //       double.parse(removeDecimalIfWhole(_items[_selectedIndex])));
                        // }else{
                        //   _items[_selectedIndex] = kgToLbs(
                        //       double.parse(removeDecimalIfWhole(_items[_selectedIndex])));
                        // }

                        setState(() {
                          _selectedIndex = centerIndex;
                          //print("central index: ${_items[_selectedIndex]}");
                          // selectedWeight = isKgSelected ? num.parse(lbsToKg(
                          //     double.parse(removeDecimalIfWhole(_items[_selectedIndex]))).toString()).toDouble() : num.parse(kgToLbs(
                          //     double.parse(removeDecimalIfWhole(_items[_selectedIndex]))).toString()).toDouble();

                          selectedWeight = isKgSelected
                              ? num.parse(
                                  removeDecimalIfWhole(
                                    _items[_selectedIndex],
                                  ),
                                ).toDouble()
                              : num.parse(
                                  removeDecimalIfWhole(
                                    kgToLbs(
                                      double.parse(
                                        _items[_selectedIndex].toString(),
                                      ),
                                    ),
                                  ),
                                ).toDouble();

                          // selectedWeight = num.parse(removeDecimalIfWhole(
                          //   _items[_selectedIndex],
                          // )).toDouble();
                        });


                        widget.onWeightSelected!({
                          // "selectedWeight": _items[_selectedIndex].toString(),
                          "selectedWeight" : selectedWeight.toString(),
                          "selectedSymbol": isKgSelected ? "Kg" : "lbs"
                        });

                      }
                      return false;
                    },
                    child: ListView.builder(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        final isSelected = index == _selectedIndex;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: weightSliderView(index, isSelected),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 150,
                      width: 10,
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
      ),
    );
  }

  /// Calculate central itemIndex
  int calculateCenterIndex(ScrollMetrics metrics, ScrollController controller) {

    /// Get the exact visible range of items
    final firstVisibleItem = controller.position.pixels / 22;
    final lastVisibleItem = firstVisibleItem + metrics.viewportDimension / 22;

    /// Calculate the middle index within the visible range
    final middleIndex = (firstVisibleItem + lastVisibleItem) / 2;

    return middleIndex.round().clamp(0, _items.length - 1);
  }

  /// Weight ItemView
  Widget weightSliderView(int index, bool isSelected) {
    return GestureDetector(
      onTap: () {
        // CommonWidgets().vibrate();
        //
        // setState(() {
        //   _selectedIndex = index;
        // });
      },
      child: Column(
        children: [
          SizedBox(
            height: 150,
            child: Container(
              width:
                  hasDecimal(double.parse(removeDecimalIfWhole(_items[index])))
                      ? 4
                      : 8,
              margin: EdgeInsets.symmetric(
                vertical: hasDecimal(
                        double.parse(removeDecimalIfWhole(_items[index])))
                    ? 50
                    : 30,
              ),
              decoration: BoxDecoration(
                color: AppTheme.cT!.lightGrey,
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Remove ".0" for whole numbers
  String removeDecimalIfWhole(double value) {
    if (value % 1 == 0) {
      return value.toInt().toString();
    } else {
      return value.toStringAsFixed(1);
    }
  }

  bool hasDecimal(double value) {
    return value % 1 != 0;
  }

  Widget selectWeightType() {
    return Container(
      height: 48.h,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.w),
        ),
      ),
      child: Row(
        children: [
          selectedTypeButton(
              isItemSelected: isKgSelected, isKilogramSelected: true, viewText: "Kg"),
          selectedTypeButton(
              isItemSelected: isLbsSelected,
              isKilogramSelected: false,
              viewText: "lbs"),
        ],
      ),
    );
  }

  Widget selectedTypeButton({isItemSelected, isKilogramSelected, viewText}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {

          CommonWidgets().vibrate();

          setState(() {
            if (isKilogramSelected) {
              isKgSelected = true;
              isLbsSelected = false;

              selectedWeight = num.parse(
                removeDecimalIfWhole(
                  _items[_selectedIndex],
                ),
              ).toDouble();

              // _items[_selectedIndex] = lbsToKg(
              //     double.parse(removeDecimalIfWhole(_items[_selectedIndex])));
              //
              // selectedWeight = num.parse(removeDecimalIfWhole(
              //   _items[_selectedIndex],
              // )).toDouble();

              //_scrollController.jumpTo(selectedWeight);
            } else {
              selectedWeight = num.parse(
                removeDecimalIfWhole(
                  kgToLbs(
                    double.parse(
                      removeDecimalIfWhole(
                        _items[_selectedIndex],
                      ),
                    ),
                  ),
                ),
              ).toDouble();

              // _items[_selectedIndex] = kgToLbs(
              //     double.parse(removeDecimalIfWhole(_items[_selectedIndex])));
              //
              // selectedWeight = num.parse(removeDecimalIfWhole(
              //   _items[_selectedIndex],
              // )).toDouble();

              //_scrollController.jumpTo(selectedWeight);

              isKgSelected = false;
              isLbsSelected = true;
            }
          });

          ///This Will Return The  Value Back
          widget.onWeightSelected!({
            "selectedWeight": _items[_selectedIndex].toString(),
            "selectedSymbol": isKgSelected ? "Kg" : "lbs"
          });
        },
        child: Container(
          height: 48.h,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 16),
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



  /// Convert kilograms to pounds
  double kgToLbs(double kg) {
    return kg * 2.20462;
  }

  /// Convert pounds to kilograms
  double lbsToKg(double lbs) {
    return lbs / 2.20462;
  }

  @override
  bool get wantKeepAlive => true;


}
