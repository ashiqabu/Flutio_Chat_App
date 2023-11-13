import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sample_project2/features/status/screens/confirm_status.dart';
import 'package:sample_project2/model/status_model.dart';

final statusClassProvider = Provider<StatusClass>((ref) {
  return StatusClass();
});
String name = '';

class StatusClass {
  PlatformFile? pickedFiles;
  UploadTask? uploadTask;
  Future<void> getPhotos(context) async {
    final date = DateTime.now();
    final time = DateFormat('h:mm a').format(date);

    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    pickedFiles = result.files.first;
    final path = 'photo/${pickedFiles!.name}';
    final file = File(pickedFiles!.path!);
    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);
    final snapShot = await uploadTask!.whenComplete(() {});
    final url = await snapShot.ref.getDownloadURL();
    await getName();
    Status status = Status(
      dateTime: time,
      name: name,
      statusId: FirebaseAuth.instance.currentUser!.uid,
      profilePic: url,
    );
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ConfirmStatusPage(imagePath: file, status: status),
        ));
  }

  Future<void> addPhoto(Status status) async {
    final documentReference =
        FirebaseFirestore.instance.collection("status").doc();
    final statusData = status.toMap();
    statusData['id'] = documentReference.id;
    await documentReference.set(statusData);
    Timer(const Duration(hours: 24), () {
      deleteStatus(documentReference.id);
    });
  }

  getName() async {
    final documentReference = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid);

    final result = await documentReference.get();
    name = result.get('name');
  }

  Stream<List<Status>> getStatusList() {
    return FirebaseFirestore.instance
        .collection("status")
        .snapshots()
        .map((event) {
      return event.docs.map((e) {
        return Status.fromMap(e.data());
      }).toList();
    });
  }
}

final firestore = FirebaseFirestore.instance;
Future<void> deleteStatus(String documentId) async {
  try {
    await firestore.collection("status").doc(documentId).delete();
  } catch (error) {
    rethrow;
  }
}
