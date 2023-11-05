import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample_project2/colors.dart';
import 'package:sample_project2/features/chat/widgets/display_text_image_gif.dart';
import 'package:swipe_to/swipe_to.dart';

import '../../../common/enums/message_enum.dart';

class SenderMessageCard extends ConsumerWidget {
  final String message;
  final String date;
  final MessageEnum type;
  final VoidCallback onRightSwipe;
  final String repliedText;
  final String userName;
  final MessageEnum repliedMessageType;
  final String receiverId;
  final String messageId;
  final bool isGroupchat;
   final bool isEdited;
  const SenderMessageCard({
    super.key,
    required this.message,
    required this.date,
    required this.type,
    required this.onRightSwipe,
    required this.repliedText,
    required this.userName,
    required this.repliedMessageType,
    required this.receiverId,
    required this.messageId,
    required this.isGroupchat,
   required this.isEdited,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isReplying = repliedText.isNotEmpty;
    return SwipeTo(
      onRightSwipe: onRightSwipe,
      child: Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 45),
          child: Card(
            elevation: 1,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            color: senderMessageColor,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Stack(
              children: [
                Padding(
                  padding: type == MessageEnum.text
                      ? const EdgeInsets.only(
                          left: 20, right: 30, top: 5, bottom: 20)
                      : const EdgeInsets.only(
                          left: 5,
                          top: 5,
                          right: 5,
                          bottom: 25,
                        ),
                  child: Column(
                    children: [
                      if (isReplying) ...[
                        Text(
                          userName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: messageColor),
                        ),
                        const SizedBox(height: 3),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: messageColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                5,
                              ),
                            ),
                          ),
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
                  ),
                ),
                Positioned(
                  bottom: 5,
                  right: 10,
                  child: Row(
                    children: [
                      isEdited == true
                          ? const Text(
                              'Edited',
                              style:
                                  TextStyle(fontSize: 8, color: Colors.black),
                            )
                          : const SizedBox(),
                          const SizedBox(width: 5,),
                      Text(
                        date,
                        style:
                            const TextStyle(fontSize: 8, color: Colors.black),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
