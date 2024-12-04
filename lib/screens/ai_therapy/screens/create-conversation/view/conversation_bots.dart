import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/configs/constants/assets.dart';
import 'package:freud_ai/configs/constants/constants.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/screens/ai_therapy/screens/create-conversation/model/conversation_bot_model.dart';

class ConversationBots extends StatefulWidget {
  final Function? selectConversationBot;

  const ConversationBots({super.key, this.selectConversationBot});

  @override
  State<ConversationBots> createState() => _ConversationBotsState();
}

class _ConversationBotsState extends State<ConversationBots> {
  List<ConversationBotModel>? listOfAiTherapyModel = [
    ConversationBotModel(
        aiBotName: 'Self-Evaluation',
        isSelected: false,
        botPrompt: Constants.selfEvaluationPrompt,
        itemIcon: AssetsItems.radial),

    ConversationBotModel(
        aiBotName: 'AI Doctor',
        isSelected: true,
        botPrompt: Constants.aiDoctor,
        itemIcon: AssetsItems.aiDoctor),

    ConversationBotModel(
        aiBotName: 'AI Diet Planner',
        botPrompt: Constants.dietPlanner,
        isSelected: false,
        itemIcon: AssetsItems.muscle),

    ConversationBotModel(
        aiBotName: 'AI Nutrition',
        isSelected: false,
        botPrompt: Constants.aiNutrition,
        itemIcon: AssetsItems.flower),

    ConversationBotModel(
        aiBotName: 'AI Gym Instructor',
        botPrompt: Constants.aiGymInstructor,
        isSelected: false,
        itemIcon: AssetsItems.muscle),


  ];

  @override
  Widget build(BuildContext context) {
    return listOfAiChatBots();
  }

  ///List of Ai Chat Bots
  Widget listOfAiChatBots() {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height / 6.h,
      child: ListView.builder(
        itemCount: listOfAiTherapyModel!.length,
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredGrid(
            position: index,
            duration: const Duration(milliseconds: 800),
            columnCount: 2,
            child: ScaleAnimation(
              child: FadeInAnimation(
                child: aiBotsItemView(
                    aiTherapyModel: listOfAiTherapyModel![index]),
              ),
            ),
          );
        },
      ),
    );
  }



  ///Medication Type View
  Widget aiBotsItemView({ConversationBotModel? aiTherapyModel}) {
    return GestureDetector(
      onTap: () {
        CommonWidgets().vibrate();
        setState(() {
          aiTherapyModel.isSelected = true;
          widget.selectConversationBot!.call(aiTherapyModel);

          /// Update the isSelected property of each item
          for (var item in listOfAiTherapyModel!) {
            if (item != aiTherapyModel) {
              item.isSelected = false;
            }
          }
        });


      },

      child: Container(
        width: 150.w,
        margin: EdgeInsets.only(right: 8.w),
        decoration: ShapeDecoration(
          color: aiTherapyModel!.isSelected!
              ? AppTheme.cT!.greenColor
              : const Color(0xffD9D9D9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.w),
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 80.h,
                    width: 80.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.cT!.whiteColor,
                      border: Border.all(
                        width: 2.4,
                        color: !aiTherapyModel.isSelected!
                            ? const Color(0xffE1E1E1)
                            : const Color(0xff556433).withOpacity(0.45),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: SvgPicture.asset(aiTherapyModel.itemIcon ?? "",
                        height: 50.h,
                        width: 50.h,
                        alignment: Alignment.center,
                      colorFilter: ColorFilter.mode(
                        !aiTherapyModel.isSelected!
                            ? AppTheme.cT!.appColorLight ?? Colors.transparent
                            : AppTheme.cT!.greenColor ?? Colors.transparent,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  4.height,
                  CommonWidgets().makeDynamicText(
                      text: aiTherapyModel.aiBotName,
                      size: 15,
                      weight: FontWeight.w700,
                      color: aiTherapyModel.isSelected!
                          ? AppTheme.cT!.whiteColor
                          : const Color(0xff736B66))
                ],
              ),
            ),
            Positioned(
              top: 10.h,
              right: 10.w,
              child: Offstage(
                offstage: aiTherapyModel.isSelected == true ? false : true,
                child: Container(
                  height: 16.h,
                  width: 16.h,
                  decoration: BoxDecoration(
                    color: AppTheme.cT!.orangeColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 2,
                      color: const Color(0xffC4CDB0),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
