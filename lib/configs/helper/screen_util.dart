import 'package:flutter/material.dart';

class Size {

  static late MediaQueryData _mediaQueryData;
  static late Orientation orientation;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;
  static late double viewInsectsBottom;



  /// static late double defaultSize
  Size.init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    orientation = _mediaQueryData.orientation;
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
    viewInsectsBottom = _mediaQueryData.viewInsets.bottom;
  }
}

extension Sizes on num{

  double get w{
    final double screenWidth = Size.screenWidth;

    /// 375 is the layout width that designer use
    int width = Size.screenWidth > 700 ? 1366 : 414;
    return (toDouble() / width) * screenWidth;
  }

  double get h{
    final double screenHeight = Size.screenHeight;
    // 812 is the layout height that designer use {use your own designer height}
    int height = Size.screenHeight < 700 ? 320 : 852;
    return (toDouble() / height) * screenHeight;
  }

  SizedBox get height => SizedBox(
    height: toDouble().w,
  );

  SizedBox get width => SizedBox(
    width: toDouble().w,
  );

}