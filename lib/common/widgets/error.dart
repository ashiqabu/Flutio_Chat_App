import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final String error;
  const ErrorScreen({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(error));
  }
}

const errormessage = 'This page dosen\'t exist';
const errormessage1 = 'This number does not exits in the app';
