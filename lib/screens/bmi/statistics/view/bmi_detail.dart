import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/extensions.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/routes/routes.dart';
import 'package:freud_ai/screens/bmi/bloc/bmi_bloc.dart';
import 'package:freud_ai/screens/bmi/bloc/bmi_event.dart';
import 'package:freud_ai/screens/bmi/model/bmi_model.dart';
import 'package:freud_ai/screens/bmi/statistics/view/bmi_detail_itemview.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BMIDetailView extends StatefulWidget {
  final AddBMIModel bmiModel;

  const BMIDetailView({
    super.key,
    required this.bmiModel,
  });

  @override
  State<BMIDetailView> createState() => _BMIDetailViewState();
}

class _BMIDetailViewState extends State<BMIDetailView>
    with TickerProviderStateMixin {
  List<BMIDetailModel> bmiDetailList = [];

  final List<ChartData> chartData = [];

  late AnimationController _controller;
  late Animation<double> animation;

  String bmiValue = "";
  String bmiStatus = "";
  double bmiMaxValue = 50;

  @override
  void initState() {
    super.initState();

    // final bmiData = BlocProvider.of<BMIBloc>(context, listen: false)
    //     .state
    //     .bmiModelList!
    //     .last;

    bmiValue = widget.bmiModel.bmiScore!;
    bmiStatus = widget.bmiModel.bmiStatus!;

    if(double.parse(bmiValue) > bmiMaxValue){
      bmiMaxValue = double.parse(bmiValue);
    }

    bmiChartCalculation();

    bmiDetailList.add(BMIDetailModel(
        text1: "Underweight",
        text2: "",
        text3: "< 18.5",
        color: AppTheme.cT!.yellowColor));
    bmiDetailList.add(BMIDetailModel(
        text1: "Normal",
        text2: "18.5 to ",
        text3: "24.9",
        color: AppTheme.cT!.purpleColor));
    bmiDetailList.add(BMIDetailModel(
        text1: "Overweight",
        text2: "25 to ",
        text3: "29.9",
        color: AppTheme.cT!.orangeColor));
    bmiDetailList.add(BMIDetailModel(
        text1: "Obesity - class 1",
        text2: "30 to ",
        text3: "34.9",
        color: AppTheme.cT!.greenColor));
    bmiDetailList.add(BMIDetailModel(
        text1: "Obesity - class 2",
        text2: "35 to ",
        text3: "39.9 ",
        color: AppTheme.cT!.greyColor));
    bmiDetailList.add(BMIDetailModel(
        text1: "Obesity - class 3",
        text2: "40 ",
        text3: ">",
        color: AppTheme.cT!.appColorLight));


    // Define animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Adjust duration as needed
    );

    // Define animation curve (you can customize this)
    final CurvedAnimation curve =
    CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    // Define rotation animation
    animation = Tween<double>(begin: 0, end: 360).animate(curve);

    // Start the animation when the screen is opened
    _controller.forward();



  }

  /// bmi chart calculation
  void bmiChartCalculation() {
    Map<String, dynamic> mapResult = {};
    mapResult = mainBmiValuePercentage();
    chartData.add(
      ChartData('Normal', mapResult["percentageValue"], mapResult["color"]),
    );
    remainingBmiCalculation();
  }

  /// remaining bmi calculation
  void remainingBmiCalculation() {
    if (bmiStatus == 'Underweight') {
      chartData.add(ChartData('Obesity', remainingBmiPercentageCalculation(),
          AppTheme.cT!.greenColor));
      chartData.add(ChartData('Normal weight',
          remainingBmiPercentageCalculation(), AppTheme.cT!.purpleColor));
      chartData.add(ChartData('Overweight', remainingBmiPercentageCalculation(),
          AppTheme.cT!.orangeColor));
      chartData.add(ChartData('Other', remainingBmiPercentageCalculation(),
          AppTheme.cT!.appColorLight));
    }

    if (bmiStatus == 'Normal weight') {
      chartData.add(ChartData('Obesity', remainingBmiPercentageCalculation(),
          AppTheme.cT!.greenColor));
      chartData.add(ChartData('Underweight',
          remainingBmiPercentageCalculation(), AppTheme.cT!.yellowColor));
      chartData.add(ChartData('Overweight', remainingBmiPercentageCalculation(),
          AppTheme.cT!.orangeColor));
      chartData.add(ChartData('Other', remainingBmiPercentageCalculation(),
          AppTheme.cT!.appColorLight));
    }

    if (bmiStatus == 'Overweight') {
      chartData.add(ChartData('Obesity', remainingBmiPercentageCalculation(),
          AppTheme.cT!.greenColor));
      chartData.add(ChartData('Underweight',
          remainingBmiPercentageCalculation(), AppTheme.cT!.yellowColor));
      chartData.add(ChartData('Normal weight',
          remainingBmiPercentageCalculation(), AppTheme.cT!.purpleColor));
      chartData.add(ChartData('Other', remainingBmiPercentageCalculation(),
          AppTheme.cT!.appColorLight));
    }

    if (bmiStatus == 'Obesity') {
      chartData.add(ChartData('Overweight', remainingBmiPercentageCalculation(),
          AppTheme.cT!.orangeColor));
      chartData.add(ChartData('Underweight',
          remainingBmiPercentageCalculation(), AppTheme.cT!.yellowColor));
      chartData.add(ChartData('Normal weight',
          remainingBmiPercentageCalculation(), AppTheme.cT!.purpleColor));
      chartData.add(ChartData('Other', remainingBmiPercentageCalculation(),
          AppTheme.cT!.appColorLight));
    }
  }

  /// remaining bmi percentage calculation formula
  double remainingBmiPercentageCalculation() {
    /// first minus bmi value from max value
    double afterMinusValue = bmiMaxValue - double.parse(bmiValue);

    /// then davide [afterMinusValue] with 4
    double eachValue = afterMinusValue / 4;

    /// then calculate the remaining bmi percentage
    return (eachValue / bmiMaxValue) * 100;
  }

  /// calculate the main bmi category percentage value and color
  Map<String, dynamic> mainBmiValuePercentage() {
    switch (bmiStatus) {
      case 'Underweight':
        return {
          "color": AppTheme.cT!.yellowColor,
          "percentageValue": calculateMainBmiPercentage(),
        };
      case 'Normal weight':
        return {
          "color": AppTheme.cT!.purpleColor,
          "percentageValue": calculateMainBmiPercentage(),
        };
      case 'Overweight':
        return {
          "color": AppTheme.cT!.orangeColor,
          "percentageValue": calculateMainBmiPercentage(),
        };
      case 'Obesity':
        return {
          "color": AppTheme.cT!.greenColor,
          "percentageValue": calculateMainBmiPercentage(),
        };
      default:
        return {
          "color": AppTheme.cT!.yellowColor,
          "percentageValue": calculateMainBmiPercentage(),
        };
    }
  }

  /// percentage formula
  double calculateMainBmiPercentage() {
    return (double.parse(bmiValue) / bmiMaxValue) * 100;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 12.w),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              55.height,
              CommonWidgets().customAppBar(
                  borderColor: AppTheme.cT!.appColorLight!,
                text: "BMI Statistics",
                actionWidget: GestureDetector(
                  onTap: () async {
                    await CommonWidgets()
                        .customDialogBox(context)
                        .then((result) {
                      if (result != null) {
                        if (result == true) {
                          context.read<BMIBloc>().add(
                                  DeleteBMIEvent(
                                    widget.bmiModel.bmiTimeStamp!,
                                  ),
                                );

                            CommonWidgets().showSnackBar(context, "BMI Deleted Successfully");

                            Navigate.pop();
                          }
                      }
                      },
                    );
                  },
                  child: CommonWidgets().makeDynamicText(
                      size: 16,
                      weight: FontWeight.bold,
                      text: "Delete",
                      color: AppTheme.cT!.redColor),
                ),
              ),
              SizedBox(
                height: 300.h,
                child: Stack(
                  children: [
                    SfCircularChart(
                      series: <CircularSeries>[
                        // Render pie chart
                        PieSeries<ChartData, String>(
                            dataSource: chartData,
                            pointColorMapper: (ChartData data, _) => data.color,
                            xValueMapper: (ChartData data, _) => data.x,
                            yValueMapper: (ChartData data, _) => data.y)
                      ],
                    ),
                    Container(
                      width: 120.w,
                      height: 120,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.cT!.whiteColor),
                      child: CommonWidgets().makeDynamicTextSpan(
                          text1: "$bmiValue\n",
                          size1: 32,
                          text2: bmiStatus,
                          size2: 18,
                          align: TextAlign.center,
                          weight1: FontWeight.bold,
                          weight2: FontWeight.w600,
                          color2: AppTheme.cT!.appColorLight,
                          color1: AppTheme.cT!.appColorLight),
                    ).centralized()
                  ],
                ),
              ),
              20.height,
              ListView.builder(
                itemCount: bmiDetailList.length,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return BMIDetailItemView(
                    bmiDetailModel: bmiDetailList[index],
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}


class BMIDetailModel {
  String? text1;
  String? text2;
  String? text3;
  Color? color;

  BMIDetailModel({this.text1, this.text2, this.text3, this.color});
}


class ChartData {
  ChartData(this.x, this.y, [this.color]);

  final String x;
  final double y;
  final Color? color;
}
