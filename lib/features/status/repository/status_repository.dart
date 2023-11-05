import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample_project2/model/status_model.dart';

final statusClassProvider = Provider<StatusClass>((ref) {
  return StatusClass();
});

class StatusClass {
  PlatformFile? pickedFiles;
  UploadTask? uploadTask;
  Future<void> getPhotos() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    pickedFiles = result.files.first;
    final path = 'photo/${pickedFiles!.name}';
    final file = File(pickedFiles!.path!);
    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);
    final snapShot = await uploadTask!.whenComplete(() {});
    final url = await snapShot.ref.getDownloadURL();
    Status status = Status(
      profilePic: url,
      
    );
    await addPhoto(status);
  }

  Future<void> addPhoto(Status status) async {
    final documentReference =
        FirebaseFirestore.instance.collection("status").doc();
    final statusData = status.toMap();
    statusData['id'] = documentReference.id;
    await documentReference.set(statusData);
    Timer(const Duration(minutes: 10), () {
      
      deleteStatus(documentReference.id);
    });
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
  log(documentId);
  try {
    await firestore.collection("status").doc(documentId).delete();
  } catch (error) {
    rethrow;
  }
}
