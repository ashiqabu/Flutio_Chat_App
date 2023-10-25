import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample_project2/common/widgets/utils/utils.dart';
import 'package:sample_project2/features/call/screens/audio_call_screen.dart';
import 'package:sample_project2/features/call/screens/call_screen.dart';
import 'package:sample_project2/model/call.dart';

final callRepositoryProvider = Provider((ref) => CallRepository(
      firestore: FirebaseFirestore.instance,
      auth: FirebaseAuth.instance,
    ));

class CallRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  CallRepository({
    required this.firestore,
    required this.auth,
  });

  Stream<DocumentSnapshot> get callStream =>
      firestore.collection('call').doc(auth.currentUser!.uid).snapshots();

  void makeCall(
      Call senderCallData, BuildContext context, Call recieverCallData) async {
    try {
      await firestore
          .collection('call')
          .doc(senderCallData.callerId)
          .set(senderCallData.toMap());
      await firestore
          .collection('call')
          .doc(senderCallData.receiverId)
          .set(recieverCallData.toMap());
      // ignore: use_build_context_synchronously
      Navigator.push(
          context, MaterialPageRoute(builder: (context) =>CallScreen(
            channelId: senderCallData.callId, 
            call: senderCallData, 
            isGroupChat: false,),
          ),);
    } catch (e) {
      // ignore: use_build_context_synchronously
      showSnackBar(context: context, content: e.toString());
    }
  }


     void makeAudioCall(
    Call senderCallData,
    BuildContext context,
    Call receiverCallData,
  ) async {
    try {
      await firestore
          .collection('call')
          .doc(senderCallData.callerId)
          .set(senderCallData.toMap());
      await firestore
          .collection('call')
          .doc(senderCallData.receiverId)
          .set(receiverCallData.toMap());

      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AudioCallScreen(
            channelId: senderCallData.callId,
            call: senderCallData,
            isGroupChat: false,
          ),
        ),
      );
    } catch (e) {
    // ignore: use_build_context_synchronously
    showSnackBar(context:context,content: e.toString());
    }
  }


  void endAudioCall(
    String callerId,
    String recieverId,
    BuildContext context,
  ) async {
    try {
      await firestore.collection('call').doc(callerId).delete();
      await firestore.collection('call').doc(recieverId).delete();
    } catch (e) {
    // ignore: use_build_context_synchronously
    showSnackBar(context:context,content: e.toString());
    }
  }

  void endCall(
      String callerId , BuildContext context, String recieverId) async {
    try {
      await firestore
          .collection('call')
          .doc(callerId)
          .delete();
      await firestore
          .collection('call')
          .doc(recieverId)
          .delete();
    } catch (e) {
      // ignore: use_build_context_synchronously
      showSnackBar(context: context, content: e.toString());
    }
  }
}
