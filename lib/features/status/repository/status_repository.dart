import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sample_project2/model/status_model.dart';

class StatusClass {
  PlatformFile? pickedFiles;
  UploadTask? uploadTask;
  getPhotos() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    pickedFiles = result.files.first;
    final path = 'photo/${pickedFiles!.name}';
    final file = File(pickedFiles!.path!);
    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);
    final snapShot = await uploadTask!.whenComplete(() {});
    final url = await snapShot.ref.getDownloadURL();
    Status status = Status(profilePic: url );
    await addPhoto(status);
  }

  final firestore = FirebaseFirestore.instance;
  addPhoto(Status status) {
    firestore.collection("status").add({
      "photo": status.profilePic,
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
