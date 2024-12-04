import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freud_ai/configs/helper/common.dart';
import 'package:freud_ai/configs/helper/screen_util.dart';
import 'package:freud_ai/configs/theme/app_theme.dart';
import 'package:freud_ai/routes/routes.dart';
import 'package:freud_ai/screens/authentication/signin/sign_in.dart';
import 'package:freud_ai/screens/Widgets/textfield/build_text_field.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
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
                  _buildPasswordConfirmView(),
                  30.height,
                  _buildSignInButton(),
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


  ///Password TextField
  Widget _buildPasswordConfirmView() {
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
    return CommonWidgets().customButton(
        text: "Sign up", showIcon: true, callBack: () => null);
  }

  _forgotPasswordAndSignupText() {
    return CommonWidgets().makeDynamicTextSpan(
        text1: "Already have an account ? ",
        text2: "Sign in.",
        size1: 16,
        showUnderLine2: true,
        showUnderLine3: true,
        onText2Click: ()=>handleSigninClickListener(),
        color1: AppTheme.cT!.greyColor,
        color2: AppTheme.cT!.orangeColor,
        color3: AppTheme.cT!.orangeColor,
        align: TextAlign.center);
  }



  ///SignUpPage
  handleSigninClickListener() {
    Navigate.pushNamed(const SignInPage());
  }

}



