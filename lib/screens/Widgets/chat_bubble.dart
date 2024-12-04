import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/configs/constants/assets.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/extensions.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/screens/ai_therapy/screens/inbox/model/chat_model.dart';

class ChatBubble extends StatelessWidget {
  final BuildContext context;
  final ChatInboxModel? chatModel;

  const ChatBubble({super.key, required this.context, this.chatModel});

  @override
  Widget build(BuildContext context) {
    return !chatModel!.isReceived!
        ? messageSetBubble(chatModel!.question!)
        : messageReceivedBubble(chatModel!.answer!.toString());
  }

  ///
  Widget messageSetBubble(String text) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.sizeOf(context).width,
          margin: EdgeInsets.only(bottom: 10.h, left: 50.w),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: AppTheme.cT!.appColorLight,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(12.w),
              topLeft: Radius.circular(12.w),
              bottomLeft: Radius.circular(12.w),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CommonWidgets().makeDynamicText(
                  text: text,
                  size: 14,
                  weight: FontWeight.w600,
                  color: AppTheme.cT!.whiteColor,
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                child: Container(
                  width: 40.w,
                  height: 40.h,
                  padding: EdgeInsets.all(8.h),
                  decoration: BoxDecoration(
                    color: AppTheme.cT!.brownColor,
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    chatModel?.conversationAvatar ?? "",
                  ),
                ),
              )
            ],
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            width: 10,
            height: 20,
            decoration: BoxDecoration(
              color: AppTheme.cT!.appColorLight,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget messageReceivedBubble(String text) {
    return Stack(
      children: text.isNotEmpty
          ? [
              Container(
                width: MediaQuery.sizeOf(context).width,
                margin: EdgeInsets.only(bottom: 10.h, right: 50.w),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                decoration: const BoxDecoration(
                  color: Color(0xFFE8DCD8),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12),
                    topLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      child: Container(
                        width: 40.w,
                        height: 40.h,
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                            color: AppTheme.cT!.scaffoldLight,
                            shape: BoxShape.circle),
                        child: SvgPicture.asset(AssetsItems.chatGpt,
                          colorFilter: ColorFilter.mode(
                            AppTheme.cT?.brownColor50 ?? Colors.transparent,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                    10.width,
                    Expanded(
                      child: CommonWidgets().makeDynamicText(
                        text: text,
                        size: 14,
                        weight: FontWeight.w600,
                        color: AppTheme.cT!.appColorLight,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                bottom: 0,
                child: Container(
                  width: 10,
                  height: 20,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8DCD8),
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20.w),
                    ),
                  ),
                ),
              )
            ]
          : [
              CupertinoActivityIndicator(
                radius: 12.w,
                color: AppTheme.cT!.appColorLight,
              ).centralized()
            ],
    );
  }
}
