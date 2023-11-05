import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/chat_repository.dart';

class EditMessageScreen extends ConsumerWidget {
  final String initialMessage;
  final String recieverId;
  final String messageId;
  final bool isGroupChat;
  const EditMessageScreen(
      {super.key,
      required this.initialMessage,
      required this.recieverId,
      required this.messageId,
      required this.isGroupChat});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController messageController =
        TextEditingController(text: initialMessage);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Message'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: messageController,
              decoration: const InputDecoration(
                labelText: 'Edit your message',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref
                    .read(chatRepositoryProvider)
                    .editMessagesFromMessageSubCollection(
                        isGroupChat: isGroupChat,
                        message: messageController.text.trim(),
                        messageId: messageId,
                        recieverUserId: recieverId);
                int count = 0;
                Navigator.of(context).popUntil((_) => count++ >= 2);
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
