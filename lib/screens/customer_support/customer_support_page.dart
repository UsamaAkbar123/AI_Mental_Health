import 'package:flutter/material.dart';
import 'package:freud_ai/configs/constants/assets.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/screens/Widgets/animated_column.dart';
import 'package:freud_ai/screens/Widgets/textfield/build_text_field.dart';

class CustomerSupportPage extends StatelessWidget {
  const CustomerSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          children: [
            50.height,
            CommonWidgets().customAppBar(text: "Customer Support"),
            32.height,
            AnimatedColumnWrapper(
              children: [
                _buildEmailAddressField(
                    heading: "Email Address",
                    hint: "waqas@gmail.com",
                    icon: AssetsItems.mail),
                32.height,
                _buildEmailAddressField(
                    heading: "Username",
                    hint: "Enter your username...",
                    icon: AssetsItems.person),
                32.height,
                _buildEmailAddressField(
                    heading: "Title",
                    hint: "Enter your subject title...",
                    icon: AssetsItems.document),
                32.height,
                descriptionInput(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  ///Email TextField
  Widget _buildEmailAddressField({heading, hint, icon, lines}) {
    return CustomTextField(
      hintName: hint,
      headingName: heading,
      startIcon: icon,
      maxLines: lines,
      fieldType: "text",
    );
  }



  ///Show Tags
  Widget descriptionInput(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonWidgets().makeDynamicText(
            size: 14,
            weight: FontWeight.w800,
            text: "Message",
            color: AppTheme.cT!.appColorLight),
        10.height,
        Container(
          height: MediaQuery.sizeOf(context).height / 6.h,
          margin: EdgeInsets.only(bottom: 10.h),
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
          decoration: BoxDecoration(
            color: AppTheme.cT!.whiteColor,
            borderRadius: BorderRadius.circular(32.w)
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: MediaQuery.sizeOf(context).height / 6.h - 50.h,
                child: TextField(
                  maxLines: 30,
                  style: TextStyle(fontSize: 16.w, fontWeight: FontWeight.w400),
                  decoration: InputDecoration(
                    hintText: 'Enter your feedback here...',
                    hintStyle: TextStyle(
                        color: AppTheme.cT!.lightGrey,
                        fontWeight: FontWeight.normal),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(bottom: 20.h),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }



}
