import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/configs/constants/assets.dart';
import 'package:freud_ai/configs/constants/constants.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/routes/routes.dart';
import 'package:freud_ai/screens/Widgets/animated_column.dart';
import 'package:freud_ai/screens/personal_information/personal_information.dart';
import 'package:freud_ai/screens/profile_setup/view/change_password_dialog.dart';

class AccountSettings extends StatelessWidget {
  const AccountSettings({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  140.height,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: AnimatedColumnWrapper(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ///Heading
                        CommonWidgets().makeDynamicText(
                            size: 16,
                            weight: FontWeight.w800,
                            text: "General Settings",
                            color: AppTheme.cT!.appColorLight),

                        ///Items
                        accountSettingsItemView(
                            text: "Personal Information",
                            icon: AssetsItems.person,
                            callBack: () => Navigate.pushNamed(
                                const PersonalInformation(
                                  showBackButton: true,
                                ))),
                        /*accountSettingsItemView(
                            text: "Notifications", icon: AssetsItems.notification,
                            callBack: () =>
                                Navigate.pushNamed(const NotificationPage())),*/
                        /*accountSettingsItemView(
                            text: "Language", icon: AssetsItems.flagOutLined,
                            callBack: () =>
                                Navigate.pushNamed(const LanguagePage())),*/
                        /*accountSettingsItemView(
                            text: "Restore Purchase", icon: AssetsItems.basket),*/

                        32.height,

                        ///Heading
                        CommonWidgets().makeDynamicText(
                            size: 16,
                            weight: FontWeight.w800,
                            text: "Security & Privacy",
                            color: AppTheme.cT!.appColorLight),

                        ///Items
                        /*accountSettingsItemView(
                            text: "Change Password", icon: AssetsItems.lock,
                        callBack: ()=> showOTPVerificationDialog(context)),
                        accountSettingsItemView(
                            text: "Fingerprint unlock", icon: AssetsItems.lock),*/
                        /*accountSettingsItemView(
                            text: "Help", icon: AssetsItems.questionMark,callBack: ()=> CommonWidgets().launchUrls(Constants.privacyUrl)),*/
                        accountSettingsItemView(
                            text: "Privacy Policy",
                            icon: AssetsItems.chat,
                            callBack: () => CommonWidgets()
                                .launchUrls(Constants.privacyUrl)),
                        accountSettingsItemView(
                            text: "Terms of use",
                            icon: AssetsItems.document,
                            callBack: () => CommonWidgets()
                                .launchUrls(Constants.termsOfUse)),

                        32.height,

                        ///Heading
                        CommonWidgets().makeDynamicText(
                            size: 16,
                            weight: FontWeight.w800,
                            text: "Support",
                            color: AppTheme.cT!.appColorLight),

                        ///Items
                        accountSettingsItemView(
                            text: "Customer Support",
                            icon: AssetsItems.chat,
                            callBack: () => CommonWidgets()
                                .launchUrls(Constants.customerSupport)),
                        /*accountSettingsItemView(
                            text: "Submit Feedback", icon: AssetsItems.chatDouble,
                            callBack: () =>
                                Navigate.pushNamed(const FeedBackPage())),*/
                        accountSettingsItemView(
                            text: "Share",
                            icon: AssetsItems.share,
                            callBack: () => CommonWidgets().shareAppUrl()),

                        accountSettingsItemView(
                            text: "Rate us",
                            icon: AssetsItems.star,
                            callBack: () => CommonWidgets()
                                .launchUrls(Constants.playStoreUrl)),

                        32.height,

                        /* ///Heading
                        CommonWidgets().makeDynamicText(
                            size: 16,
                            weight: FontWeight.w800,
                            text: "Danger Zone",
                            color: AppTheme.cT!.appColorLight),

                        ///Items
                        accountSettingsItemView(
                            color: AppTheme.cT!.orangeDark,
                            text: "Close Account",
                            icon: AssetsItems.delete),

                        32.height,

                        ///Heading
                        CommonWidgets().makeDynamicText(
                            size: 16,
                            weight: FontWeight.w800,
                            text: "Log Out",
                            color: AppTheme.cT!.appColorLight),

                        ///Items
                        accountSettingsItemView(
                            text: "Close Account", icon: AssetsItems.logout),*/
                        // 42.height,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: accountSettingsHeader(context),
          ),
        ],
      ),
    );
  }



  ///Show OTP Verification Dialog
  showOTPVerificationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return const ChangePasswordDialog();
      },
    );
  }




  ///Make Schedule Button
  Widget accountSettingsItemView({text, icon, callBack, Color? color}) {
    return GestureDetector(
      onTap: () {
        CommonWidgets().vibrate();
        if (callBack != null) {
          callBack();
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.h),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
        decoration: BoxDecoration(
            color: color != null
                ? color.withOpacity(0.2)
                : AppTheme.cT!.whiteColor,
            borderRadius: BorderRadius.circular(30.w)),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.h,
              padding: EdgeInsets.all(12.w.h),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color ?? AppTheme.cT!.scaffoldLight),
              child: SvgPicture.asset(icon,
                colorFilter: ColorFilter.mode(
                  color != null
                      ? AppTheme.cT!.whiteColor ?? Colors.transparent
                      : AppTheme.cT!.appColorLight ?? Colors.transparent,
                  BlendMode.srcIn,
                ),
              ),
            ),
            10.width,
            Expanded(
              child: CommonWidgets().makeDynamicText(
                  size: 16,
                  weight: FontWeight.w700,
                  text: text,
                  color: color ?? AppTheme.cT!.appColorLight),
            ),
            SvgPicture.asset("assets/common/forward_icon.svg",
              colorFilter: ColorFilter.mode(
                color ?? AppTheme.cT!.appColorLight!,
                BlendMode.srcIn,
              ),
            ),
            10.width,
          ],
        ),
      ),
    );
  }

  ///Account Settings Header
  Widget accountSettingsHeader(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: ShapeDecoration(
        color: AppTheme.cT!.appColorLight!,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(32.w),
              bottomLeft: Radius.circular(32.w)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          40.height,
          //CommonWidgets().customAppBar(borderColor: AppTheme.cT!.whiteColor),
          //12.height,
          CommonWidgets().makeDynamicText(
              text: "Account Settings",
              size: 30,
              align: TextAlign.left,
              weight: FontWeight.w800,
              color: AppTheme.cT!.whiteColor),
          12.height,
        ],
      ),
    );
  }
}
