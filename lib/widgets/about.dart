import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sample_project2/colors.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Colors.black, messageColor]),
            ),
          ),
          Positioned(
            top: 40,
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 80),
                const Text(
                  'Flutio ChatApp',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Text(
                    'Flutio ChatApp is a complete chat application designed for seamless communication worldwide. You can chat with your connections, share messages, and connect with people from around the globe.',
                    style: GoogleFonts.aBeeZee(),
                    textAlign: TextAlign.center,
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
