import 'package:flutter/material.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';

class OTPView extends StatefulWidget {
  const OTPView({super.key});

  @override
  State<OTPView> createState() => _OTPViewState();
}

class _OTPViewState extends State<OTPView> {
  late List<TextEditingController> controllers;

  @override
  void initState() {
    super.initState();
    controllers = List.generate(5, (index) => TextEditingController());
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        4,
        (index) => Container(
          width: 60.w,
          height: 100.h,
          decoration: BoxDecoration(
            color: AppTheme.cT!.whiteColor!,
            borderRadius: BorderRadius.circular(25.w),
            border: Border.all(color: AppTheme.cT!.whiteColor!, width: 2.w),
          ),
          child: Center(
            child: TextField(
              controller: controllers[index],
              keyboardType: TextInputType.number,
              maxLength: 1,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 32.w, color: Colors.black),
              decoration: const InputDecoration(
                counterText: "",
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(0),
                hintText: "",
              ),
              onChanged: (value) {
                if (value.isNotEmpty && index < 4) {
                  FocusScope.of(context).nextFocus();
                } else if (value.isEmpty && index > 0) {
                  FocusScope.of(context).previousFocus();
                }
              },
              onTap: () {
                setState(() {
                  // Set background to green when focused
                  controllers[index].text.isNotEmpty
                      ? Colors.green
                      : Colors.white;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
