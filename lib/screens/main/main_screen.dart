import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:freud_ai/configs/constants/assets.dart';
import 'package:freud_ai/configs/constants/constants.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/screens/account_settings/account_settings.dart';
import 'package:freud_ai/screens/home/home_page.dart';
import 'package:freud_ai/screens/personal_information/personal_information.dart';
import 'package:freud_ai/screens/steps/bloc/steps_bloc.dart';
import 'package:freud_ai/screens/steps/bloc/steps_event.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _page = 0;
  late PageController _pageController;
  late StepsBloc stepsBloc;

  @override
  void initState() {
    super.initState();
    stepsBloc = BlocProvider.of<StepsBloc>(context, listen: false);
    _pageController = PageController(initialPage: _page);

    /// get all the step counter goal history
    if (Constants.completeAppInfoModel!.isStepCounterGoalSet!) {
      stepsBloc.add(GetStepCounterGoalHistoryEvent());
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    App.init(context);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String getIconDataBasedOnIndex(int pageIndex) {
    switch (pageIndex) {
      case 0:
        return AssetsItems.bottomNavBarHome;
      case 1:
        return AssetsItems.bottomNavBarSetting;
      case 2:
        return AssetsItems.bottomNavBarProfile;
      default:
        return AssetsItems.bottomNavBarHome;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
           const HomePageView(),
          const AccountSettings(),
          /// every time user open the personal info screen,
          /// new screen is initiated
          /// and always init method call
          PersonalInformation(
            showBackButton: false,
            key: ValueKey(DateTime.now()),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 80.h,
        decoration: BoxDecoration(
            color: AppTheme.cT!.whiteColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32.w),
              topRight: Radius.circular(32.w),
            )),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            3,
            (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    CommonWidgets().addVibration();
                    _page = index;
                    _pageController.animateToPage(
                      _page,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  });
                },
                child: Container(
                  height: 48.h,
                  width: 48.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index == _page
                        ? AppTheme.cT!.scaffoldLight
                        : Colors.transparent,
                  ),
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                      getIconDataBasedOnIndex(index),
                    colorFilter: ColorFilter.mode(
                      index == _page
                          ? AppTheme.cT!.appColorLight ?? Colors.transparent
                          : AppTheme.cT!.lightGrey ?? Colors.transparent,
                      BlendMode.srcIn,
                    ),
                    height: 24.h,
                    width: 24.h,
                    fit: BoxFit.fill,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
