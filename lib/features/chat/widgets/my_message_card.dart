import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample_project2/colors.dart';
import 'package:sample_project2/common/enums/message_enum.dart';
import 'package:sample_project2/features/chat/repository/chat_repository.dart';
import 'package:sample_project2/features/chat/widgets/edit_message.dart';
import 'package:swipe_to/swipe_to.dart';

import 'display_text_image_gif.dart';

class MyMessageCard extends ConsumerWidget {
  final String message;
  final String date;
  final MessageEnum type;
  final VoidCallback onleftSwipe;
  final String repliedText;
  final String userName;
  final MessageEnum repliedMessageType;
  final bool isSeen;
  final String receiverId;
  final String messageId;
  final bool isGroupchat;
  final bool isEdited;

  const MyMessageCard({
    super.key,
    required this.message,
    required this.userName,
    required this.repliedMessageType,
    required this.onleftSwipe,
    required this.repliedText,
    required this.date,
    required this.type,
    required this.isSeen,
    required this.receiverId,
    required this.messageId,
    required this.isGroupchat,
    required this.isEdited,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isReplying = repliedText.isNotEmpty;
    return SwipeTo(
      onLeftSwipe: onleftSwipe,
      child: Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 45),
          child: GestureDetector(
            onLongPress: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Colors.white,
                    title: const Text(
                      'Do you want to delete the message?',
                      style: TextStyle(color: Colors.red),
                    ),
                    content: const Text(
                      'This action will delete the messages from the chat',
                      style: TextStyle(color: Colors.black),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Edit Message'),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EditMessageScreen(
                                    isGroupChat: isGroupchat,
                                    messageId: messageId,
                                    recieverId: receiverId,
                                    initialMessage: message,
                                  )));
                        },
                      ),
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text('Yes'),
                        onPressed: () {
                          log(message);

                          ref
                              .read(chatRepositoryProvider)
                              .deleteMessagesFromMessageSubCollection(
                                  recieverUserId: receiverId,
                                  messageId: messageId,
                                  isGroupChat: isGroupchat);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
            child: Card(
              elevation: 1,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(0),
                ),
              ),
              color: messageColor,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
              child: Stack(
                children: [
                  Padding(
                      padding: type == MessageEnum.text
                          ? const EdgeInsets.only(
                              left: 50, right: 40, top: 5, bottom: 20)
                          : const EdgeInsets.only(
                              left: 5, right: 5, top: 5, bottom: 25),
                      child: Column(
                        children: [
                          if (isReplying) ...[
                            Text(
                              'replay to $userName',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                  color: senderMessageColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              child: DisplayTextImageGif(
                                
                                message: repliedText,
                                type: repliedMessageType,
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                          DisplayTextImageGif(
                            message: message,
                            type: type,
                             
                            
                          ),
                        ],
                      )),
                  Positioned(
                    bottom: 4,
                    right: 10,
                    child: Row(
                      children: [
                        isEdited == true
                            ? const Text(
                                'Edited',
                                style:
                                    TextStyle(fontSize: 8, color: Colors.white),
                              )
                            : const SizedBox(),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          date,
                          style:
                              const TextStyle(fontSize: 8, color: Colors.white),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Icon(isSeen ? Icons.done_all : Icons.done,
                            size: 20,
                            color: isSeen
                                ? Colors.blue
                                : const Color.fromARGB(255, 139, 136, 136))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
