import 'package:click_fare/Utils/resources/res/app_theme.dart';
import 'package:click_fare/Utils/widgets/others/app_field.dart';
import 'package:click_fare/Utils/widgets/others/app_text.dart';
import 'package:click_fare/View/auth/sign_in_screen.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    _phoneController.text = "+92";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.appText("Welcome to",
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        textColor: AppTheme.appColor),
                    AppText.appText("Click Fare!",
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        textColor: AppTheme.appColor),
                  ],
                ),
              ),
              AuthContainer(
                headingTxt: "Sign Up",
                HeadingTxt2: "Sign Up to your account",
                buttontext: "Sign Up",
                bottomText: "Already have an account?",
                bottomTxt2: "Sign in",
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40.0),
                  child: Column(
                    children: [
                      CustomAppFormField(
                          texthint: "Enter Name", controller: _nameController),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomAppFormField(
                          texthint: "Enter Phone", controller: _nameController),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomAppFormField(
                          texthint: "Enter Password", controller: _nameController),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomAppFormField(
                          texthint: "Confirm Password", controller: _nameController),
                   
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
