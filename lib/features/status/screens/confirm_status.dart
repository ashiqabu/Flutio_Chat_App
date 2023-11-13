import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sample_project2/colors.dart';
import 'package:sample_project2/features/status/repository/status_repository.dart';

import '../../../model/status_model.dart';

class ConfirmStatusPage extends StatefulWidget {
  final File imagePath;
  final Status status;

  const ConfirmStatusPage(
      {super.key, required this.imagePath, required this.status});

  @override
  // ignore: library_private_types_in_public_api
  _ConfirmStatusPageState createState() => _ConfirmStatusPageState();
}

class _ConfirmStatusPageState extends State<ConfirmStatusPage> {
  String statusCaption = "";
  final captionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Confirm Status"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(30),
              child: Image.file(widget.imagePath),
            ),
            Container(
              width: 250,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextFormField(
                controller: captionController,
                decoration: const InputDecoration(
                  hintText: "Add a status caption",
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: messageColor,
        onPressed: () {
          Status status = Status(
              name: widget.status.name,
              dateTime: widget.status.dateTime,
              profilePic: widget.status.profilePic,
              statusId: widget.status.statusId,
              caption: captionController.text);
          StatusClass().addPhoto(status);
          Navigator.pop(context);
        },
        child: const Icon(
          Icons.check,
          color: Colors.white,
        ),
      ),
    );
  }
}
