import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sample_project2/colors.dart';
import 'package:sample_project2/common/widgets/loader.dart';
import 'package:sample_project2/features/auth/controller/auth_controller.dart';
import 'package:sample_project2/features/auth/screens/edit_user_information.dart';
import 'package:sample_project2/features/auth/screens/full_profile_screen.dart';
import 'package:sample_project2/features/landing/landing_screen.dart';
import 'package:sample_project2/model/user_model.dart';
import 'package:sample_project2/widgets/about.dart';
import 'package:sample_project2/widgets/privacy_policy.dart';
import 'package:sample_project2/widgets/terms_and_condition.dart';

class ProfilePage extends ConsumerWidget {
  static const String routeName = '/Edit-screen';
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<UserModel?>(
      future: ref.read(authControllerProvider).getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Loader());
        }

        if (snapshot.hasError || snapshot.data == null) {
          return const Center(
              child: Text("Error fetching or no data available"));
        }

        final userData = snapshot.data!;

        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Colors.black, messageColor])),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 60.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ImageDisplayPage(
                                        imageUrl: userData.profilePic);
                                  },
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(40)),
                                border: Border.all(color: Colors.white),
                              ),
                              child: CircleAvatar(
                                backgroundColor: Colors.grey,
                                backgroundImage:
                                    NetworkImage(userData.profilePic),
                                radius: 40,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const EditUserInformation(),
                                ),
                              );
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.black,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                              ),
                              height: 30,
                              width: 70,
                              child: Center(
                                child:
                                    Text('Edit', style: GoogleFonts.aBeeZee()),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(userData.name,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(userData.phoneNumber,
                          style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.lock,
                  ),
                  title: const Text('Privacy Policy'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PrivacyPolicyPage()));
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.shield_rounded,
                  ),
                  title: const Text('Terms and Conditions'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TermsAndConditions()));
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.info_outline,
                  ),
                  title: const Text('About'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AboutPage()));
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.logout,
                    color: Colors.red,
                  ),
                  title: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          title: const Text(
                            'Sign Out',
                            style: TextStyle(color: Colors.red),
                          ),
                          content: const Text(
                              'This action will log you out from personal chats, group chats, etc.',
                              style: TextStyle(color: Colors.black)),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            Container(
                              width: 70,
                              height: 30,
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  gradient: LinearGradient(
                                      colors: [Colors.black, messageColor])),
                              child: TextButton(
                                child: const Center(child: Text('Yes',style: TextStyle(color: Colors.white))),
                                onPressed: () async {
                                  FirebaseAuth.instance.signOut();
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const LandingScreen(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.arrow_back,
                  ),
                  title: const Text('Back'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
