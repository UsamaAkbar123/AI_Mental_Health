import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/configs/constants/assets.dart';
import 'package:freud_ai/configs/helper/extensions.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';

class ChatBoxTextField extends StatelessWidget {
  final Function? getFieldData;
  final TextEditingController textEditingController = TextEditingController();

  ChatBoxTextField({super.key, this.getFieldData});

  @override
  Widget build(BuildContext context) {
    return chatBoxQuestionView();
  }




  ///Here we will define the  ChatBox
  Widget chatField() {
    return Container(
      height: 52.h,
      decoration: ShapeDecoration(
        color: const Color(0xFFF7F4F2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.w),
        ),
      ),
      child: TextField(
        controller: textEditingController,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Type to start chatting...",
          contentPadding: EdgeInsets.only(right: 10.w, left: 12.w, bottom: 8.h),
          hintStyle: TextStyle(
            color: AppTheme.cT!.lightGrey,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }

  ///Chat Box Question view
  Widget chatBoxQuestionView() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 12),
      decoration: BoxDecoration(
        color: AppTheme.cT!.whiteColor!,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
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
            blurRadius: 11,
            offset: Offset(0, -5),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Color(0x0A4B3425),
            blurRadius: 20,
            offset: Offset(0, -20),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Color(0x074B3425),
            blurRadius: 27,
            offset: Offset(0, -45),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Color(0x024B3425),
            blurRadius: 32,
            offset: Offset(0, -80),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Color(0x004B3425),
            blurRadius: 35,
            offset: Offset(0, -126),
            spreadRadius: 0,
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(child: chatField()),
          20.width,
          Container(
                  width: 40.w,
                  height: 40.h,
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                      color: AppTheme.cT!.greenColor, shape: BoxShape.circle),
                  child: SvgPicture.asset(AssetsItems.chatArrow))
              .clickListener(click:()=> getFieldData!(textEditingController)),
        ],
      ),
    );
  }
}
