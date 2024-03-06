import 'package:click_fare/Utils/resources/res/app_theme.dart';
import 'package:click_fare/Utils/utils.dart';
import 'package:click_fare/Utils/widgets/others/app_button.dart';
import 'package:click_fare/Utils/widgets/others/app_field.dart';
import 'package:click_fare/Utils/widgets/others/app_text.dart';
import 'package:click_fare/View/auth/sign_up_screen.dart';
import 'package:click_fare/View/root_screen.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Future<void> signInWithEmailAndPassword(
      {String? email, String? password}) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email!,
        password: password!,
      );
      pushUntil(context, const RootScreen());
    } catch (e) {
      print("Error occurred: $e");
      // Explicitly specify the type of the exception object
      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          print('No user found with this email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for this user.');
        } else {
          showSnackBar(context, "Credential is incorrect");
        }
      } else {
        print('An unexpected error occurred: $e');
      }
    }
  }

  @override
  void initState() {
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
                headingTxt: "Sign In",
                HeadingTxt2: "Sign in to your account",
                buttontext: "Sign In",
                bottomText: "Don't have an account?",
                bottomTxt2: "Sign Up",
                buttonOntap: () {
                  if (_emailController.text.isNotEmpty) {
                    if (_passwordController.text.isNotEmpty) {
                      signInWithEmailAndPassword(
                          email: _emailController.text,
                          password: _passwordController.text);
                    } else {
                      showSnackBar(context, "Enter Password");
                    }
                  } else {
                    showSnackBar(context, "Enter email");
                  }
                },
                ontap: () {
                  push(context, const SignUpScreen());
                },
                child: Column(
                  children: [
                    CustomAppFormField(
                        texthint: "Enter Email", controller: _emailController),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomAppPasswordfield(
                        texthint: "Password", controller: _passwordController)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget phoneField({controller}) {
    String initialCountry = "pk";
    return Container(
      decoration: BoxDecoration(
          color: AppTheme.appColor,
          border: Border.all(color: const Color(0xffE5E9EB)),
          borderRadius: BorderRadius.circular(8)),
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          CountryListPick(
            onChanged: (CountryCode? countryCode) {
              controller.text = countryCode?.dialCode ?? '';
            },
            theme: CountryTheme(
                isShowFlag: true,
                showEnglishName: true,
                isShowTitle: false,
                isShowCode: false,
                isDownIcon: false),
            initialSelection: initialCountry,
            useUiOverlay: false,
            useSafeArea: false,
          ),
          Expanded(
            child: TextFormField(
              style: TextStyle(color: AppTheme.whiteColor),
              cursorColor: AppTheme.appColor,
              cursorHeight: 25,
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(),
              decoration: InputDecoration(
                  fillColor: AppTheme.whiteColor,
                  focusedBorder: InputBorder.none,
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  enabledBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.only(bottom: 4)),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthContainer extends StatefulWidget {
  final child;
  final headingTxt;
  final HeadingTxt2;
  final bottomText;
  final bottomTxt2;
  final buttontext;
  final buttonOntap;
  final ontap;

  const AuthContainer(
      {super.key,
      this.child,
      this.headingTxt,
      this.HeadingTxt2,
      this.bottomText,
      this.bottomTxt2,
      this.buttontext,
      this.buttonOntap,
      this.ontap});

  @override
  State<AuthContainer> createState() => _AuthContainerState();
}

class _AuthContainerState extends State<AuthContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - 150,
      decoration: BoxDecoration(
          color: AppTheme.primary,
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(300), topLeft: Radius.circular(0))),
      child: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: AppTheme.appColor,
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(300), topLeft: Radius.circular(0))),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.appText("${widget.headingTxt}",
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                          textColor: AppTheme.whiteColor),
                      AppText.appText("${widget.HeadingTxt2}",
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                          textColor: AppTheme.whiteColor),
                    ],
                  ),
                ),
                Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    child: widget.child),
                AppButton.appButton("${widget.buttontext}",
                    backgroundColor: AppTheme.primary,
                    onTap: widget.buttonOntap,
                    textColor: AppTheme.whiteColor,
                    height: 40,
                    width: 100,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
                GestureDetector(
                  onTap: widget.ontap,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText.appText("${widget.bottomText}  ",
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          textColor: AppTheme.whiteColor),
                      AppText.appText("${widget.bottomTxt2}",
                          fontSize: 12,
                          underLine: true,
                          fontWeight: FontWeight.w500,
                          textColor: AppTheme.primary),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
