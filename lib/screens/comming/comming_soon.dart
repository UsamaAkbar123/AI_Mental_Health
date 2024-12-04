import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/configs/constants/assets.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:lottie/lottie.dart';

class ComingSoonScreen extends StatelessWidget {
  final String? title;
  const ComingSoonScreen({super.key,this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
              child: SvgPicture.asset(AssetsItems.comingSoonBackground,fit: BoxFit.cover)),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              appBarWidget(),
              Column(
                children:[
                  CommonWidgets().makeDynamicText(
                      text: "Stay Tuned",
                      size: 28,
                      align: TextAlign.start,
                      weight: FontWeight.w800,
                      color: AppTheme.cT!.appColorLight),
                  CommonWidgets().makeDynamicText(
                      text: "We're finalizing new features\nfor an upcoming launch.",
                      size: 16,
                      align: TextAlign.center
                      ,
                      weight: FontWeight.w500,
                      color: AppTheme.cT!.lightGrey),
                ]
              ),
              Lottie.asset(AssetsItems.comingSoonIlu),
            ],
          ),
          
        ],
      ),
    );
  }



  ///AppBar
  Widget appBarWidget() {

    return Padding(
      padding: EdgeInsets.only(top: 50.h, left: 12.w, right: 12.w),
      child: CommonWidgets().customAppBar(
          borderColor: AppTheme.cT!.appColorLight,
          showBackButton: true,
          text: title),
    );
  }

}
