import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/configs/constants/assets.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/routes/routes.dart';
import 'package:freud_ai/screens/ai_therapy/screens/conversations/model/conversations_model.dart';
import 'package:freud_ai/screens/ai_therapy/screens/conversations/view/delete_chat_dialog.dart';
import 'package:freud_ai/screens/ai_therapy/screens/inbox/chat_box_page.dart';

class ConversationItemView extends StatelessWidget {
  final bool? isFromRecent;
  final ConversationsModel? conversationModel;

  const ConversationItemView({
    super.key,
    this.conversationModel,
    this.isFromRecent,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigate.pushNamed(ChatInBoxPage(
          chatHistoryModel: conversationModel!,
          isFromRecent: isFromRecent,
        ));
      },
      onLongPress: () {
        showDialog(
          context: context,
          useRootNavigator: true,
          builder: (context) {
            return DeleteChatDialog(
                chatHistoryModel: conversationModel!,
              isFromRecent: isFromRecent,
            );
          },
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.all(16.w),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32.w),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x0C4B3425),
              blurRadius: 16,
              offset: Offset(0, 8),
              spreadRadius: 0,
            )
          ],
        ),
        child: SizedBox(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: SizedBox(
                  height: 64,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 64.h,
                        width: 64.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.cT!.greenColor,
                        ),
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                          conversationModel!.aiTherapyIcon!,
                          fit: BoxFit.fill,
                          height: 40.h,
                          width: 40.h,
                          colorFilter: ColorFilter.mode(
                            AppTheme.cT!.whiteColor ?? Colors.transparent,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      12.width,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonWidgets().makeDynamicText(
                                text: conversationModel!.chatTitle,
                                size: 16,
                                lines: 1,
                                weight: FontWeight.w700,
                                color: AppTheme.cT!.appColorLight),
                            const SizedBox(height: 6),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 5.h),
                                  child: SvgPicture.asset(
                                      AssetsItems.chat,
                                    colorFilter: ColorFilter.mode(
                                      AppTheme.cT!.greyColor ??
                                          Colors.transparent,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                                10.width,
                                CommonWidgets().makeDynamicText(
                                    text:
                                    "${conversationModel!.totalChatCount} Total",
                                    size: 14,
                                    weight: FontWeight.w600,
                                    color: AppTheme.cT!.greyColor),
                                10.width,
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              10.width,
              SvgPicture.asset("assets/common/forward_icon.svg",
                colorFilter: ColorFilter.mode(
                  AppTheme.cT!.greyColor ?? Colors.transparent,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
