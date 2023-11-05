import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sample_project2/colors.dart';
import 'package:sample_project2/common/enums/message_enum.dart';
import 'package:sample_project2/common/provider/message_replay_provider.dart';
import 'package:sample_project2/common/widgets/loader.dart';
import 'package:sample_project2/features/chat/controller/chat_controller.dart';
import 'package:sample_project2/model/message.dart';
import 'package:sample_project2/features/chat/widgets/my_message_card.dart';
import 'package:sample_project2/features/chat/widgets/sender_message_card.dart';

class ChatList extends ConsumerStatefulWidget {
  final String reciverUserId;
  final bool isGroupChat;

  const ChatList(
      {required this.isGroupChat, required this.reciverUserId, super.key});

  @override
  ConsumerState<ChatList> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController messageCntrl = ScrollController();

  @override
  void dispose() {
    super.dispose();
    messageCntrl.dispose();
  }

  void onMessageSwipe(String message, bool isMe, MessageEnum messageEnum) {
    // ignore: deprecated_member_use
    ref.read(messageReplyProvider.state).update((state) => MessageReply(
          message,
          isMe,
          messageEnum,
        ));
  }

  void _scrollToBottom() {
    messageCntrl.animateTo(
      messageCntrl.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final date = DateTime.now();
    final formatDate = DateFormat('dd-MM-yyyy').format(date);
    log(formatDate);
    return Scaffold(
        body: StreamBuilder<List<Message>>(
          stream: widget.isGroupChat
              ? ref
                  .read(chatControllerProvider)
                  .groupchatStream(widget.reciverUserId)
              : ref
                  .read(chatControllerProvider)
                  .chatStream(widget.reciverUserId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loader();
            }
            SchedulerBinding.instance.addPostFrameCallback((_) {
              messageCntrl.jumpTo(messageCntrl.position.maxScrollExtent);
            });

            return Column(
              children: [
                Card(color: messageColor, child: Text(formatDate)),
                Expanded(
                  child: ListView.builder(
                    controller: messageCntrl,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final messageData = snapshot.data![index];
                      var timeSent =
                          DateFormat('h:mm a').format(messageData.timeSent);

                      if (!messageData.isSeen &&
                          messageData.recieverId ==
                              FirebaseAuth.instance.currentUser!.uid) {
                        ref.read(chatControllerProvider).setChatMessageSeen(
                            context,
                            widget.reciverUserId,
                            messageData.messageId);
                      }
                      if (messageData.senderId ==
                          FirebaseAuth.instance.currentUser!.uid) {
                        return MyMessageCard(
                          type: messageData.type,
                          message: messageData.text,
                          date: timeSent,
                          repliedText: messageData.repliedMessage,
                          userName: messageData.repliedTo,
                          repliedMessageType: messageData.repleidMessageType,
                          onleftSwipe: () => onMessageSwipe(
                              messageData.text, true, messageData.type),
                          isSeen: messageData.isSeen,
                          messageId: messageData.messageId,
                          receiverId: messageData.recieverId,
                          isGroupchat: false,
                          isEdited: messageData.isEdited,
                        );
                      }
                      return SenderMessageCard(
                        message: messageData.text,
                        date: timeSent,
                        type: messageData.type,
                        userName: messageData.repliedTo,
                        repliedMessageType: messageData.repleidMessageType,
                        onRightSwipe: () => onMessageSwipe(
                            messageData.text, false, messageData.type),
                        repliedText: messageData.repliedMessage,
                        messageId: messageData.messageId,
                        receiverId: messageData.recieverId,
                        isGroupchat: false,
                        isEdited: messageData.isEdited,
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Align(
              alignment: Alignment.bottomLeft,
              child: FloatingActionButton(
                backgroundColor: messageColor,
                onPressed: _scrollToBottom,
                mini: true,
                child: const Icon(
                  Icons.keyboard_double_arrow_down_rounded,
                  size: 20,
                  color: Colors.white,
                ),
              )),
        ));
  }

  // int calculateUnseenMessageCount(List<Message> messages) {
  //   int unseenCount = 0;

  //   for (final message in messages) {
  //     if (!message.isSeen &&
  //         message.recieverId == FirebaseAuth.instance.currentUser!.uid) {
  //       unseenCount++;
  //     }
  //   }

  //   return unseenCount;
  // }
}
