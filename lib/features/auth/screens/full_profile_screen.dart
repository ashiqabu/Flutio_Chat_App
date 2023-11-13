import 'package:flutter/material.dart';

class ImageDisplayPage extends StatelessWidget {
  final String imageUrl;

  const ImageDisplayPage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Picture'),
      ),
      body: Center(
        child: Image.network(imageUrl), // Display the image
      ),
    );
  }
}
