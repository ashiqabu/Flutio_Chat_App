import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:sample_project2/colors.dart';
import 'package:sample_project2/common/widgets/loader.dart';
import 'package:sample_project2/features/chat/controller/chat_controller.dart';
import 'package:sample_project2/features/chat/screens/mobile_chat_screen.dart';
import 'package:sample_project2/model/chat_contact.dart';


import '../../../common/core/constant.dart';

class ContactsList extends ConsumerWidget {
  const ContactsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        children: [
          StreamBuilder<List<ChatContact>>(
              stream: ref.watch(chatControllerProvider).chatContacts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Loader();
                }

                return snapshot.data!.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 49),
                          child: Column(
                            children: [
                              const SizedBox(height: 4),
                              Lottie.asset('animations/animation_lkknttjy.json',
                                  width: 195, height: 195),
                              kHeight(5),
                              const Text(
                                "  No chats yet !",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
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
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: messageColor, width: 0.9),
                                        ),
                                        child: Image.network(
                                          chatContactData.profiilePic,
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
                                              .format(chatContactData.timeSent),
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 13,
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
