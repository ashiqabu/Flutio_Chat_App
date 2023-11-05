import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample_project2/colors.dart';
import 'package:sample_project2/common/widgets/loader.dart';
import 'package:sample_project2/features/auth/controller/auth_controller.dart';
import 'package:sample_project2/features/call/controller/call_controller.dart';
import 'package:sample_project2/features/call/screens/call_pickUp_screen.dart';
import 'package:sample_project2/features/chat/screens/profile_page.dart';
import 'package:sample_project2/features/chat/widgets/chat_list.dart';
import 'package:sample_project2/features/landing/landing_screen.dart';
import 'package:sample_project2/model/user_model.dart';

import '../widgets/botton_chat_field.dart';

class MobileChatScreen extends ConsumerWidget {
  static const String routeName = '/mobile-chat-screen';
  final String name;
  final String uid;
  final bool isGroupChat;
  final String profilePic;
  const MobileChatScreen(
      {super.key,
      required this.isGroupChat,
      required this.name,
      required this.uid,
      required this.profilePic});

  void makeCall(WidgetRef ref, BuildContext context) {
    ref
        .read(callControllerProvider)
        .makeCall(context, name, uid, profilePic, isGroupChat);
  }

  void makeAudioCall(WidgetRef ref, BuildContext context) {
    ref.read(callControllerProvider).makeAudioCall(
          context,
          name,
          uid,
          profilePic,
          isGroupChat,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CallPickUpScreen(
      scaffold: Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColor,
          title: isGroupChat
              ? Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => FullScreenProfilePicture(
                                profilePic: profilePic),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            5), // Adjust the radius as needed
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: messageColor, width: 0.9),
                          ),
                          child: Image.network(
                            profilePic,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: Text(
                        name,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                )
              : StreamBuilder<UserModel>(
                  stream: ref.read(authControllerProvider).userDataById(uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Loader();
                    }

                    return Column(
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        FullScreenProfilePicture(
                                            profilePic: profilePic),
                                  ),
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    5), // Adjust the radius as needed
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: messageColor, width: 0.9),
                                  ),
                                  child: Image.network(
                                    profilePic,
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      name,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      snapshot.data!.isOnline
                                          ? 'online'
                                          : 'offline',
                                      style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
          actions: <Widget>[
            Row(
              children: [
                IconButton(
                  onPressed: () => makeCall(ref, context),
                  icon: const Icon(Icons.video_call),
                ),
                IconButton(
                  onPressed: () => makeAudioCall(ref, context),
                  icon: const Icon(Icons.call),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_vert),
                ),
              ],
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ChatList(
                reciverUserId: uid,
                isGroupChat: isGroupChat,
              ),
            ),
            BottomChatField(
              recieverUserId: uid,
              isGroupChat: isGroupChat,
            )
          ],
        ),
      ),
    );
  }
}
