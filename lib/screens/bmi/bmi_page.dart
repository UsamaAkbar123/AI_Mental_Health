import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/configs/constants/assets.dart';
import 'package:freud_ai/configs/constants/constants.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/extensions.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/routes/routes.dart';
import 'package:freud_ai/screens/Widgets/cliper.dart';
import 'package:freud_ai/screens/bmi/add-bmi/add_bmi.dart';
import 'package:freud_ai/screens/bmi/bloc/bmi_bloc.dart';
import 'package:freud_ai/screens/bmi/bloc/bmi_event.dart';
import 'package:freud_ai/screens/bmi/bloc/bmi_state.dart';
import 'package:freud_ai/screens/bmi/statistics/statistics_page.dart';
import 'package:freud_ai/screens/bmi/statistics/view/bmi_detail.dart';
import 'package:freud_ai/screens/bmi/views/bmi_item_view.dart';
import 'package:freud_ai/screens/personal_information/bloc/personal_bloc.dart';
import 'package:freud_ai/screens/personal_information/bloc/personal_event.dart';
import 'package:freud_ai/screens/personal_information/model/personal_information_model.dart';
import 'package:freud_ai/screens/questions/all_questions/gender_question.dart';
import 'package:lottie/lottie.dart';

class BMIPage extends StatelessWidget {
  const BMIPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bmiBloc = BlocProvider.of<BMIBloc>(context, listen: false);
    final personalInformationBloc = BlocProvider.of<PersonalInformationBloc>(
      context,
      listen: false,
    );

    bmiBloc.add(GetBMIEvent());

    return Scaffold(
      backgroundColor: AppTheme.cT!.whiteColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: BlocBuilder<BMIBloc, BMIState>(builder: (context, state) {
              return Column(
                children: [
                  Stack(
                    children: [
                      ClipPath(
                        clipper: ClipperClass(),
                        child: Container(
                          height: MediaQuery.sizeOf(context).height / 1.7.h,
                          width: MediaQuery.sizeOf(context).width,
                          color: AppTheme.cT!.brownColor,
                          child: Stack(
                            children: [
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width,
                                height: MediaQuery.sizeOf(context).height,
                                child: SvgPicture.asset(
                                  AssetsItems.bmiBackground,
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                              state.bmiModelList!.isEmpty
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Lottie.asset(AssetsItems.emptyBMIJson)
                                            .centralized(),
                                        20.height,
                                        CommonWidgets().makeDynamicText(
                                            text: "Click Button to add",
                                            size: 22,
                                            weight: FontWeight.w700,
                                            color: AppTheme.cT!.whiteColor)
                                      ],
                                    )
                                  : BmiCalculator(bmiState: state),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: CommonWidgets().ovalButton(
                            iconData: Icons.add,
                            callBack: () {
                              /// if condition
                              /// first check if isPersonalInformationSet tag is true or false
                              /// true mean: user set his/her information
                              /// false mean: user not set the personal information
                              ///
                              /// else if condition
                              /// suppose user set the personal info and skip to add the gender
                              ///
                              /// in both above cases user will navigate to select gender page then navigate to add bmi page
                              ///
                              /// else
                              ///
                              /// user will navigate the direct bmi page
                              ///
                              /// the purpose of this logic because of height selection page the image is show based on gender

                              /// if condition
                              if (Constants.completeAppInfoModel!
                                      .isPersonalInformationSet! ==
                                  false) {
                                Navigate.pushNamed(const GenderQuestion(
                                  isMale: true,
                                )).then((value) {
                                  if (value != null) {
                                    PersonalInformationModel
                                        personalInformation =
                                        PersonalInformationModel.initial();
                                    personalInformation =
                                        personalInformation.copyWith(
                                      id: 1,
                                      name: "",
                                      gender: value,
                                      dateOfBirth: "",
                                      dateOfBirthStamp: "",
                                    );

                                    context.read<PersonalInformationBloc>().add(
                                          PersonalInformationAddEvent(
                                            personalInformation,
                                          ),
                                        );

                                    Navigate.pushNamed(
                                      const AddBmiPage(initialPage: 0),
                                    );
                                  }
                                });

                                /// else if condition
                              } else if (personalInformationBloc.state
                                      .personalInformationModel!.gender! ==
                                  "gender") {
                                Navigate.pushNamed(const GenderQuestion(
                                  isMale: true,
                                )).then((value) {
                                  if (value != null) {
                                    PersonalInformationModel
                                        personalInformation =
                                        PersonalInformationModel.initial();
                                    personalInformation =
                                        personalInformation.copyWith(
                                      id: personalInformationBloc
                                          .state.personalInformationModel!.id,
                                      name: personalInformationBloc
                                          .state.personalInformationModel!.name,
                                      gender: value,
                                      dateOfBirth: personalInformationBloc
                                          .state
                                          .personalInformationModel!
                                          .dateOfBirth,
                                      dateOfBirthStamp: personalInformationBloc
                                          .state
                                          .personalInformationModel!
                                          .dateOfBirthStamp,
                                      selectedAvatar: personalInformationBloc
                                          .state
                                          .personalInformationModel!
                                          .selectedAvatar,
                                    );

                                    context
                                        .read<PersonalInformationBloc>()
                                        .add(PersonalInformationUpdateEvent(
                                          personalInformation,
                                        ));

                                    Navigate.pushNamed(
                                      const AddBmiPage(initialPage: 0),
                                    );
                                  }
                                });
                              } else {
                                Navigate.pushNamed(
                                  const AddBmiPage(initialPage: 0),
                                );
                              }
                            }),
                      ),
                    ],
                  ),
                  ScoreHistory(bmiState: state),
                ],
              );
            }),
          ),

          ///Mental Health BMi AppBar
          Padding(
            padding: EdgeInsets.only(left: 12.w, right: 12.w, top: 50.h),
            child: CommonWidgets().customAppBar(
              borderColor: AppTheme.cT!.whiteColor!,
              text: "BMI Score",
            ),
          ),
        ],
      ),
    );
  }
}

class BmiCalculator extends StatelessWidget {
  final BMIState bmiState;

  const BmiCalculator({
    super.key,
    required this.bmiState,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      bottom: 0,
      left: 0,
      right: 0,
      child: CommonWidgets()
          .makeDynamicTextSpan(
              text1:
                  '${bmiState.bmiModelList!.isNotEmpty ? bmiState.bmiModelList!.last.bmiScore : ""}\n',
              text2:
                  '${bmiState.bmiModelList!.isNotEmpty ? bmiState.bmiModelList!.last.bmiStatus : ""}',
              size1: 82,
              size2: 22,
              weight2: FontWeight.w400,
              weight1: FontWeight.bold,
              align: TextAlign.center,
              color1: AppTheme.cT!.whiteColor,
              color2: AppTheme.cT!.whiteColor)
          .centralized(),
    );
  }
}

class ScoreHistory extends StatelessWidget {
  final BMIState bmiState;

  const ScoreHistory({
    super.key,
    required this.bmiState,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        bmiState.bmiModelList!.isNotEmpty
            ? CommonWidgets().listViewAboveRow(
                context: context,
                text1: "BMI Score Overview",
                text2: "See All",
                callBack: () => Navigate.pushNamed(
                  const BMIStatisticsPage(),
                ),
              )
            : const SizedBox(),
        ListView.builder(
          itemCount: bmiState.bmiModelList!.length,
          shrinkWrap: true,
          reverse: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          itemBuilder: (context, index) {
            return BMIItemView(
              isFromMain: true,
              addBMIModel: bmiState.bmiModelList![index],
              onTap: () {
                Navigate.pushNamed(
                  BMIDetailView(
                    bmiModel: bmiState.bmiModelList![index],
                  ),
                );
              },
            );
          },
        )
      ],
    );
  }
}
