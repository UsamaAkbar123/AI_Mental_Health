import 'package:flutter/material.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/routes/routes.dart';
import 'package:intl/intl.dart';

extension Extension on Widget {
  Widget centralized() {
    return Center(
      child: this,
    );
  }

  Widget expanded() {
    return Expanded(
      child: this,
    );
  }

  Widget goBack() {
    return GestureDetector(
      onTap: () {
        Navigate.pop();
      },
      child: this,
    );
  }


  Widget clickListener({VoidCallback? click}){
    return GestureDetector(
      onTap: (){
        CommonWidgets().vibrate();
        click!();
      },
      child: this,
    );
  }

}




extension FormateDate on DateTime{

  String get formatMMDD => DateFormat('MMM dd').format(this);


}





///Double Extension
extension DoubleExtension on double {

  int get integerPart => toInt();

  double get toTwoDecimals {
    return (this * 100).truncateToDouble() / 100;
  }

}