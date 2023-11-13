import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sample_project2/colors.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Colors.black, messageColor]),
              ),
            ),
            Positioned(
              top: 20,
              left: 20, 
              child: IconButton(
                icon: const Icon(Icons.arrow_back,
                    color: Colors.white), 
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      "Terms & Conditions",
                      style: GoogleFonts.aBeeZee(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        "By downloading or using the app, these terms will automatically apply to you. Please read them carefully before using the app. You're not allowed to copy or modify the app, any part of the app, or our trademarks in any way. You're not allowed to attempt to extract the source code of the app or translate the app into other languages or make derivative versions. The app, trademarks, copyright, database rights, and other intellectual property rights still belong to us.",
                        style: GoogleFonts.aBeeZee(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      '- Created by Mohammed Ashik',
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/git.png',
                          height: 40,
                          width: 40,
                        ),
                        const SizedBox(width: 20),
                        Image.asset(
                          'assets/linkedin.png',
                          height: 37,
                          width: 37,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Center(
                      child: Row(
                        children: [
                          Text('For more information: '),
                          Text(
                            'aashiqabu1717@gmail.com',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
