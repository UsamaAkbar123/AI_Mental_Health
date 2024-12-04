import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/extensions.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/routes/routes.dart';
import 'package:lottie/lottie.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechToTextPage extends StatefulWidget {
  const SpeechToTextPage({super.key});

  @override
  State<SpeechToTextPage> createState() => _SpeechToTextPageState();
}

class _SpeechToTextPageState extends State<SpeechToTextPage> {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.sizeOf(context).height,
        child: Stack(
          children: [
            Positioned(
              left: -280.w,
              top: MediaQuery.sizeOf(context).height / 1.3,
              child: CommonWidgets().roundShapeCircle(),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: MediaQuery.sizeOf(context).height / 1.3 - 50,
              child: Container(
                width: 100.w,
                height: 100.h,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.cT!.appColorLight,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.cT!.brownShadow!,
                      blurRadius: 0,
                      offset: const Offset(0, 0),
                      spreadRadius: 4.w,
                    )
                  ],
                ),
                child: SvgPicture.asset("assets/common/mic.svg",
                  colorFilter: ColorFilter.mode(
                    AppTheme.cT!.whiteColor ?? Colors.transparent,
                    BlendMode.srcIn,
                  ),
                ),
              ).clickListener(
                  click: _speechToText.isNotListening
                      ? _startListening
                      : _stopListening),
            ),
            Positioned(
              top: MediaQuery.sizeOf(context).height / 1.2 + 20,
              child: SizedBox(
                width: MediaQuery.sizeOf(context).width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    actionContainer(
                        color: AppTheme.cT!.lightBrownColor,
                        icon: "common/cross.svg",
                        iconColor: AppTheme.cT!.brownColor50),
                    CommonWidgets().makeDynamicText(
                        text: _speechToText.isListening
                            ? _lastWords
                            // If listening isn't active but could be tell the user
                            // how to start it, otherwise indicate that speech
                            // recognition is not yet ready or not supported on
                            // the target device
                            : _speechEnabled
                                ? 'Tap the microphone to start listening...'
                                : 'Speech not available',
                        color: AppTheme.cT!.appColorLight,
                        size: 18),
                    actionContainer(
                        color: AppTheme.cT!.lightBrownColor,
                        icon: "common/tick.svg",
                        iconColor: AppTheme.cT!.brownColor50),
                  ],
                ),
              ),
            ),
            textToSpeechIllustration(),
            Positioned(
                top: 50,
                left: 12,
                child: CommonWidgets()
                    .backButton(backButton: () => Navigate.pop())),
          ],
        ),
      ),
    );
  }

  ///Illustration and Text
  Widget textToSpeechIllustration() {
    return Column(
      children: [
        50.height,
        Lottie.asset("assets/ai/text_to_speech.json"),
        CommonWidgets().makeDynamicText(
          text: "Say anything that’s\non your mind.",
          color: AppTheme.cT!.appColorLight,
          align: TextAlign.center,
          weight: FontWeight.w700,
          size: 32,
        ),
        15.height,
        CommonWidgets().makeDynamicText(
          text: "Dr. freud AI will listen and analyze your\nvoice expression.",
          color: AppTheme.cT!.greyColor,
          align: TextAlign.center,
          weight: FontWeight.w400,
          size: 14,
        ),
      ],
    );
  }

  ///Action Container
  Widget actionContainer({color, icon, iconColor}) {
    return GestureDetector(
      child: Container(
        width: 40.w,
        height: 40.h,
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(
          "assets/$icon",
          colorFilter: ColorFilter.mode(
            iconColor ?? Colors.transparent,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
