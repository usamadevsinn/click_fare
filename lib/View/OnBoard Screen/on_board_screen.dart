import 'package:click_fare/Utils/resources/res/app_theme.dart';
import 'package:click_fare/Utils/utils.dart';
import 'package:click_fare/Utils/widgets/others/app_text.dart';
import 'package:click_fare/View/auth/sign_in_screen.dart';
import 'package:flutter/material.dart';

class OnBoardScreen extends StatefulWidget {
  const OnBoardScreen({super.key});

  @override
  State<OnBoardScreen> createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.appColor,
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0, bottom: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText.appText(
              "Click Fare",
              textColor: AppTheme.whiteColor,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  "assets/images/onboardCar.png",
                  height: 315,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SizedBox(
                    width: 200,
                    child: AppText.appText("Premium  Ride Affordable  Price",
                        textColor: AppTheme.whiteColor,
                        fontSize: 24,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                pushReplacement(context, const SignInScreen());
              },
              child: Image.asset(
                "assets/images/letsGo.png",
                height: 141,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
