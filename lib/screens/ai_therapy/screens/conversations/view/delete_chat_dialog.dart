import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/extensions.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/routes/routes.dart';
import 'package:freud_ai/screens/ai_therapy/bloc/conversation_bloc.dart';
import 'package:freud_ai/screens/ai_therapy/bloc/conversation_event.dart';
import 'package:freud_ai/screens/ai_therapy/screens/conversations/model/conversations_model.dart';
import 'package:lottie/lottie.dart';

class DeleteChatDialog extends StatelessWidget {
  final bool? isFromRecent;
  final ConversationsModel? chatHistoryModel;

  const DeleteChatDialog({super.key, this.chatHistoryModel, this.isFromRecent});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: 12.w),
      backgroundColor: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 30.h),
            padding: EdgeInsets.all(15.w),
            decoration: ShapeDecoration(
              color: AppTheme.cT!.whiteColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.w),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset("assets/ai/delete_chat.json"),
                30.height,
                CommonWidgets().makeDynamicText(
                    text: "Delete This\nConversation?",
                    size: 22,
                    align: TextAlign.center,
                    weight: FontWeight.bold,
                    color: AppTheme.cT!.appColorLight),
                10.height,
                CommonWidgets().makeDynamicText(
                    text:
                    "Don’t worry. You can still restore the conversation within 30 days.",
                    size: 14,
                    align: TextAlign.center,
                    color: AppTheme.cT!.greyColor),
                10.height,
                CommonWidgets().customButton(
                    text: isFromRecent == true ? "Delete conversation" : "Delete Chat Permanently",
                    icon: "assets/common/delete_ic.svg",
                    showIcon: true,
                    buttonColor: AppTheme.cT!.orangeDark,
                    callBack: () {

                      if(isFromRecent!) {
                        context.read<ConversationBloc>().add(
                            DeleteConversationEvent(
                                chatModel: chatHistoryModel!));

                      } else {
                        context.read<ConversationBloc>().add(
                            DeleteTrashConversationEvent(
                              chatModel: chatHistoryModel!,
                              isDeleteChatPermanently: true,
                            ),
                          );
                    }

                      Navigate.pop();
                  },
                ),
                10.height,
                if (isFromRecent == false)
                  CommonWidgets().customButton(
                    text: "Restore Conversation",
                    icon: "assets/common/delete_ic.svg",
                    showIcon: true,
                    buttonColor: AppTheme.cT!.orangeDark,
                    callBack: () {
                      if (isFromRecent!) {
                        context.read<ConversationBloc>().add(
                              DeleteConversationEvent(
                                chatModel: chatHistoryModel!,
                              ),
                            );
                      } else {
                        context.read<ConversationBloc>().add(
                              DeleteTrashConversationEvent(
                                chatModel: chatHistoryModel!,
                                isDeleteChatPermanently: false,
                              ),
                            );
                      }

                      Navigate.pop();
                    },
                  )
              ],
            ),
          ),
          20.height,
          SvgPicture.asset("assets/signin/dialog_cross.svg").goBack(),
        ],
      ),
    );
  }
}
