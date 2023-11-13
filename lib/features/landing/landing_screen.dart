import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sample_project2/colors.dart';
import 'package:sample_project2/widgets/privacy_policy.dart';

import '../../common/widgets/custom_button.dart';
import '../auth/screens/login_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});
  void navigateToLoginScreen(BuildContext context) {
    Navigator.pushNamed(context, LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            const Text(
              'Welcome to Flutio',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: size.height / 9),
            Lottie.asset(
              'animations/welcome.json',
              height: 350,
              width: 400,
            ),
            SizedBox(
              height: size.height / 9,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: <TextSpan>[
                    const TextSpan(
                      text:
                          'Read our Privacy Policy. Tap "Agree and continue" to accept the Terms of Service.',
                      style: TextStyle(color: greyColor),
                    ),
                    TextSpan(
                      text: ' Read',
                      style: const TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const PrivacyPolicyPage()));
                        },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
                width: size.width * 0.75,
                child: CustomButton(
                  onPressed: () => navigateToLoginScreen(context),
                  text: 'AGREE AND CONTINUE',
                ))
          ],
        )),
      ),
    );
  }
}
