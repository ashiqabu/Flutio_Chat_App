// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sample_project2/colors.dart';
import 'package:sample_project2/common/widgets/loader.dart';
import 'package:sample_project2/features/chat/controller/chat_controller.dart';
import 'package:sample_project2/features/chat/screens/mobile_chat_screen.dart';
import 'package:sample_project2/model/group.dart';

class ContactsListGroup extends ConsumerWidget {
  const ContactsListGroup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        children: [
          StreamBuilder<List<Group>>(
              stream: ref.watch(chatControllerProvider).chatGroups(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Loader();
                }
                if (snapshot.data == null) {
                  return const Loader();
                }

                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var groupData = snapshot.data![index];

                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                MobileChatScreen.routeName,
                                arguments: {
                                  'name': groupData.name,
                                  'uid': groupData.groupId,
                                  'isGroupChat': true,
                                  'profilePic': groupData.groupPic
                                },
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: ListTile(
                                title: Text(
                                  groupData.name,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      color:
                                          Color.fromARGB(255, 255, 255, 255)),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Text(
                                    groupData.lastMessage,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        color:
                                            Color.fromARGB(255, 255, 255, 255)),
                                  ),
                                ),
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      5), // Adjust the radius as needed
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: messageColor, width: 0.9),
                                    ),
                                    child: Image.network(
                                      groupData.groupPic,
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                trailing: Column(
                                  children: [
                                    Text(
                                      DateFormat('h:mm a')
                                          .format(groupData.timeSent),
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 13,
                                      ),
                                    ),
                                    Positioned(
                                      left: 10,
                                      bottom: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: messageColor,
                                        ),
                                        child: const Text(
                                          '5',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    });
              }),
        ],
      ),
    );
  }
}
