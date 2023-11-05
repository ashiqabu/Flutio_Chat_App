import 'package:flutter/material.dart';
import 'package:sample_project2/model/status_model.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';

class StatusScreen extends StatefulWidget {
  static const String routeName = '/status-screen';
  final Status status;

  const StatusScreen({
    Key? key,
    required this.status,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _StatusScreenState createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  final storyController = StoryController();
  final List<StoryItem> storyItems = [];

  @override
  void initState() {
    super.initState();
    // Create a StoryItem for the status image
    storyItems.add(
      StoryItem.pageImage(
        url: widget.status.profilePic,
        controller: storyController,
        caption: 'Status Caption', // You can customize the caption
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Status Viewer'),
      ),
      body: StoryView(
        storyItems: storyItems,
        controller: storyController,
        onComplete: () {
          // Handle the completion of the last status (e.g., navigate back)
          Navigator.pop(context);
        },
      ),
    );
  }
}
