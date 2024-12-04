import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/screens/languages/model/language_model.dart';
import 'package:freud_ai/screens/languages/view/languages_item_view.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  LanguageModel languageModel =
      LanguageModel(languageName: "English (US)", isSelected: true);

  List<LanguageModel> languageList = [
    LanguageModel(languageName: "English (US)", isSelected: false),
    LanguageModel(languageName: "English (UK)", isSelected: false),
    LanguageModel(languageName: "French", isSelected: false),
    LanguageModel(languageName: "German", isSelected: false),
    LanguageModel(languageName: "Japanese", isSelected: false),
    LanguageModel(languageName: "Korean", isSelected: false),
    LanguageModel(languageName: "Portuguese", isSelected: false),
    LanguageModel(languageName: "Spanish", isSelected: false),
    LanguageModel(languageName: "Arabic", isSelected: false),
    LanguageModel(languageName: "Italian", isSelected: false),
    LanguageModel(languageName: "Russian", isSelected: false),
    LanguageModel(languageName: "Thai", isSelected: false),
    LanguageModel(languageName: "Turkish", isSelected: false),
    LanguageModel(languageName: "Vietnamese", isSelected: false),
    LanguageModel(languageName: "Indian", isSelected: false),
    LanguageModel(languageName: "Dutch", isSelected: false),
    LanguageModel(languageName: "Indonesian", isSelected: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          50.height,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: CommonWidgets().customAppBar(text: "Languages"),
          ),
          32.height,

          ///===================== Headings =================

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: CommonWidgets().makeDynamicText(
                      text: "Selected Languages",
                      size: 16,
                      weight: FontWeight.w800,
                      color: AppTheme.cT!.appColorLight),
                ),
                12.height,

                ///===================== Item =================

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: LanguagesItemView(languageModel: languageModel),
                ),

                ///===================== Headings =================

                32.height,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: CommonWidgets().makeDynamicText(
                      text: "Selected Languages",
                      size: 16,
                      weight: FontWeight.w800,
                      color: AppTheme.cT!.appColorLight),
                ),
                12.height,

                ///===================== List of Languages =================

                Expanded(
                  child: AnimationLimiter(
                    child: ListView.builder(
                      itemCount: languageList.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 800),
                          child: SlideAnimation(
                            horizontalOffset: 20,
                            curve: Curves.easeInOut,
                            duration: const Duration(milliseconds: 800),
                            child: FadeInAnimation(
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 12.h),
                                child: LanguagesItemView(
                                  languageModel: languageList[index],
                                  languageList: languageList,
                                  updateList: (languageModelCallBack) {
                                    setState(() {
                                      languageModel = languageModelCallBack;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                50.height,
              ],
            ),
          )
        ],
      ),
    );
  }
}
