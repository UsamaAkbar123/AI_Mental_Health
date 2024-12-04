import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/configs/constants/assets.dart';
import 'package:freud_ai/configs/helper/extensions.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/screens/ai_therapy/screens/create-conversation/model/select_conversation_model.dart';

class ConversationAvatars extends StatefulWidget {
  final Function? selectedConversationItem;

  const ConversationAvatars({super.key, this.selectedConversationItem});

  @override
  State<ConversationAvatars> createState() => _ConversationAvatarsState();
}

class _ConversationAvatarsState extends State<ConversationAvatars> {
  List<SelectConversationModel> selectConversationModelList = [
    SelectConversationModel(
        isSelected: true, conversationIcon: AssetsItems.conversationAvatar12),
    SelectConversationModel(
        isSelected: false, conversationIcon: AssetsItems.conversationAvatar1),
    SelectConversationModel(
        isSelected: false, conversationIcon: AssetsItems.conversationAvatar2),
    SelectConversationModel(
        isSelected: false, conversationIcon: AssetsItems.conversationAvatar3),
    SelectConversationModel(
        isSelected: false, conversationIcon: AssetsItems.conversationAvatar4),
    SelectConversationModel(
        isSelected: false, conversationIcon: AssetsItems.conversationAvatar5),
    SelectConversationModel(
        isSelected: false, conversationIcon: AssetsItems.conversationAvatar6),
    SelectConversationModel(
        isSelected: false, conversationIcon: AssetsItems.conversationAvatar7),
    SelectConversationModel(
        isSelected: false, conversationIcon: AssetsItems.conversationAvatar8),
    SelectConversationModel(
        isSelected: false, conversationIcon: AssetsItems.conversationAvatar9),
    SelectConversationModel(
        isSelected: false, conversationIcon: AssetsItems.conversationAvatar10),
    SelectConversationModel(
        isSelected: false, conversationIcon: AssetsItems.conversationAvatar11),
  ];



  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height / 10.h,
      child: ListView.builder(
        itemCount: selectConversationModelList.length,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return aiTherapyConversationAvatarItemView(
              selectConversationModel: selectConversationModelList[index]);
        },
      ),
    );
  }

  /// show profile avatars
  Widget aiTherapyConversationAvatarItemView({SelectConversationModel? selectConversationModel}) {
    return Container(
        width: 80.w,
            height: 80.h,
            margin: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                width: 4,
                strokeAlign: BorderSide.strokeAlignCenter,
                color: selectConversationModel!.isSelected!
                    ? AppTheme.cT!.whiteColor!
                    : Colors.transparent,
              ),
              boxShadow: selectConversationModel.isSelected!
                  ? const [
                      BoxShadow(
                        color: Color(0x264B3425),
                        blurRadius: 16,
                        offset: Offset(0, 8),
                        spreadRadius: 0,
                      )
                    ]
                  : [],
            ),
      child: SvgPicture.asset(selectConversationModel.conversationIcon!),
    ).clickListener(
      click: () => {
        setState(() {

          widget.selectedConversationItem!(selectConversationModel.conversationIcon);

          selectConversationModel.isSelected = true;

          /// Update the isSelected property of each item
          for (var item in selectConversationModelList) {
            if (item != selectConversationModel) {
              item.isSelected = false;
            }
          }
          },
        )
      },
    );
  }
}
