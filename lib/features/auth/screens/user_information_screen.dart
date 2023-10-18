import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample_project2/common/widgets/utils/utils.dart';
import 'package:sample_project2/features/auth/controller/auth_controller.dart';

class UserInformatioScreen extends ConsumerStatefulWidget {
  static const String routeName = '/user-information';
  const UserInformatioScreen({super.key});

  @override
  ConsumerState<UserInformatioScreen> createState() =>
      _UserInformatioScreenState();
}

class _UserInformatioScreenState extends ConsumerState<UserInformatioScreen> {
  final TextEditingController nameCntrl = TextEditingController();
  File? image;

  @override
  void dispose() {
    super.dispose();
    nameCntrl.dispose();
  }

  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  void storeUserData() async {
    String name = nameCntrl.text.trim();
    if (name.isNotEmpty) {
      ref
          .read(authControllerProvider)
          .saveUserDataToFirebase(context, name, image);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          children: [
            Stack(
              children: [
                image == null
                    ? const CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage(
                            'https://upload.wikimedia.org/wikipedia/commons/8/85/Elon_Musk_Royal_Society_%28crop1%29.jpg'),
                      )
                    : CircleAvatar(
                        radius: 64, backgroundImage: FileImage(image!)),
                Positioned(
                  bottom: -10,
                  left: 80,
                  child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(Icons.add_a_photo)),
                )
              ],
            ),
            Row(
              children: [
                Container(
                  width: size.width * 0.85,
                  padding: const EdgeInsets.all(20),
                  child: TextField(
                    controller: nameCntrl,
                    decoration:
                        const InputDecoration(hintText: 'Enter your name'),
                  ),
                ),
                IconButton(onPressed: storeUserData, icon: const Icon(Icons.done))
              ],
            )
          ],
        ),
      )),
    );
  }
}
