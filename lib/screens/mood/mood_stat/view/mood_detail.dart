import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/configs/constants/assets.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/routes/routes.dart';
import 'package:freud_ai/screens/mood/bloc/mood_bloc.dart';
import 'package:freud_ai/screens/mood/bloc/mood_event.dart';
import 'package:freud_ai/screens/mood/model/mood_model.dart';
import 'package:intl/intl.dart';

class MoodDetailScreen extends StatefulWidget {
  final MoodModel moodModel;

  const MoodDetailScreen({
    super.key,
    required this.moodModel,
  });

  @override
  State<MoodDetailScreen> createState() => _MoodDetailScreenState();
}

class _MoodDetailScreenState extends State<MoodDetailScreen> {
  Map<String, dynamic> colorAndEmojiUrl = {};

  @override
  void initState() {
    colorAndEmojiUrl = getColorAndEmojiUrlBasedOnEmojiName(
      widget.moodModel.moodName ?? "",
    );
    super.initState();
  }

  Map<String, dynamic> getColorAndEmojiUrlBasedOnEmojiName(String emojiName) {
    switch (emojiName) {
      case "You were overjoyed":
        return {
          "color": AppTheme.cT!.greenColor ?? Colors.transparent,
          "emojiUrl": AssetsItems.overjoyedEmotionSvg,
        };
      case "You were depressed":
        return {
          "color": AppTheme.cT!.purpleColor ?? Colors.transparent,
          "emojiUrl": AssetsItems.depressedEmotionSvg,
        };

      case "You were sad":
        return {
          "color": AppTheme.cT!.orangeColor ?? Colors.transparent,
          "emojiUrl": AssetsItems.sadEmotionSvg,
        };

      case "You were neutral":
        return {
          "color": AppTheme.cT!.brownColor ?? Colors.transparent,
          "emojiUrl": AssetsItems.neutralEmotionSvg,
        };
      case "You were happy":
        return {
          "color": AppTheme.cT!.yellowColor ?? Colors.transparent,
          "emojiUrl": AssetsItems.happyEmotionSvg,
        };
      default:
        return {
          "color": AppTheme.cT!.yellowColor ?? Colors.transparent,
          "emojiUrl": AssetsItems.happyEmotionSvg,
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: ColoredBox(
              color: colorAndEmojiUrl["color"] ?? Colors.transparent,
              child: SvgPicture.asset(
                AssetsItems.moodDetailScreenBackground,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 50.h,
              left: 12.w,
              right: 12.w,
            ),
            child: CommonWidgets().customAppBar(
              text: DateFormat('MMMM d, yyyy').format(
                DateTime.parse(widget.moodModel.moodDate!),
              ),
              borderColor: AppTheme.cT!.whiteColor,
              actionWidget: GestureDetector(
                onTap: () async {
                  await CommonWidgets().customDialogBox(context).then(
                    (result) {
                      if (result != null) {
                        if (result == true) {
                          context.read<MoodBloc>().add(
                                DeleteMoodByIdEvent(
                                  moodId: widget.moodModel.moodTimeStamp ?? "",
                                ),
                              );

                          CommonWidgets().showSnackBar(
                            context,
                            "Mood Deleted Successfully",
                          );

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
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    colorAndEmojiUrl["emojiUrl"],
                    height: 160.h,
                    width: 160.h,
                  ),
                ),
                16.height,
                CommonWidgets().makeDynamicText(
                  text: widget.moodModel.moodQuotation,
                  color: AppTheme.cT!.whiteColor,
                  weight: FontWeight.w600,
                  size: 30,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
