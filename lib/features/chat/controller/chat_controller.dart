import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample_project2/common/enums/message_enum.dart';
import 'package:sample_project2/common/provider/message_replay_provider.dart';
import 'package:sample_project2/features/auth/controller/auth_controller.dart';
import 'package:sample_project2/features/chat/repository/chat_repository.dart';
import 'package:sample_project2/model/chat_contact.dart';
import 'package:sample_project2/model/group.dart';
import 'package:sample_project2/model/message.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatController(
    chatRepository: chatRepository,
    ref: ref,
  );
});

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatController({required this.chatRepository, required this.ref});

  Stream<List<ChatContact>> chatContacts() {
    return chatRepository.getChatContacts();
  }

  Stream<List<Group>> chatGroups() {
    return chatRepository.getChatGroups();
  }

  Stream<List<Message>> chatStream(String recieverUserId) {
    return chatRepository.getChatStream(recieverUserId);
  }

  Stream<List<Message>> groupchatStream(String groupId) {
    return chatRepository.getGroupChatStream(groupId);
  }

  void sendTextMessage(BuildContext context, String text, String recieverUserId,
      bool isGroupChat) {
    final messageReply = ref.read(messageReplyProvider);
    ref.read(userDataAuthProvider).whenData((value) =>
        chatRepository.sendTextMessage(
            context: context,
            text: text,
            recieverUserId: recieverUserId,
            senderUser: value!,
            messageReply: messageReply,
            isGroupChat: isGroupChat));
  }

  void sendFileMessage(BuildContext context, File file, String recieverUserId,
      MessageEnum messageEnum, bool isGroupChat) {
    final messageReply = ref.read(messageReplyProvider);
    ref.read(userDataAuthProvider).whenData((value) =>
        chatRepository.sendFileMessage(
            context: context,
            file: file,
            recieverUserId: recieverUserId,
            senderUserData: value!,
            messageEnum: messageEnum,
            messageReply: messageReply,
            isGroupChat: isGroupChat,
            ref: ref));
  }

  void sendGIFMessage(BuildContext context, String gifUrl,
      String recieverUserId, bool isGroupChat) {
    final messageReply = ref.read(messageReplyProvider);
    int gifUrlPartIndex = gifUrl.lastIndexOf('-') + 1;
    String gifUrlPart = gifUrl.substring(gifUrlPartIndex);
    String newgifUrl = 'https://i.giphy.com/media/$gifUrlPart/200.gif';
    ref.read(userDataAuthProvider).whenData((value) =>
        chatRepository.sendGIFMessage(
            context: context,
            gifUrl: newgifUrl,
            recieverUserId: recieverUserId,
            senderUser: value!,
            messageReply: messageReply,
            isGroupChat: isGroupChat));
  }

  void setChatMessageSeen(
    BuildContext context,
    String recieverUserId,
    String messageId,
  ) {
    chatRepository.setChatMessageSeen(context, recieverUserId, messageId);
  }
}
