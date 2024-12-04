import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/extensions.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/routes/routes.dart';
import 'package:freud_ai/screens/mood/bloc/mood_bloc.dart';
import 'package:freud_ai/screens/mood/bloc/mood_event.dart';
import 'package:freud_ai/screens/mood/model/mood_model.dart';

class AddMoodPage extends StatefulWidget {
  const AddMoodPage({super.key});

  @override
  State<AddMoodPage> createState() => _AddMoodPageState();
}

class _AddMoodPageState extends State<AddMoodPage> {
  final List<String> emojis = [
    "assets/assessment/emoji4.svg",
    "assets/assessment/emoji5.svg",
    "assets/assessment/emoji1.svg",
    "assets/assessment/emoji2.svg",
    "assets/assessment/emoji3.svg",
  ];

  final List<String> emojiQuotations = [
    "Not distractible at all",
    "Highly distractible",
    "Very distractible",
    "Moderately distractible",
    "Slightly distractible",
  ];

  final List<String> emojiNames = [
    "You were overjoyed",
    "You were depressed",
    "You were sad",
    "You were neutral",
    "You were happy",
  ];

  final List<String> topEmojiList = [
    "assets/assessment/excelent.svg",
    "assets/assessment/worst.svg",
    "assets/assessment/poor.svg",
    "assets/assessment/sad_empoji.svg",
    "assets/assessment/good.svg",
  ];

  int selectedIndex = 0;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    setSelectedIndexBasedOnModeAdded();
    super.initState();
  }

  void _scrollToSelectedIndex() {
    if (selectedIndex != -1) {
      if(selectedIndex > 2){
        _scrollController.animateTo(
          selectedIndex * 100.0, // Adjust item width accordingly
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }

    }
  }

  void setSelectedIndexBasedOnModeAdded() {
    final modeBloc = BlocProvider.of<MoodBloc>(context);

    if (modeBloc.state.moodModelList!.isNotEmpty) {
      MoodModel? moodModel = modeBloc.state.moodModelList?.last;
      if (moodModel != null) {
        switch (moodModel.moodName) {
          case "You were overjoyed":
            selectedIndex = 0;
            break;
          case "You were depressed":
            selectedIndex = 1;
            break;
          case "You were sad":
            selectedIndex = 2;
            break;
          case "You were neutral":
            selectedIndex = 3;
            break;
          case "You were happy":
            selectedIndex = 4;
            break;
          default:
            selectedIndex = 0;
        }
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedIndex();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        child: Column(
          children: [
            60.height,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: CommonWidgets().customAppBar(),
            ),
            25.height,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  CommonWidgets().makeDynamicText(
                      text: "How you are\nfeeling today?",
                      size: 36,
                      align: TextAlign.center,
                      weight: FontWeight.w800,
                      color: AppTheme.cT!.appColorLight),
                  32.height,
                  CommonWidgets().makeDynamicText(
                      text: emojiQuotations[selectedIndex],
                      size: 18,
                      align: TextAlign.center,
                      color: AppTheme.cT!.greyColor),
                  24.height,
                  SvgPicture.asset(
                    width: 120.h,
                    height: 120.w,
                    topEmojiList[selectedIndex],
                    fit: BoxFit.fill,
                  ),
                  24.height,
                  SvgPicture.asset("assets/assessment/bottom_farwarded.svg"),
                ],
              ),
            ),
            32.height,
            emojisList(),
            const Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: CommonWidgets().customButton(
                  text: "Set Mood",
                  icon: "assets/common/tick.svg",
                  callBack: () => saveCurrentMood(),
                  showIcon: true),
            ),
            16.height,
          ],
        ),
      ),
    );
  }

  /// Bottom Emoji List
  Widget emojisList() {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: emojis.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              selectedIndex = index;

              setState(() => {});
            },
            child: Container(
              width: 138.0.w,
              height: 138.0.h,
              decoration: BoxDecoration(
                  border: selectedIndex == index
                      ? Border.all(
                        width: 1.5,
                        color: AppTheme.cT!.appColorLight!,
                      )
                    : null,
              ),
              child: SvgPicture.asset(
                emojis[index],
                width: 150.0,
                height: 120.0,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }


  ///Here we will define the User Mood and add it to the database
  saveCurrentMood() {

    final date = DateTime.now();
   // final newDate = date.add(const Duration(days: 16));

    MoodModel moodModel = MoodModel(
        moodTimeStamp: date.formatMMDD,
        moodDate: date.toString(),
        moodName: emojiNames[selectedIndex],
        moodEmoji: topEmojiList[selectedIndex],
        moodQuotation: emojiQuotations[selectedIndex],
    );

    BlocProvider.of<MoodBloc>(context).add(AddMoodEvent(moodModel: moodModel));

    CommonWidgets().showSnackBar(context, "Your Mood Recorded Successfully");

    Navigate.pop();

  }

}
