import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample_project2/common/enums/message_enum.dart';
import 'package:sample_project2/common/provider/message_replay_provider.dart';
import 'package:sample_project2/common/repository/common_firebase_storage_repository.dart';
import 'package:sample_project2/common/widgets/utils/utils.dart';
import 'package:sample_project2/model/chat_contact.dart';
import 'package:sample_project2/model/group.dart';
import 'package:sample_project2/model/message.dart';
import 'package:uuid/uuid.dart';
import '../../../model/user_model.dart';

final chatRepositoryProvider = Provider((ref) => ChatRepository(
    firestore: FirebaseFirestore.instance, auth: FirebaseAuth.instance));

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  ChatRepository({required this.firestore, required this.auth});

  Stream<List<ChatContact>> getChatContacts() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      List<ChatContact> contacts = [];
      for (var document in event.docs) {
        var chatContact = ChatContact.fromMap(document.data());
        var userData = await firestore
            .collection('users')
            .doc(chatContact.contactId)
            .get();
        var user = UserModel.fromMap(userData.data()!);
        contacts.add(
          ChatContact(
            name: user.name,
            profiilePic: user.profilePic,
            contactId: chatContact.contactId,
            timeSent: chatContact.timeSent,
            lastMessage: chatContact.lastMessage,
          ),
        );
      }
      return contacts;
    });
  }

  Stream<List<Group>> getChatGroups() {
    return firestore.collection('groups').snapshots().map((event) {
      List<Group> groups = [];
      for (var document in event.docs) {
        var group = Group.fromMap(document.data());
        if (group.membersUid.contains(auth.currentUser!.uid)) {
          groups.add(group);
        }
      }
      return groups;
    });
  }

  Stream<List<Message>> getChatStream(String recieverUserId) {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(recieverUserId)
        .collection('messages')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<Message> messages = [];
      for (var document in event.docs) {
        messages.add(Message.fromMap(document.data()));
      }
      return messages;
    });
  }

  Stream<List<Message>> getGroupChatStream(String groupId) {
    return firestore
        .collection('groups')
        .doc(groupId)
        .collection('chats')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<Message> messages = [];
      for (var document in event.docs) {
        messages.add(Message.fromMap(document.data()));
      }
      return messages;
    });
  }

  void _saveDataToContactsSubCollection(
    UserModel senderUserData,
    UserModel? recieverUserData,
    String text,
    DateTime timeSent,
    String recieverUserId,
    bool isGroupChat,
  ) async {
    if (isGroupChat) {
      await firestore.collection('groups').doc(recieverUserId).update({
        'lastMessage': text,
        'timeSent': DateTime.now().microsecondsSinceEpoch,
      });
    } else {
      var reciverChatContact = ChatContact(
        name: senderUserData.name,
        profiilePic: senderUserData.profilePic,
        contactId: senderUserData.uid,
        timeSent: timeSent,
        lastMessage: text,
      );
      await firestore
          .collection('users')
          .doc(recieverUserId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .set(reciverChatContact.toMap());

      var senderChatContact = ChatContact(
        name: recieverUserData!.name,
        profiilePic: recieverUserData.profilePic,
        contactId: recieverUserData.uid,
        timeSent: timeSent,
        lastMessage: text,
      );
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(recieverUserId)
          .set(senderChatContact.toMap());
    }
  }

  void _saveMessageToMessageSubCollection(
      {required String recieverUserId,
      required String text,
      required DateTime timesent,
      required String messageId,
      required String username,
      required String? recieverUserName,
      required MessageEnum messageType,
      required MessageReply? messageReply,
      required String senderUserName,
      required bool isGroupChat,
      required bool isEdit,
      }) async {
    
    final message = Message(
      isEdited: isEdit,
      senderId: auth.currentUser!.uid,
      recieverId: recieverUserId,
      text: text,
      type: messageType,
      timeSent: timesent,
      messageId: messageId,
      isSeen: false,
      repliedMessage: messageReply == null ? '' : messageReply.message,
      repliedTo: messageReply == null
          ? ''
          : messageReply.isMe
              ? senderUserName
              : recieverUserName ?? '',
      repleidMessageType:
          messageReply == null ? MessageEnum.text : messageReply.messageEnum,
    );

    if (isGroupChat) {
      await firestore
          .collection('groups')
          .doc(recieverUserId)
          .collection('chats')
          .doc(messageId)
          .set(
            message.toMap(),
          );
    } else {
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(recieverUserId)
          .collection('messages')
          .doc(messageId)
          .set(message.toMap());

      await firestore
          .collection('users')
          .doc(recieverUserId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .collection('messages')
          .doc(messageId)
          .set(message.toMap());
    }
  }

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String recieverUserId,
    required UserModel senderUser,
    required MessageReply? messageReply,
    required bool isGroupChat,
    // required bool isEdited,
  }) async {
    try {
      var timeSent = DateTime.now();
      UserModel? recieverUserData;

      if (!isGroupChat) {
        var userDataMap =
            await firestore.collection('users').doc(recieverUserId).get();
        recieverUserData = UserModel.fromMap(userDataMap.data()!);
      }

      var messageId = const Uuid().v1();

      _saveDataToContactsSubCollection(senderUser, recieverUserData, text,
          timeSent, recieverUserId, isGroupChat);

      _saveMessageToMessageSubCollection(
          isEdit: false,
          recieverUserId: recieverUserId,
          text: text,
          timesent: timeSent,
          messageType: MessageEnum.text,
          messageId: messageId,
          username: senderUser.name,
          messageReply: messageReply,
          recieverUserName: recieverUserData?.name,
          senderUserName: senderUser.name,
          isGroupChat: isGroupChat);
    } catch (e) {
      // ignore: use_build_context_synchronously
      showSnackBar(context: context, content: e.toString());
    }
  }

  void sendFileMessage({
    required BuildContext context,
    required File file,
    required String recieverUserId,
    required UserModel senderUserData,
    required ProviderRef ref,
    required MessageEnum messageEnum,
    required MessageReply? messageReply,
    required bool isGroupChat,
  }) async {
    try {
      var timeSent = DateTime.now();
      var messageId = const Uuid().v1();

      String imageUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase(
            'chat/${messageEnum.type}/${senderUserData.uid}/$recieverUserId/$messageId',
            file,
          );
      UserModel? recieverUserData;
      if (!isGroupChat) {
        var userDataMap =
            await firestore.collection('users').doc(recieverUserId).get();
        recieverUserData = UserModel.fromMap(userDataMap.data()!);
      }

      String contactMsg;
      switch (messageEnum) {
        case MessageEnum.image:
          contactMsg = '📷Photo';
          break;
        case MessageEnum.video:
          contactMsg = '🎥Video';
          break;
        case MessageEnum.audio:
          contactMsg = '🎵Audio';
          break;
        case MessageEnum.gif:
          contactMsg = 'Gif';
          break;
        default:
          contactMsg = '';
      }
      _saveDataToContactsSubCollection(senderUserData, recieverUserData,
          contactMsg, timeSent, recieverUserId, isGroupChat);

      _saveMessageToMessageSubCollection(
        isEdit: false,
        recieverUserId: recieverUserId,
        text: imageUrl,
        timesent: timeSent,
        messageId: messageId,
        username: senderUserData.name,
        recieverUserName: recieverUserData?.name,
        messageType: messageEnum,
        messageReply: messageReply,
        senderUserName: senderUserData.name,
        isGroupChat: isGroupChat,
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      showSnackBar(context: context, content: e.toString());
    }
  }

  void sendGIFMessage({
    required BuildContext context,
    required String gifUrl,
    required String recieverUserId,
    required UserModel senderUser,
    required MessageReply? messageReply,
    required bool isGroupChat,
  }) async {
    //user-> senderId->message->messageId->store message

    try {
      var timeSent = DateTime.now();
      UserModel? recieverUserData;

      if (!isGroupChat) {
        var userDataMap =
            await firestore.collection('users').doc(recieverUserId).get();
        recieverUserData = UserModel.fromMap(userDataMap.data()!);
      }

      var messageId = const Uuid().v1();

      _saveDataToContactsSubCollection(senderUser, recieverUserData, 'GIF',
          timeSent, recieverUserId, isGroupChat);

      _saveMessageToMessageSubCollection(
          isEdit: false,
          recieverUserId: recieverUserId,
          text: gifUrl,
          timesent: timeSent,
          messageType: MessageEnum.gif,
          messageId: messageId,
          recieverUserName: recieverUserData?.name,
          username: senderUser.name,
          messageReply: messageReply,
          senderUserName: senderUser.name,
          isGroupChat: isGroupChat);
    } catch (e) {
      // ignore: use_build_context_synchronously
      showSnackBar(context: context, content: e.toString());
    }
  }

  void setChatMessageSeen(
    BuildContext context,
    String recieverUserId,
    String messageId,
  ) async {
    try {
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(recieverUserId)
          .collection('messages')
          .doc(messageId)
          .update({'isSeen': true});

      await firestore
          .collection('users')
          .doc(recieverUserId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .collection('messages')
          .doc(messageId)
          .update({'isSeen': true});
    } catch (e) {
      // ignore: use_build_context_synchronously
      showSnackBar(context: context, content: e.toString());
    }
  }

  void deleteMessagesFromMessageSubCollection({
    required String recieverUserId,
    required String messageId,
    required bool isGroupChat,
  }) async {
    if (isGroupChat) {
      await firestore
          .collection('groups')
          .doc(recieverUserId)
          .collection('chats')
          .doc(messageId)
          .delete();
    } else {
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(recieverUserId)
          .collection('messages')
          .doc(messageId)
          .delete();

      await firestore
          .collection('users')
          .doc(recieverUserId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .collection('messages')
          .doc(messageId)
          .delete();
    }
  }

  void editMessagesFromMessageSubCollection({
    required String recieverUserId,
    required String messageId,
    required bool isGroupChat,
    required String message,
  }) async {
    if (isGroupChat) {
      await firestore
          .collection('groups')
          .doc(recieverUserId)
          .collection('chats')
          .doc(messageId)
          .update({"text": message, "isEdit": true});
    } else {
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(recieverUserId)
          .collection('messages')
          .doc(messageId)
          .update({"text": message, "isEdit": true});

      await firestore
          .collection('users')
          .doc(recieverUserId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .collection('messages')
          .doc(messageId)
          .update({"text": message, "isEdit": true});
    }
  }
}
