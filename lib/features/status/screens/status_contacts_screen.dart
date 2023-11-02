import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample_project2/colors.dart';
import 'package:sample_project2/common/widgets/loader.dart';
import 'package:sample_project2/features/status/repository/status_repository.dart';
import 'package:sample_project2/features/status/screens/status_screen.dart';

class StatusContactsScreen extends ConsumerWidget {
  const StatusContactsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firestore = FirebaseFirestore.instance;
    final data = StatusClass().getStatusList();
    log(data.toString());
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: StreamBuilder(
        stream: StatusClass().getStatusList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          } else if (snapshot.hasData) {
            return snapshot.data!.isEmpty
                ? const Center(
                    child: Text("No Status"),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'My Status',
                        style: TextStyle(fontSize: 17),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 0,
                            mainAxisExtent: 80,
                            mainAxisSpacing: 0,
                          ),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            var statusData = snapshot.data![index];
                            return Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      StatusScreen.routeName,
                                      arguments: statusData,
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: ListTile(
                                      leading: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(25)),
                                            border: Border.all(
                                                color: messageColor,
                                                width: 0.9)),
                                        child: GestureDetector(
                                          onLongPress: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                    'Do you want to delete the Status?',
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                  content: const Text(
                                                      'This action will delete the Status from the List'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child:
                                                          const Text('Cancel'),
                                                      onPressed: () {

                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: const Text('Yes'),
                                                      onPressed: () {
                                                        
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: CircleAvatar(
                                            backgroundImage: NetworkImage(
                                              statusData.profilePic,
                                            ),
                                            radius: 25,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const Divider(color: dividerColor, indent: 85),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  );
          } else {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
        },
      ),
    );
  }
}
