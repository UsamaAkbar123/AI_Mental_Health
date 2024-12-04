import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/routes/routes.dart';
import 'package:freud_ai/screens/bmi/add-bmi/bmi_calculator.dart';
import 'package:freud_ai/screens/bmi/add-bmi/height_question.dart';
import 'package:freud_ai/screens/bmi/add-bmi/weight_question.dart';
import 'package:freud_ai/screens/bmi/bloc/bmi_bloc.dart';
import 'package:freud_ai/screens/bmi/bloc/bmi_event.dart';
import 'package:freud_ai/screens/bmi/model/bmi_model.dart';
import 'package:intl/intl.dart';

class AddBmiPage extends StatefulWidget {
  final int? initialPage;

  const AddBmiPage({super.key, this.initialPage});

  @override
  State<AddBmiPage> createState() => _AddBmiPageState();
}

class _AddBmiPageState extends State<AddBmiPage>{
  int? currentPage;
  PageController? pageController;
  List<Widget> pageList = [];
  AddBMIModel addBMIModel = AddBMIModel.initial();

  @override
  void initState() {
    super.initState();
    addListPages();
    currentPage = widget.initialPage!;
    pageController = PageController(initialPage: widget.initialPage!);
  }

  ///Add List Pages
  addListPages() {
    pageList.add(WeightQuestion(onWeightSelected: onWeightSelected));
    pageList.add(HeightQuestion(onHeightSelected: onHeightSelected));
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Column(
            children: [
              bmiAppBar(),
              20.height,
              pageView(),
            ],
          ),
          _continueQuestionsButton(),
        ],
      ),
    );
  }



  ///Add BMI
  bmiAppBar() {
    return Padding(
      padding: EdgeInsets.only(top: 45.h, left: 12.w, right: 12.w),
      child: CommonWidgets().customAppBar(
          callBack: () => animateThePrevPage(),
          borderColor: AppTheme.cT!.appColorLight!,
          text: currentPage == 0 ? "Weight" : "Height"),
    );
  }



  ///PageView
  Widget pageView() {
    return Expanded(
      child: SizedBox(
        child: PageView.builder(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          itemCount: pageList.length,
          onPageChanged: (int page) {
            ///
          },
          itemBuilder: (context, index) {
            return pageList[index];
          },
        ),
      ),
    );
  }



  ///Continue Button
  Widget _continueQuestionsButton() {
    return Positioned(
      bottom: 40.h,
      left: 12.w,
      right: 12.w,
      child: Padding(
        padding: EdgeInsets.only(
            bottom: Platform.isAndroid ? 12 : 0, left: 12, right: 12),
        child: CommonWidgets().customButton(
            text: "Continue",
            showIcon: true,
            callBack: () {
              if (currentPage! < 1) {
                animateTheNextPage();
              } else {
                calculateBMIMethod();
              }
            }),
      ),
    );
  }

  ///
  animateTheNextPage() {
    if (currentPage! < 1) {
      currentPage = currentPage! + 1;
      setState(() {
        pageController!.animateToPage(
          currentPage!,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    } else {
      Navigate.pop();
    }
  }

  ///
  animateThePrevPage() {
    if (currentPage! + 1 > 1) {
      currentPage = currentPage! - 1;
      setState(() {
        pageController!.animateToPage(currentPage!,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut);
      });
    } else {
      Navigate.pop();
    }
  }

  /// Callback function to receive weight value
  void onWeightSelected(Map<String, dynamic> map) {
    addBMIModel = addBMIModel.copyWith(
        bmiWeight: map['selectedWeight'], weightSymbol: map['selectedSymbol']);
  }

  /// Callback function to receive height value
  void onHeightSelected(Map<String, dynamic> map) {
    addBMIModel = addBMIModel.copyWith(
        bmiHeight: map['selectedHeight'], heightSymbol: map['selectedSymbol']);


    // print("printedValues1 :: ${map['selectedHeight']}");
    // print("printedValues2:: ${map['selectedSymbol']}");

  }

  ///
  void calculateBMIMethod() {
    BMICalculator calculator = BMICalculator();

    /// Retrieve weight and height values from addBMIModel
    double weight = double.parse(addBMIModel.bmiWeight!); // Assuming addBMIModel stores weight in lbs
    WeightUnit weightUnit =
        addBMIModel.weightSymbol == 'lbs' ? WeightUnit.lbs : WeightUnit.kg;

    /// Assuming height is stored in centimeters
    double height = double.parse(addBMIModel.bmiHeight!);



    HeightUnit heightUnit =
        addBMIModel.heightSymbol == 'feet' ? HeightUnit.feet : HeightUnit.cm;

    /// Calculate BMI
    Map<String, String> result = calculator.calculateBMI(
      weight: weight,
      weightUnit: weightUnit,
      height: height,
      heightUnit: heightUnit,
    );

    addBMIModel = addBMIModel.copyWith(
        bmiStatus: result["category"],
        bmiScore: result["bmi"],
        bmiTimeStamp: DateFormat('MM/dd/yyyy').format(DateTime.now()),
        dateBMI: DateFormat('MMM dd').format(DateTime.now()));

    BlocProvider.of<BMIBloc>(context).add(AddBMIEvent(addBMIModel));

    Navigate.pop();

    CommonWidgets().showSnackBar(context, "BMI Recorded Successfully");
  }


}
