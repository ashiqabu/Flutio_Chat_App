import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sample_project2/colors.dart';
import 'package:sample_project2/common/widgets/loader.dart';
import 'package:sample_project2/common/widgets/utils/utils.dart';
import 'package:sample_project2/features/auth/controller/auth_controller.dart';
import 'package:sample_project2/model/user_model.dart';

class EditUserInformation extends ConsumerStatefulWidget {
  static const String routeName = '/user-information';
  const EditUserInformation({super.key});

  @override
  ConsumerState<EditUserInformation> createState() =>
      _EditUserInformationState();
}

class _EditUserInformationState extends ConsumerState<EditUserInformation> {
  final TextEditingController namesController = TextEditingController();
  File? image;
  bool isLoading = true;
  UserModel? userData;

  @override
  void dispose() {
    super.dispose();
    namesController.dispose();
  }

  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  void updateUserData() async {
    String name = namesController.text.trim();
    if (name.isNotEmpty) {
      ref
          .read(authControllerProvider)
          .saveUserDataToFirebase(context, name, image);
    }
  }

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  void loadUserData() async {
    try {
      final loadedUserData =
          await ref.read(authControllerProvider).getUserData();
      if (loadedUserData != null) {
        namesController.text = loadedUserData.name;
        setState(() {
          userData = loadedUserData;
          isLoading = false;
        });
      }
    } catch (error) {
      // print("Error fetching data: $error");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text('Edit your Information'),
          centerTitle: true,
        ),
        body: isLoading
            ? const Loader()
            : SingleChildScrollView(
                child: SafeArea(
                  child: Center(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: size.height * 0.1),
                      Stack(
                        children: [
                          image == null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: messageColor, width: 0.9),
                                    ),
                                    child: Image.network(
                                      userData!.profilePic,
                                      width: 280,
                                      height: 350,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: messageColor, width: 0.9),
                                    ),
                                    child: Image.file(
                                      image!,
                                      width: 280,
                                      height: 350,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                          Positioned(
                              bottom: -2,
                              left: 230,
                              child: IconButton(
                                  color: messageColor,
                                  onPressed: selectImage,
                                  icon: const Icon(
                                    Icons.camera_alt,
                                    size: 35,
                                  )))
                        ],
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: size.width * 0.85,
                                padding: const EdgeInsets.all(20),
                                child: TextField(
                                  controller: namesController,
                                  decoration: InputDecoration(
                                      hintText: userData!.name,
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: messageColor),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.white60),
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 50),
                            child: Row(
                              children: [
                                Text(
                                  'Update photo required!',
                                  style: GoogleFonts.aBeeZee(fontSize: 10),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      InkWell(
                        onTap: updateUserData,
                        child: Container(
                          height: 40,
                          width: 90,
                          decoration: const BoxDecoration(
                              color: messageColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Center(
                              child: Text(
                            'Update',
                            style: GoogleFonts.aBeeZee(),
                          )),
                        ),
                      )
                    ],
                  )),
                ),
              ));
  }
}
