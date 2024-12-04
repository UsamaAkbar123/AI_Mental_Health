import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/extensions.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/routes/routes.dart';
import 'package:freud_ai/screens/Widgets/animated_column.dart';
import 'package:freud_ai/screens/Widgets/cliper.dart';
import 'package:freud_ai/screens/questions/feature/model_view_model.dart';
import 'package:freud_ai/screens/questions/questionnaire/questions_page.dart';
import 'package:lottie/lottie.dart';

class FeatureView extends StatelessWidget {
  final FeatureViewModel? featureViewModel;
  const FeatureView({super.key, this.featureViewModel});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        ///TODO IMPLEMENTATION
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppTheme.cT!.whiteColor,
        body: SizedBox(
          height: MediaQuery.sizeOf(context).height,
          child: Stack(
            children: [
              ClipPath(
                clipper: ClipperClass(),
                child: SizedBox(
                  height: MediaQuery.sizeOf(context).height / 1.8.h,
                  width: MediaQuery.sizeOf(context).width,
                  child: featureViewModel!.isAnimationFill!
                      ? Lottie.asset(featureViewModel!.animation!,
                          fit: BoxFit.fitWidth)
                      : Stack(
                          children: [
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width,
                              height: MediaQuery.sizeOf(context).height,
                              child: SvgPicture.asset(
                                  featureViewModel!.background!,
                                  fit: BoxFit.fitWidth),
                            ),
                            Lottie.asset(featureViewModel!.animation!)
                                .centralized()
                          ],
                        ),
                ),
              ),
              bottomContainer(context, featureViewModel!),
            ],
          ),
        ),
      ),
    );
  }

  /// Bottom Navigation Container
  Widget bottomContainer(context, FeatureViewModel featureViewModel) {
    return Positioned(
      right: 0,
      left: 0,
      bottom: 20.h,
      top: MediaQuery.sizeOf(context).height / 1.8.h,
      child: AnimatedColumnWrapper(
        children: [
          SizedBox(
            height: 150.h,
            child: CommonWidgets().makeDynamicTextSpan(
                text1: featureViewModel.text1,
                text2: featureViewModel.text2,
                text3: featureViewModel.text3,
                text4: featureViewModel.text4,
                color1: featureViewModel.text1Color,
                color2: featureViewModel.text2Color,
                color3: featureViewModel.text3Color,
                color4: featureViewModel.text4Color,
                size1: 26,
                align: TextAlign.center,
                weight1: FontWeight.w800),
          ),
          20.height,
          GestureDetector(
            onTap: () {

              Navigate.pushNamed(QuestionnairePage(featureViewModel: featureViewModel));
            },
            child: Container(
              width: 80.w,
              height: 80.h,
              padding: EdgeInsets.all(20.w.h),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.cT!.appColorLight),
              child: SvgPicture.asset("assets/common/forward_arrow.svg"),
            ),
          )
        ],
      ),
    );
  }
}
