import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/routes/routes.dart';
import 'package:freud_ai/screens/ai_therapy/screens/create-conversation/model/selected_conversation_model.dart';

class ChatBoxHeader extends StatelessWidget {
  final SelectedConversationModel? selectedConversationModel;

  const ChatBoxHeader({super.key, this.selectedConversationModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 50, bottom: 20, left: 12, right: 12),
      decoration: BoxDecoration(
        color: AppTheme.cT!.whiteColor!,
        borderRadius: BorderRadius.only(
          bottomLeft: const Radius.circular(20),
          bottomRight: Radius.circular(20.w),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C4B3425),
            blurRadius: 0,
            offset: Offset(0, 0),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Color(0x0C4B3425),
            blurRadius: 15,
            offset: Offset(0, 7),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Color(0x0A4B3425),
            blurRadius: 28,
            offset: Offset(0, 28),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Color(0x074B3425),
            blurRadius: 37,
            offset: Offset(0, 62),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Color(0x024B3425),
            blurRadius: 44,
            offset: Offset(0, 110),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Color(0x004B3425),
            blurRadius: 48,
            offset: Offset(0, 172),
            spreadRadius: 0,
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          actionContainer(
              isFill: true,
              icon: "common/back_icon.svg",
              color: AppTheme.cT!.appColorLight),
          20.width,
          CommonWidgets().makeDynamicText(
              text: selectedConversationModel!.selectedBot,
              size: 18,
              lines: 1,
              weight: FontWeight.w700,
              color: AppTheme.cT!.appColorLight),
          /*Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  children: [
                    CommonWidgets().makeDynamicText(
                        text: "251 Chats Left",
                        size: 12,
                        lines: 1,
                        weight: FontWeight.w700,
                        color: AppTheme.cT!.greyColor),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: CommonWidgets()
                          .makeDot(color: AppTheme.cT!.greyColor),
                    ),
                    CommonWidgets().makeDynamicText(
                        text: "GPT-4",
                        size: 12,
                        lines: 1,
                        weight: FontWeight.w700,
                        color: AppTheme.cT!.greyColor),
                  ],
                ),
              ],
            ),
          ),
          actionContainer(
              isFill: false,
              icon: "signin/search.svg",
              color: AppTheme.cT!.greyColor),
          10.width,
          actionContainer(
              isFill: false,
              icon: "home/gpt.svg",
              color: AppTheme.cT!.greyColor),*/
        ],
      ),
    );
  }

  ///Action Container
  Widget actionContainer({isFill, icon, color}) {
    return GestureDetector(
      onTap: isFill ? () => Navigate.pop() : null,
      child: Container(
        width: 48.w,
        height: 48.h,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          border: isFill
              ? null
              : Border.all(width: 1.w, color: AppTheme.cT!.greyColor!),
          color: isFill ? AppTheme.cT!.scaffoldLight : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(
          "assets/$icon",
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          width: 24.w,
          height: 24.w,
        ),
      ),
    );
  }
}
