import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample_project2/features/auth/controller/auth_controller.dart';
import 'package:sample_project2/features/chat/widgets/contactList_group.dart';
import 'package:sample_project2/features/group/screens/create_group_screen.dart';
import 'package:sample_project2/features/select_contacts/screens/select_contact_screen.dart';
import 'package:sample_project2/features/chat/widgets/contact_list.dart';
import 'package:sample_project2/features/status/repository/status_repository.dart';
import 'colors.dart';

import 'features/status/screens/status_contacts_screen.dart';

class MobileScreenLayout extends ConsumerStatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  ConsumerState<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends ConsumerState<MobileScreenLayout>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late TabController tabcontroller;

  @override
  void initState() {
    super.initState();
    tabcontroller = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(authControllerProvider).setUserState(true);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        ref.read(authControllerProvider).setUserState(false);
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: WillPopScope(
          onWillPop: () async {
            final value = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Alert'),
                    content: const Text('Do you want to exit'),
                    actions: [
                      ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('No')),
                      ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Yes'))
                    ],
                  );
                });

            if (value != null) {
              return Future.value(value);
            } else {
              return Future.value(false);
            }
          },
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: appBarColor,
              elevation: 0,
              title: const Text(
                'Flutio ChatApp',
                style: TextStyle(color: Colors.grey),
              ),
              centerTitle: false,
              actions: <Widget>[
                PopupMenuButton(
                    icon: const Icon(
                      Icons.more_vert,
                      color: Colors.grey,
                    ),
                    itemBuilder: (context) => [
                          PopupMenuItem(
                            child: const Text('Create Group'),
                            onTap: () => Future(() => Navigator.pushNamed(
                                context, CreateGroupScreen.routeName)),
                          ),
                          PopupMenuItem(
                            child: const Text('Edit Profile'),
                            onTap: () {},
                          )
                        ])
              ],
              bottom: TabBar(
                  controller: tabcontroller,
                  indicatorColor: tabColor,
                  indicatorWeight: 4,
                  labelColor: tabColor,
                  unselectedLabelColor: Colors.grey,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  tabs: const [
                    Tab(
                      text: 'CHATS',
                    ),
                    Tab(
                      text: 'GROUPS',
                    ),
                    Tab(
                      text: 'STATUS',
                    )
                  ]),
            ),
            body: TabBarView(controller: tabcontroller, children: const [
              ContactsList(),
              ContactsListGroup(),
              StatusContactsScreen(),
            ]),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                if (tabcontroller.index == 0) {
                  Navigator.pushNamed(context, SelectContactScreen.routeName);
                } else {
                  StatusClass().getPhotos();
                  // if (pickedImage != null) {
                  //   // ignore: use_build_context_synchronously
                  //   Navigator.pushNamed(context, ConfirmStatusScreen.routeName,
                  //       arguments: pickedImage);
                  // }
                }
              },
              backgroundColor: messageColor,
              child: const Icon(
                Icons.comment,
                color: Colors.white,
              ),
            ),
          ),
        ));
  }
}
