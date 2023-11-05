import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sample_project2/common/enums/message_enum.dart';
import 'package:sample_project2/features/chat/widgets/full_image_screen.dart';
import 'package:sample_project2/features/chat/widgets/video_player_item.dart';

class DisplayTextImageGif extends StatelessWidget {
  final String message;
  final MessageEnum type;
  const DisplayTextImageGif(
      {super.key, required this.message, required this.type});

  @override
  Widget build(BuildContext context) {
    bool isPlaying = false;
    final AudioPlayer audioPlayer = AudioPlayer();
    return type == MessageEnum.text
        ? Column(
            children: [
              Text(
                message,
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
            ],
          )
        : type == MessageEnum.audio
            ? StatefulBuilder(builder: (context, setState) {
                return IconButton(
                    constraints: const BoxConstraints(
                        maxWidth: 300, minWidth: 200, maxHeight: 25),
                    onPressed: () async {
                      if (isPlaying) {
                        await audioPlayer.pause();
                        setState(() {
                          isPlaying = false;
                        });
                      } else {
                        await audioPlayer.play(UrlSource(message));
                        setState(() {
                          isPlaying = true;
                        });
                      }
                    },
                    icon: Icon(
                      isPlaying ? Icons.pause_circle : Icons.play_circle,
                      color: Colors.black,
                    ));
              })
            : type == MessageEnum.video
                ? VideoPlayerItem(videoUrl: message)
                : type == MessageEnum.gif
                    ? CachedNetworkImage(imageUrl: message)
                    : GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FullScreenImagePage(
                                        imageUrl: message,
                                      )));
                        },
                        child: Container(
                            constraints: const BoxConstraints(
                              maxWidth: 200, // Set your desired maximum width
                              maxHeight: 200, // Set your desired maximum height
                            ),
                            child: CachedNetworkImage(imageUrl: message)),
                      );
  }
}
