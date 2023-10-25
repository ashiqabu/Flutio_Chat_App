import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sample_project2/colors.dart';
import 'package:sample_project2/common/widgets/loader.dart';
import 'package:sample_project2/features/chat/controller/chat_controller.dart';
import 'package:sample_project2/features/chat/screens/mobile_chat_screen.dart';
import 'package:sample_project2/model/chat_contact.dart';
import 'package:sample_project2/model/group.dart';

class ContactsList extends ConsumerWidget {

  const ContactsList({super.key});

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
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundImage:
                                      NetworkImage(groupData.groupPic),
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
          StreamBuilder<List<ChatContact>>(
              stream: ref.watch(chatControllerProvider).chatContacts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Loader();
                }

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var chatContactData = snapshot.data![index];

                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              MobileChatScreen.routeName,
                              arguments: {
                                'name': chatContactData.name,
                                'uid': chatContactData.contactId,
                                'isGroupChat': false,
                                'profilePic': chatContactData.profiilePic,
                              },
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: ListTile(
                              title: Text(
                                chatContactData.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 6.0),
                                child: Text(
                                  chatContactData.lastMessage,
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  chatContactData.profiilePic,
                                ),
                                radius: 30,
                              ),
                              trailing: Column(
                                children: [
                                  Text(
                                    DateFormat('h:mm a')
                                        .format(chatContactData.timeSent),
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
                                      child: Text(
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
                  },
                );
              }),
        ],
      ),
    );
  }
}
