import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/routes/routes.dart';
import 'package:freud_ai/screens/Widgets/cliper.dart';
import 'package:freud_ai/screens/mood/views/add_mood_page.dart';
import 'package:freud_ai/screens/profile_setup/otp_screen.dart';

class ProfileViewPage extends StatefulWidget {
  const ProfileViewPage({super.key});

  @override
  State<ProfileViewPage> createState() => _ProfileViewPageState();
}

class _ProfileViewPageState extends State<ProfileViewPage> {
  @override
  Widget build(BuildContext context) {


    App.init(context);
    Size.init(context);

    return Scaffold(
      body: healthBody(),
      bottomNavigationBar: continueButton(),
    );
  }



  ///Continue Button Where user will click a d go to OTP screen
  Widget continueButton(){
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h.h),
        child:
        CommonWidgets().customButton(text: "Continue", showIcon: true,callBack: ()=>Navigate.pushNamed(const OTPScreen())));
  }




  ///Mental Health Body
  Widget healthBody() {
    return SingleChildScrollView(
      child: Stack(
        children: [
          ClipPath(
            clipper: ClipperClass(),
            child: Container(
              height: MediaQuery.sizeOf(context).height / 2.h,
              width: MediaQuery.sizeOf(context).width,
              color: AppTheme.cT!.brownColor,
              child: SvgPicture.asset("assets/mood/mood_bg.svg",
                  fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 50.h, left: 12.w, right: 12.w),
            child: CommonWidgets().customAppBar(
                text: "Mood", borderColor: AppTheme.cT!.whiteColor),
          ),
          Positioned(
            bottom: 15.h,
            left: 0,
            right: 0,
            child: CommonWidgets().ovalButton(
                iconData: Icons.add,
                callBack: () => Navigate.pushNamed(const AddMoodPage())),
          ),
        ],
      ),
    );
  }

  ///AppBar
  Widget appBarWidget() {
    return Container(
      margin: EdgeInsets.only(top: 50.h),
      child: Row(
        children: [
          CommonWidgets().backButton(borderColor: AppTheme.cT!.whiteColor),
          10.width,
          CommonWidgets().makeDynamicText(
              text: "Profile Setup",
              size: 28,
              weight: FontWeight.w600,
              color: AppTheme.cT!.whiteColor)
        ],
      ),
    );
  }

  ///Profile Picture
  Widget profilePicture() {
    return Stack(
      children: [
        Container(
          width: 80,
          height: 80,
          margin: EdgeInsets.only(
              top: MediaQuery.sizeOf(context).height / 3.5 - 40),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.cT!.whiteColor!,
          ),
          child: Image.asset("assets/home/profile.png"),
        ),
        editProfile(),
      ],
    );
  }

  ///Profile Picture
  Widget editProfile() {
    return Positioned(
      bottom: 0,
      right: 0,
      child: Container(
        width: 30,
        height: 30,
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: AppTheme.cT!.appColorLight!),
        child: SvgPicture.asset("assets/profile/edit.svg"),
      ),
    );
  }

}