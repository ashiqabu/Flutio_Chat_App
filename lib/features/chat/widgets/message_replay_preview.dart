import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample_project2/common/provider/message_replay_provider.dart';
import 'package:sample_project2/features/chat/widgets/display_text_image_gif.dart';
class MessageReplyPreview extends ConsumerWidget {
  const MessageReplyPreview({Key? key}) : super(key: key);

  void cancelReply(WidgetRef ref) {
    // ignore: deprecated_member_use
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageReply = ref.watch(messageReplyProvider);

    return Container(
      width: 350,
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Color.fromARGB(0, 64, 42, 42),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  messageReply!.isMe ? 'Me' : 'Opposite',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GestureDetector(
                child: const Icon(
                  Icons.close,
                  size: 16,
                ),
                onTap: () => cancelReply(ref),
              ),
            ],
          ),
          const SizedBox(height: 8),
          DisplayTextImageGif(message: messageReply.message, type: messageReply.messageEnum)
        ],
      ),
    );
  }
}
