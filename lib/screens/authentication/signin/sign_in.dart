import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/routes/routes.dart';
import 'package:freud_ai/screens/authentication/password/forgot_password.dart';
import 'package:freud_ai/screens/authentication/signup/signup.dart';
import 'package:freud_ai/screens/Widgets/textfield/build_text_field.dart';
import 'package:freud_ai/screens/main/main_screen.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Stack(
              children: [
                SvgPicture.asset("assets/signin/signin_bg.svg",
                    fit: BoxFit.cover),
                Positioned(
                  bottom: 15,
                  left: 0,
                  right: 0,
                  child: SvgPicture.asset("assets/signin/sign_in_logo.svg"),
                ),
              ],
            ),
            20.height,
            Padding(
              padding: EdgeInsets.all(15.w),
              child: Column(
                children: [
                  CommonWidgets().makeDynamicText(
                      text: "Sign In To freud.ai",
                      size: 28,
                      weight: FontWeight.bold,
                      align: TextAlign.center,
                      color: AppTheme.cT!.appColorDark),
                  30.height,
                  _buildEmailView(),
                  30.height,
                  _buildPasswordView(),
                  30.height,
                  _buildSignInButton(),
                  30.height,
                  socialLoginButtons(),
                  30.height,
                  _forgotPasswordAndSignupText()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  ///Email Textfield
  Widget _buildEmailView() {
    return CustomTextField(
      hintName: "waqas@gmail.com",
      headingName: "Email address",
      startIcon: "signin/email_ic.svg",
      endIcon: "signin/email_sufix.svg",
      controller: emailController,
      fieldType: "email",
    );
  }

  ///Password TextField
  Widget _buildPasswordView() {
    return CustomTextField(
      hintName: "***********",
      headingName: "Password",
      startIcon: "signin/lock.svg",
      endIcon: "signin/eye_ic.svg",
      controller: passwordController,
      fieldType: "password",
    );
  }

  ///Login Button
  Widget _buildSignInButton() {
    return CommonWidgets()
        .customButton(text: "Sign in", showIcon: true, callBack: () => handleSignInButton());
  }

  ///Social Login Button
  Widget socialLoginButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _socialButtonView("facebook.svg"),
        _socialButtonView("google.svg"),
        _socialButtonView("instagram.svg"),
      ],
    );
  }

  ///This is the dynamic view to show the Social Login
  Widget _socialButtonView(String iconName) {
    return Container(
      width: 50.w,
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 5.w),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.cT!.whiteColor,
          border: Border.all(width: 1.w, color: AppTheme.cT!.appColorLight!)),
      child: SizedBox(
          width: 24.w,
          height: 24.h,
          child: IconButton(
            icon: SvgPicture.asset("assets/signin/$iconName"),
            onPressed: () {},
          )),
    );
  }

  _forgotPasswordAndSignupText() {
    return CommonWidgets().makeDynamicTextSpan(
        text1: "Don t have an account ? ",
        text2: "Signup\n\n",
        text3: "Forgot Password",
        size1: 16,
        showUnderLine2: true,
        showUnderLine3: true,
        onText2Click: () => handleSignupClickListener(),
        onText3Click: () => handleForgotPassword(),
        color1: AppTheme.cT!.greyColor,
        color2: AppTheme.cT!.orangeColor,
        color3: AppTheme.cT!.orangeColor,
        align: TextAlign.center);
  }

  ///SignUpPage
  handleSignupClickListener() {
    Navigate.pushNamed(const SignupPage());
  }


  ///SignUpPage
  handleSignInButton() {
    Navigate.pushNamed(const MainScreen());
  }


  ///Forgot Password Click
  handleForgotPassword() {
    Navigate.pushNamed(const ForgotPasswordPage());
  }
}
