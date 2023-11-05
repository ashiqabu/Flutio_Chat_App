import 'package:flutter/material.dart';

class FullScreenProfilePicture extends StatelessWidget {
  final String profilePic;

  FullScreenProfilePicture({required this.profilePic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Full Profile Picture'),
      ),
      body: Center(
        child: Image.network(profilePic),
      ),
    );
  }
}
