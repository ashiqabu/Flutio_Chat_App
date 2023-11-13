import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample_project2/common/widgets/error.dart';
import 'package:sample_project2/common/widgets/utils/utils.dart';
import 'package:sample_project2/model/user_model.dart';
import 'package:sample_project2/features/chat/screens/mobile_chat_screen.dart';

final selectContactsRepositoryProvider = Provider(
    (ref) => SelectContactRepository(firestore: FirebaseFirestore.instance));

class SelectContactRepository {
  final FirebaseFirestore firestore;

  SelectContactRepository({required this.firestore});

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return contacts;
  }

  void selectContact(Contact selectedContact, BuildContext context) async {
    try {
      var userCollection = await firestore.collection('users').get();
      // ignore: unused_local_variable
      bool isFound = false;
      for (var document in userCollection.docs) {
        // ignore: unused_local_variable
        var userData = UserModel.fromMap(document.data());
        String selectedPhoneNum =
            selectedContact.phones[0].number.replaceAll(' ', '');

        log(userData.phoneNumber);
        log(userData.uid);
        log(userData.name);
        if ('+91$selectedPhoneNum' == userData.phoneNumber ||
            selectedPhoneNum == userData.phoneNumber) {
          isFound = true;

          // ignore: use_build_context_synchronously
          Navigator.pushNamed(context, MobileChatScreen.routeName, arguments: {
            'name': userData.name,
            'uid': userData.uid,
            'groupId': userData.groupId,
            'profilePic': userData.profilePic,
            'isOnline': userData.isOnline,
            "phoneNumber": userData.phoneNumber,
          });
        }
      }
      if (!isFound) {
        // ignore: use_build_context_synchronously
        showSnackBar(context: context, content: errormessage1);
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      showSnackBar(context: context, content: e.toString());
    }
  }
}
