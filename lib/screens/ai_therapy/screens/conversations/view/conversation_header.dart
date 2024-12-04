import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/routes/routes.dart';
import 'package:freud_ai/screens/ai_therapy/screens/create-conversation/new_conversation.dart';

class ConversationHeader extends StatelessWidget {
  final BuildContext context;

  const ConversationHeader({super.key, required this.context});

  @override
  Widget build(BuildContext context) {
    return conversationHeader();
  }

  ///Conversation Header
  Widget conversationHeader() {
    return Stack(
      children: [
        Container(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height / 1.8,
            padding: const EdgeInsets.only(bottom: 38),
            child: SvgPicture.asset("assets/ai/ai_bg.svg", fit: BoxFit.fill)),
        headerWithAppBar(),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              headerButtons(
                size: 60,
                padding: 15,
                color: AppTheme.cT!.orangeColor,
                icon: "common/filter_ic.svg",
                iconColor: AppTheme.cT!.whiteColor,
                clickListener: {},
              ),
              30.width,
              headerButtons(
                size: 80,
                padding: 25,
                color: AppTheme.cT!.whiteColor,
                icon: "common/plus_ic.svg",
                iconColor: AppTheme.cT!.appColorLight,
                clickListener: () => Navigate.pushAndReplace(const CreateConversationBots()),
              ),
              30.width,
              headerButtons(
                size: 60,
                padding: 15,
                color: AppTheme.cT!.greenColor,
                icon: "home/settings.svg",
                iconColor: AppTheme.cT!.whiteColor,
                clickListener: {},
              ),
            ],
          ),
        )
      ],
    );
  }

  ///Header View all with AppBar
  Widget headerWithAppBar() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 45.h, left: 12.w, right: 12.w),
          child: CommonWidgets().customAppBar(
              text: "My Conversations",
              actionWidget: actionWidgetAppBar(),
              borderColor: AppTheme.cT!.whiteColor),
        ),
        20.height,
        CommonWidgets().makeDynamicTextSpan(
            text1: "1571\n",
            text2: "Total Conversations",
            weight1: FontWeight.bold,
            weight2: FontWeight.w500,
            align: TextAlign.center,
            size1: 72,
            size2: 15),
        30.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            headerRowView(
              icon: "home/gpt.svg",
              text2: "Left this month",
              text1: "32",
            ),
            headerRowView(
                icon: "common/stat_lines.svg",
                text2: "Response & Support",
                text1: "Slow"),
          ],
        )
      ],
    );
  }

  ///Header Rows View
  Widget headerRowView({icon, text1, text2}) {
    return Column(
      children: [
        Row(
          children: [
            SvgPicture.asset(
              "assets/$icon",
              colorFilter: ColorFilter.mode(
                AppTheme.cT!.whiteColor ?? Colors.transparent,
                BlendMode.srcIn,
              ),
            ),
            10.width,
            CommonWidgets().makeDynamicText(
                text: text1,
                weight: FontWeight.w700,
                size: 18,
                align: TextAlign.center,
                color: AppTheme.cT!.whiteColor)
          ],
        ),
        CommonWidgets().makeDynamicText(
            text: text2,
            weight: FontWeight.w500,
            size: 14,
            align: TextAlign.center,
            color: AppTheme.cT!.whiteColor)
      ],
    );
  }

  ///Action Widget of AppBar
  Widget actionWidgetAppBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
      decoration: BoxDecoration(
          border: Border.all(width: 1.w, color: AppTheme.cT!.whiteColor!),
          borderRadius: BorderRadius.circular(20.w)),
      child: CommonWidgets().makeDynamicText(
          text: "BASIC", color: AppTheme.cT!.whiteColor, size: 14),
    );
  }

  /// Header Buttons
  Widget headerButtons(
      {color, double? size, icon, iconColor, double? padding, clickListener}) {
    return GestureDetector(
      onTap: () {
        CommonWidgets().vibrate();
        if(clickListener!=null){
          clickListener();
        }

      },
      child: Container(
        width: size,
        height: size,
        padding: EdgeInsets.all(padding!),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          boxShadow: const [
            BoxShadow(
              color: Color(0x264B3425),
              blurRadius: 32,
              offset: Offset(0, 16),
              spreadRadius: 0,
            )
          ],
        ),
        child: SvgPicture.asset(
          "assets/$icon",
          colorFilter: ColorFilter.mode(
            iconColor ?? Colors.transparent,
            BlendMode.srcIn,
          ),
          width: 24.w,
          height: 24.h,
        ),
      ),
    );
  }
}
