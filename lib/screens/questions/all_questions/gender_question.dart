import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/extensions.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/routes/routes.dart';

class GenderQuestion extends StatefulWidget {
  final bool? isMale ;
  const GenderQuestion({super.key,this.isMale});

  @override
  State<GenderQuestion> createState() => _GenderQuestionState();
}

class _GenderQuestionState extends State<GenderQuestion>
    with AutomaticKeepAliveClientMixin {
  bool isMaleSelected = true;
  bool isFeMaleSelected = false;


  @override
  void initState() {
    super.initState();

    if(widget.isMale!){
      isMaleSelected = true;
      isFeMaleSelected = false;
    }else{
      isMaleSelected = false;
      isFeMaleSelected = true;
    }


  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              appBarWidget(),
              40.height,
              CommonWidgets().makeDynamicText(
                  text: "Whats your official\nGender?",
                  size: 30,
                  align: TextAlign.center,
                  weight: FontWeight.w800,
                  color: AppTheme.cT!.appColorDark),
              40.height,
              radioContainer(
                  isMaleView: true,
                  isMaleSelect: isMaleSelected,
                  viewText: "I am male",
                  imageView: "male_radio.svg",
                  iconView: "male_indicator.svg"),
              12.height,
              radioContainer(
                  isMaleView: false,
                  isMaleSelect: isFeMaleSelected,
                  viewText: "I am female",
                  imageView: "female_radio.svg",
                  iconView: "female_indicator.svg"),
              // 40.height,
              const Spacer(),
              preferToSkipNotification(),
              16.height,
              CommonWidgets().customButton(
                  text: "Continue",
                  icon: "assets/common/forward_arrow.svg",
                  callBack: () {
                    if (isMaleSelected) {
                      isMaleSelected = true;
                      isFeMaleSelected = false;
                      Navigate.pop("Male");
                    } else {
                      isMaleSelected = false;
                      isFeMaleSelected = true;
                      Navigate.pop("Female");
                    }
                  },
                  showIcon: true),
              28.height,
            ],
          ),
        ),
      ),
    );
  }

  ///Gender Selection View
  Widget radioContainer({
    isMaleSelect,
    isMaleView,
    viewText,
    imageView,
    iconView,
  }) {
    return Container(
      // height: MediaQuery.sizeOf(context).width / 2.5,
      height: 155.h,
      width: double.infinity,
      // padding: EdgeInsets.only(left: 16.w),
      decoration: BoxDecoration(
          color: AppTheme.cT!.whiteColor,
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          border: isMaleView
              ? Border.all(
                  width: 1.5,
                  color: isMaleSelected
                      ? AppTheme.cT!.appColorDark!
                      : AppTheme.cT!.whiteColor!)
              : Border.all(
                  width: 1.5,
                  color: isFeMaleSelected
                      ? AppTheme.cT!.appColorDark!
                    : AppTheme.cT!.whiteColor!),
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonWidgets().makeDynamicText(
                    text: viewText,
                    size: 16,
                    weight: FontWeight.bold,
                    color: AppTheme.cT!.appColorDark),
                const Spacer(),
                SvgPicture.asset("assets/assessment/$iconView"),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: SvgPicture.asset("assets/assessment/$imageView"),
            ),
          ),
        ],
      ),
    ).clickListener(click: () {
      setState(() {
        if (isMaleView) {
          isMaleSelected = true;
          isFeMaleSelected = false;
        } else {
          isMaleSelected = false;
          isFeMaleSelected = true;
        }
      });
    });
  }

  ///Skip Selection View
  Widget preferToSkipNotification() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: ShapeDecoration(
        color: AppTheme.cT!.lightGreenColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1000),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CommonWidgets().makeDynamicText(
              text: "Prefer to Skip!,  thanks",
              size: 16,
              weight: FontWeight.bold,
              color: AppTheme.cT!.greenColor),
          const SizedBox(width: 16),
          SvgPicture.asset("assets/assessment/green_cross.svg")
        ],
      ),
    ).clickListener(click: ()=> Navigate.pop("Other"));
  }

  ///AppBar
  Widget appBarWidget() {
    return Padding(
      padding: EdgeInsets.only(top: 50.h, left: 12.w, right: 12.w),
      child: CommonWidgets().customAppBar(
        callBack: (){
          Navigate.pop();
        },
          borderColor: AppTheme.cT!.appColorLight,
          showBackButton: true,
          text: ""),
    );
  }

  @override
  bool get wantKeepAlive => true;
}