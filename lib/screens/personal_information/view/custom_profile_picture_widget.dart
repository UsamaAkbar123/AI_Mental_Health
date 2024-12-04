import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';

class CustomProfilePictureWidget extends StatelessWidget {
  final String? profileAvatar;
  final bool isAvatarSelected;
  final VoidCallback onTap;

  const CustomProfilePictureWidget({
    super.key,
    this.profileAvatar,
    required this.isAvatarSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: 80,
            height: 80,
            margin: profileAvatar != null
                ? const EdgeInsets.symmetric(horizontal: 6)
                : const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.cT!.whiteColor!,
              border: Border.all(
                color: isAvatarSelected
                    ? AppTheme.cT!.brownColor!
                    : AppTheme.cT!.whiteColor!,
                width: 3,
              ),
            ),
            child: profileAvatar != null
                ? SvgPicture.asset(profileAvatar ?? "")
                : Image.asset("assets/home/profile.png"),
          ),
          profileAvatar == null ? editProfile() : const SizedBox(),
        ],
      ),
    );
  }
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
