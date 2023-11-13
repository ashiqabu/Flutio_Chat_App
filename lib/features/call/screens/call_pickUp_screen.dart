// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample_project2/features/call/controller/call_controller.dart';
import 'package:sample_project2/features/call/repository/call_repository.dart';
import 'package:sample_project2/features/call/screens/audio_call_screen.dart';
import 'package:sample_project2/features/call/screens/call_screen.dart';
import 'package:sample_project2/model/call.dart';

class CallPickUpScreen extends ConsumerWidget {
  final Widget scaffold;
  const CallPickUpScreen({required this.scaffold, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<DocumentSnapshot>(
      stream: ref.watch(callControllerProvider).callStream,
      builder: ((context, snapshot) {
        if (snapshot.hasData && snapshot.data!.data() != null) {
          Call call =
              Call.fromMap(snapshot.data!.data() as Map<String, dynamic>);
          if (!call.hasDialled) {
            return Scaffold(
              body: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Incoming Call',
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    CircleAvatar(
                      backgroundImage: NetworkImage(call.callerPic),
                      radius: 60,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Text(
                      call.callerName,
                      style: const TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(
                      height: 75,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {
                              ref.read(callRepositoryProvider).endAudioCall(
                                  call.callId, call.receiverId, context);
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.call_end,
                              color: Colors.redAccent,
                            )),
                        const SizedBox(
                          width: 25,
                        ),
                        IconButton(
                            onPressed: () {
                              if (call.isAudioCall) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AudioCallScreen(
                                            channelId: call.callId,
                                            call: call,
                                            isGroupChat: false)));
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CallScreen(
                                      channelId: call.callId,
                                      call: call,
                                      isGroupChat: false,
                                    ),
                                  ),
                                );
                              }
                            },
                            icon: const Icon(
                              Icons.call,
                              color: Colors.lightGreenAccent,
                            ))
                      ],
                    )
                  ],
                ),
              ),
            );
          }
        }
        return scaffold;
      }),
    );
  }
}
