import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample_project2/colors.dart';
import 'package:sample_project2/common/widgets/utils/utils.dart';
import 'package:sample_project2/features/group/controller/groups_controller.dart';
import 'package:sample_project2/features/group/widgets/selected_contact_group.dart';

class CreateGroupScreen extends ConsumerStatefulWidget {
  static const routeName = '/create-group';
  const CreateGroupScreen({super.key});

  @override
  ConsumerState<CreateGroupScreen> createState() => _CreateGroupState();
}

class _CreateGroupState extends ConsumerState<CreateGroupScreen> {
  final TextEditingController groupNameController = TextEditingController();
  File? image;

  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  void createGroup() {
    if (groupNameController.text.trim().isNotEmpty && image != null) {
      ref.read(groupControllerProvider).createGroup(
          context,
          groupNameController.text.trim(),
          image!,
          ref.read(selectedGroupContacts));
      // ignore: deprecated_member_use
      ref.read(selectedGroupContacts.state).update((state) => []);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    super.dispose();
    groupNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Group'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Stack(
              children: [
                image == null
                    ? const CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage(
                            'https://www.pngitem.com/pimgs/m/581-5813504_avatar-dummy-png-transparent-png.png'),
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
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                  controller: groupNameController,
                  decoration: InputDecoration(
                      hintText: 'Enter the Groupname',
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(5)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(10)))),
            ),
            Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.topLeft,
                child: const Text(
                  'Select Contacts',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )),
            const SelectContactsGroup()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createGroup,
        backgroundColor: messageColor,
        child: const Icon(
          Icons.done,
          color: Colors.white,
        ),
      ),
    );
  }
}
