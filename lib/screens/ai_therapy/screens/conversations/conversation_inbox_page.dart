import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/extensions.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/routes/routes.dart';
import 'package:freud_ai/screens/ai_therapy/bloc/conversation_bloc.dart';
import 'package:freud_ai/screens/ai_therapy/bloc/conversation_event.dart';
import 'package:freud_ai/screens/ai_therapy/bloc/conversation_state.dart';
import 'package:freud_ai/screens/ai_therapy/screens/conversations/model/conversations_model.dart';
import 'package:freud_ai/screens/ai_therapy/screens/conversations/view/conversation_itemview.dart';
import 'package:freud_ai/screens/ai_therapy/screens/create-conversation/new_conversation.dart';
import 'package:freud_ai/screens/ai_therapy/screens/out-tokens/out_of_token_page.dart';

class ConversationInboxPage extends StatefulWidget {
  const ConversationInboxPage({super.key});

  @override
  State<ConversationInboxPage> createState() => _ConversationInboxPageState();
}

class _ConversationInboxPageState extends State<ConversationInboxPage> {
  bool isRecentSelected = true;
  bool isTrashSelected = false;

  @override
  void initState() {
    super.initState();
    getTheConversationList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: conversationScreenBody(),
    );
  }

  ///Conversation Screen Body
  Widget conversationScreenBody() {
    return BlocBuilder<ConversationBloc, ConversationState>(
      bloc: context.read<ConversationBloc>(),
      builder: (BuildContext context, ConversationState state) {
        return Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    210.height,
                    state.status == ConversationStatus.loaded &&
                            state.listOfChatHistoryModel != null &&
                            state.listOfChatHistoryModel!.isNotEmpty &&
                            isRecentSelected
                        ? CommonWidgets().listViewAboveRow(
                            context: context,
                            text1: "Recent",
                            text2: "",
                            callBack: () => Navigate.pushNamed(
                              const OutOfTokenPage(),
                            ),
                          )
                        : const SizedBox(),
                    state.status == ConversationStatus.loaded &&
                            isRecentSelected
                        ? ListView.builder(
                            itemCount: state.listOfChatHistoryModel!.length,
                            shrinkWrap: true,
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              ConversationsModel conversationModel =
                                  state.listOfChatHistoryModel![index];

                              return ConversationItemView(
                            isFromRecent: true,
                            conversationModel: conversationModel
                        );
                      },
                    )
                        : const SizedBox(),
                    state.status == ConversationStatus.loaded &&
                        state.listOfTrashChatHistory != null &&
                        state.listOfTrashChatHistory!.isNotEmpty &&
                        isTrashSelected
                        ? CommonWidgets().listViewAboveRow(
                            context: context,
                            text1: "Trash",
                        text2: "",
                            callBack: () => {})
                        : const SizedBox(),
                    state.status == ConversationStatus.loaded &&
                            state.listOfTrashChatHistory != null &&
                            isTrashSelected
                        ? ListView.builder(
                            itemCount: state.listOfTrashChatHistory!.length,
                            shrinkWrap: true,
                            reverse: true,
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return ConversationItemView(
                                isFromRecent: false,
                                conversationModel:
                                    state.listOfTrashChatHistory![index],
                              );
                            },
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: conversationInboxHeader(),
            ),
          ],
        );
      },
    );
  }

  ///Conversation Inbox header
  Widget conversationInboxHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: ShapeDecoration(
        color: AppTheme.cT!.orangeColor!,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(30),
            bottomLeft: Radius.circular(30),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          40.height,
          CommonWidgets().customAppBar(
            borderColor: AppTheme.cT!.whiteColor,
            text: "My Ai Chats",
            actionWidget: Container(
              width: 48.w,
              height: 48.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.cT!.orangeColor50,
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x264B3425),
                    blurRadius: 32,
                    offset: Offset(0, 16),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Icon(
                Icons.add,
                size: 24,
                color: AppTheme.cT!.whiteColor!,
              ),
            ).clickListener(
              click: () => Navigate.pushNamed(
                const CreateConversationBots(),
              ),
            ),
          ),
          32.height,
          selectInboxType(),
          12.height
        ],
      ),
    );
  }

  ///Select Inbox Type
  Widget selectInboxType() {
    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(vertical: 2.h),
      decoration: ShapeDecoration(
        color: AppTheme.cT!.appShadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26.w),
        ),
      ),
      child: Row(
        children: [
          selectedTypeButton(
              isItemSelected: isRecentSelected,
              isRecent: true,
            viewText: "Recent",
          ),
          selectedTypeButton(
              isItemSelected: isTrashSelected,
              isRecent: false,
            viewText: "Trash",
          ),
        ],
      ),
    );
  }

  ///Select Button
  Widget selectedTypeButton({isItemSelected, isRecent, viewText}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          CommonWidgets().vibrate();
          setState(() {
            if (isRecent) {
              isRecentSelected = true;
              isTrashSelected = false;
            } else {
              isRecentSelected = false;
              isTrashSelected = true;
            }
          });
        },
        child: Container(
          height: 48.h,
          alignment: Alignment.center,
          decoration:
              isItemSelected ? selectedDecoration() : const BoxDecoration(),
          child: CommonWidgets().makeDynamicText(
              text: viewText,
              size: 16,
              align: TextAlign.center,
              weight: FontWeight.w800,
              color: isItemSelected
                  ? AppTheme.cT!.orangeDark
                  : AppTheme.cT!.whiteColor),
        ),
      ),
    );
  }

  ///BoxDecoration
  BoxDecoration selectedDecoration() {
    return BoxDecoration(
      color: AppTheme.cT!.whiteColor,
      borderRadius: BorderRadius.circular(30.w),
      boxShadow: [
        BoxShadow(
          color: const Color(0x3FFFFFFF),
          blurRadius: 0,
          offset: const Offset(0, 0),
          spreadRadius: 4.w,
        )
      ],
    );
  }

  /// Here we will get the  chat History from the Local Storage
  getTheConversationList() {
    context.read<ConversationBloc>().add(GetConversationEvent());
  }
}
