import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:sample_project2/mobile_screen_layout.dart';

import 'colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MobileScreenLayout()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Colors.black, messageColor])),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Lottie.asset('animations/loader.json', width: 200, height: 200),
            const SizedBox(
              height: 250,
            ),
            Text(
              'Flutio ChatApp',
              style: GoogleFonts.aBeeZee(),
            ),
            const SizedBox(
              height: 50,
            )
          ],
        )),
      ),
    );
  }
}
