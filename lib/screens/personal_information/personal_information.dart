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
import 'package:freud_ai/screens/personal_information/bloc/personal_bloc.dart';
import 'package:freud_ai/screens/personal_information/bloc/personal_event.dart';
import 'package:freud_ai/screens/personal_information/model/personal_information_model.dart';
import 'package:freud_ai/screens/personal_information/view/custom_profile_picture_widget.dart';
import 'package:freud_ai/screens/questions/all_questions/gender_question.dart';
import 'package:intl/intl.dart';

class PersonalInformation extends StatefulWidget {
  final bool? showBackButton;

  const PersonalInformation({super.key, this.showBackButton});

  @override
  State<PersonalInformation> createState() => _PersonalInformationState();
}

class _PersonalInformationState extends State<PersonalInformation>
    with AutomaticKeepAliveClientMixin {

  List<String> profileAvatarLogos = [
    AssetsItems.profileAvatar1,
    AssetsItems.profileAvatar2,
    AssetsItems.profileAvatar3,
    AssetsItems.profileAvatar4,
  ];

  String? selectedAvatar;
  int selectedIndex = -1;

  DateTime? _selectedDate;
  String genderText = "gender";
  String dateOfBirthText = "date of birth";
  TextEditingController nameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();

  PersonalInformationModel personalInformationModel =
      PersonalInformationModel();
  PersonalInformationBloc? personalInformationBloc;

  @override
  void initState() {
    super.initState();
    personalInformationBloc = context.read<PersonalInformationBloc>();

    setPreviouslySetData();
  }

  setPreviouslySetData() {
    if (Constants.completeAppInfoModel!.isPersonalInformationSet!) {
      /// set the gender from database
      genderText =
          personalInformationBloc!.state.personalInformationModel!.gender!;

      /// set date of birth from database
      dateOfBirthText =
          personalInformationBloc!.state.personalInformationModel!.dateOfBirth!;

      /// set name from database
      if (personalInformationBloc!
          .state.personalInformationModel!.name!.isNotEmpty) {
        nameController.text =
            personalInformationBloc!.state.personalInformationModel!.name!;
      }

      /// set selected date from database
      if (personalInformationBloc!
                  .state.personalInformationModel!.dateOfBirthStamp !=
              "null" &&
          personalInformationBloc!
              .state.personalInformationModel!.dateOfBirthStamp!.isNotEmpty) {
        _selectedDate = DateFormat('d MMMM yyyy').parse(personalInformationBloc!
            .state.personalInformationModel!.dateOfBirth!);
      }
    }

    /// set the selected avatar
    if (personalInformationBloc
            ?.state.personalInformationModel?.selectedAvatar !=
        "") {
      selectedAvatar = personalInformationBloc
          ?.state.personalInformationModel?.selectedAvatar;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 50.h, left: 12.w, right: 12.w),
              child: CommonWidgets().customAppBar(
                  borderColor: AppTheme.cT!.appColorLight,
                  showBackButton: widget.showBackButton,
                  text: "Personal Information"),
            ),
            32.height,
            SizedBox(
              height: MediaQuery.sizeOf(context).height / 10.h,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /*profilePicture(),
                CommonWidgets().makeDynamicText(
                    text: "OR",
                    size: 16,
                    weight: FontWeight.w700,
                    align: TextAlign.center,
                    color: AppTheme.cT!.appColorDark),
                6.width,*/
                  12.width,
                  Expanded(
                    child: ListView.builder(
                      itemCount: profileAvatarLogos.length,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return CustomProfilePictureWidget(
                          profileAvatar: profileAvatarLogos[index],
                          isAvatarSelected: selectedAvatar != null
                              ? profileAvatarLogos[index]
                                  .contains(selectedAvatar!)
                              : selectedIndex == index,
                          onTap: () {
                            setState(
                              () {
                                selectedIndex = index;
                                selectedAvatar =
                                    profileAvatarLogos[selectedIndex];
                              },
                            );
                          },
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
            28.height,
            userDataCollectionFields(),
          ],
        ),
      ).clickListener(
        click: () => CommonWidgets().hideSoftInputKeyboard(context),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: 30.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        child: CommonWidgets().customButton(
          text: "Save Settings",
          icon: AssetsItems.tick,
          showIcon: true,
          callBack: () => collectDateAndSavedToDatabase(),
        ),
      ),
    );
  }

  ///User Data collection Fields
  Widget userDataCollectionFields() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              nameTextField(),
              32.height,
              dateOfBirthPicker(),
              32.height,
              genderField(),
              /*CustomTextField(
                headingName: 'Gender',
                startIcon: AssetsItems.bulb,
                endIcon: "common/arrow_down.svg",
                hintName: "john@gmail.com",
              ),*/
              32.height,
              /*CommonWidgets().makeDynamicText(
                  text: 'Weight',
                  size: 14,
                  weight: FontWeight.w600,
                  color: AppTheme.cT!.appColorLight),*/
            ],
          ),
        ),
        /*       SfSlider(
          min: 0.0,
          max: 300.0,
          value: _value,
          interval: 100,
          showTicks: true,
          showLabels: true,
          enableTooltip: true,
          activeColor: AppTheme.cT!.greenColor,
          minorTicksPerInterval: 1,
          onChanged: (dynamic value) {
            setState(() {
              _value = value;
            });
          },
        ),*/
      ],
    );
  }

  ///Gender Field
  Widget genderField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonWidgets().makeDynamicText(
            text: "Gender",
            size: 14,
            weight: FontWeight.w800,
            color: AppTheme.cT!.appColorLight),
        10.height,
        Container(
          decoration: BoxDecoration(
              color: AppTheme.cT!.whiteColor,
              borderRadius: BorderRadius.circular(32.w)),
          child: Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: SizedBox(
                  height: 24.h,
                  width: 24.w,
                  child: SvgPicture.asset(AssetsItems.bulb),
                ),
              ),
              CommonWidgets().makeDynamicText(
                  text: genderText,
                  size: 18,
                  color: genderText == "gender"
                      ? AppTheme.cT!.lightGrey
                      : AppTheme.cT!.appColorLight),
            ],
          ),
        ).clickListener(click: () {
          CommonWidgets().hideSoftInputKeyboard(context);
          Navigate.pushNamed(GenderQuestion(
            isMale: genderText == "Female" ? false : true,
          )).then((value) {
            if (value != null) {
              genderText = value;
              setState(() {});
            }
          });
        })
      ],
    );
  }

  ///Gender Field
  Widget dateOfBirthPicker() {
    /*print(" personalInformationModel.dateOfBirth :: ${personalInformationModel.dateOfBirth}");

    dateOfBirthText = personalInformationModel.dateOfBirth!.isNotEmpty
        ? personalInformationModel.dateOfBirth!
        : "date if birth";

    if (personalInformationModel.dateOfBirthStamp!.isNotEmpty) {
      _selectedDate =
          DateTime.parse(personalInformationModel.dateOfBirthStamp!);
    }
*/
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonWidgets().makeDynamicText(
            text: "Date of Birth",
            size: 14,
            weight: FontWeight.w800,
            color: AppTheme.cT!.appColorLight),
        10.height,
        Container(
          decoration: BoxDecoration(
              color: AppTheme.cT!.whiteColor,
              borderRadius: BorderRadius.circular(32.w)),
          child: Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: SizedBox(
                  height: 24.h,
                  width: 24.w,
                  child: SvgPicture.asset(AssetsItems.calenderBMI),
                ),
              ),
              CommonWidgets().makeDynamicText(
                  text: dateOfBirthText,
                  size: 18,
                  color: dateOfBirthText == "date of birth"
                      ? AppTheme.cT!.lightGrey
                      : AppTheme.cT!.appColorLight),
            ],
          ),
        ).clickListener(click: () {
          CommonWidgets().hideSoftInputKeyboard(context);
          _selectDate();
        })
      ],
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900, 1, 1),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        dateOfBirthText = DateFormat('d MMMM yyyy').format(_selectedDate!);

      });
    }
  }

  ///
  collectDateAndSavedToDatabase() {
    if (nameController.text.isNotEmpty) {
      PersonalInformationModel personalInformation =
          PersonalInformationModel.initial();

      personalInformation = personalInformation.copyWith(
          id: 1,
          name: nameController.text.trim(),
          gender: genderText,
          dateOfBirth: dateOfBirthText,
          dateOfBirthStamp: _selectedDate.toString(),
          selectedAvatar: selectedAvatar);

      if (Constants.completeAppInfoModel!.isPersonalInformationSet!) {
        personalInformationBloc!
            .add(PersonalInformationUpdateEvent(personalInformation));
      } else {
        personalInformationBloc!
            .add(PersonalInformationAddEvent(personalInformation));
      }

      BlocProvider.of<PersonalInformationBloc>(context)
          .add(PersonalInformationGetEvent());

      CommonWidgets().showSnackBar(context, "Personal Information updated");
    } else {
      CommonWidgets().showSnackBar(context, "Name Required");
    }
  }

  ///Name TextField
  Widget nameTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonWidgets().makeDynamicText(
            text: "Name",
            size: 14,
            weight: FontWeight.w800,
            color: AppTheme.cT!.appColorLight),
        12.height,
        Container(
          height: 52.h,
          alignment: Alignment.center,
          decoration: ShapeDecoration(
            color: AppTheme.cT!.whiteColor,
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1.w, color: AppTheme.cT!.whiteColor!),
              borderRadius: BorderRadius.circular(26.w),
            ),
          ),
          child: TextField(
            maxLines: 1,
            controller: nameController,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Name",
                hintStyle: TextStyle(
                    color: AppTheme.cT!.lightGrey,
                    fontWeight: FontWeight.normal),
                prefixIcon: IconButton(
                    onPressed: () {},
                    icon: SizedBox(
                        height: 24.h,
                        width: 24.w,
                        child: SvgPicture.asset(AssetsItems.person))),
                contentPadding: EdgeInsets.only(top: 10.h)),
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
