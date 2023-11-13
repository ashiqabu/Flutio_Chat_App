import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample_project2/colors.dart';
import 'package:sample_project2/common/widgets/loader.dart';
import 'package:sample_project2/features/auth/controller/auth_controller.dart';
import 'package:sample_project2/features/status/repository/status_repository.dart';
import 'package:sample_project2/features/status/screens/status_screen.dart';

// ignore: must_be_immutable
class StatusContactsScreen extends ConsumerWidget {
  static const String routeName = '/status-screen';
  StatusContactsScreen({super.key});
  String uiId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    StatusClass().getName();
    return FutureBuilder(
      future: ref.read(authControllerProvider).getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Loader());
        }

        if (snapshot.hasError || snapshot.data == null) {
          return const Center(
              child: Text("Error fetching or no data available"));
        }

        final userData = snapshot.data!;
        return Scaffold(
          body: StreamBuilder(
            stream: StatusClass().getStatusList(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Loader();
              } else if (snapshot.hasData) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'My Status',
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 100,
                      child: SingleChildScrollView(  
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                StatusClass().getPhotos(context);
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 10, left: 10),
                                child: Stack(children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(40)),
                                      border: Border.all(color: messageColor),
                                    ),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.grey,
                                      backgroundImage:
                                          NetworkImage(userData.profilePic),
                                      radius: 32,
                                    ),
                                  ),
                                  Positioned(
                                      left: 45,
                                      top: 45,
                                      child: Container(
                                          decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              gradient: LinearGradient(colors: [
                                                Colors.black,
                                                messageColor
                                              ])),
                                          child: const Icon(Icons.add)))
                                ]),
                              ),
                            ),
                            ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                final data = snapshot.data![index];
                                return data.statusId ==
                                        FirebaseAuth.instance.currentUser!.uid
                                    ? Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.pushNamed(
                                              context,
                                              StatusScreen.routeName,
                                              arguments: data,
                                            );
                                          },
                                          child: GestureDetector(
                                            onLongPress: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
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
                                                        child: const Text(
                                                            'Cancel'),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                      TextButton(
                                                        child:
                                                            const Text('Yes'),
                                                        onPressed: () async {
                                                          deleteStatus(
                                                              data.id!);
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: Column(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: messageColor,
                                                      width: 2.0,
                                                    ),
                                                  ),
                                                  child: CircleAvatar(
                                                    radius: 30,
                                                    backgroundImage:
                                                        NetworkImage(
                                                            data.profilePic),
                                                  ),
                                                ),
                                                Text(
                                                  data.dateTime!,
                                                  style: const TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : const SizedBox();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Recent Status'),
                    ),
                    Expanded(
                        child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: ((context, index) {
                        final data = snapshot.data![index];
                        return data.statusId !=
                                FirebaseAuth.instance.currentUser!.uid
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  title: Text(data.name!),
                                  trailing: Text(data.dateTime!),
                                  leading: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: messageColor,
                                        width: 2.0,
                                      ),
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          StatusScreen.routeName,
                                          arguments: data,
                                        );
                                      },
                                      child: CircleAvatar(
                                        radius: 30,
                                        backgroundImage:
                                            NetworkImage(data.profilePic),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox();
                      }),
                    ))
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
      },
    );
  }
}
