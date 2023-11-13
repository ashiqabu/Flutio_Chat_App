import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample_project2/colors.dart';
import 'package:sample_project2/common/widgets/error.dart';
import 'package:sample_project2/common/widgets/loader.dart';
import 'package:sample_project2/features/select_contacts/controller/select_contact_controller.dart';
import 'package:sample_project2/features/select_contacts/screens/search_contact_list.dart';

class SelectContactScreen extends ConsumerStatefulWidget {
  static const String routeName = '/select-contact';
  // ignore: use_key_in_widget_constructors
  const SelectContactScreen({Key? key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectContactsScreenState();
}

class _SelectContactsScreenState extends ConsumerState<SelectContactScreen> {
  List<String> registeredPhoneNumbers = [];
  void selectContact(
      WidgetRef ref, Contact selectedContact, BuildContext context) {
    ref
        .read(selectContactControllerProvider)
        .selectContact(selectedContact, context);
  }

  @override
  void initState() {
    getregisteredPhoneNumbers();
    super.initState();
  }

  Future<void> getregisteredPhoneNumbers() async {
    final QuerySnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    final List<String> phoneNumbers = userSnapshot.docs
        .map((doc) => doc.get('phoneNumber'))
        .where((phoneNumber) => phoneNumber != null)
        .cast<String>()
        .toList();
    setState(() {
      registeredPhoneNumbers = phoneNumbers;
    });
  }

  List<Contact> filterContacts(List<Contact> contacts) {
    return contacts.where((contact) {
      if (contact.phones.isNotEmpty) {
        for (final phone in contact.phones) {
          if (registeredPhoneNumbers.contains(phone.number)) {
            return true;
          }
        }
      }
      return false;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: messageColor,
        title: const Text('Select contact'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Search(),
                  ));
            },
            icon: const Icon(
              Icons.search,
            ),
          ),
        ],
      ),
      body: ref.watch(getContactsProvider).when(
            data: (contactList) => ListView.builder(
                itemCount: contactList.length,
                itemBuilder: (context, index) {
                  final contact = contactList[index];
                  final isRegistered = contact.phones.isNotEmpty &&
                      registeredPhoneNumbers
                          .contains(contact.phones.first.number);
                  return InkWell(
                    onTap: () {
                     // print(contact);
                      selectContact(ref, contact, context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ListTile(
                        title: Text(
                          contact.displayName,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        leading: contact.photo == null
                            ? const CircleAvatar(
                                backgroundImage: NetworkImage(
                                    'https://www.pngitem.com/pimgs/m/581-5813504_avatar-dummy-png-transparent-png.png'),
                              )
                            : CircleAvatar(
                                backgroundImage: MemoryImage(contact.photo!),
                                radius: 30,
                              ),
                        trailing: isRegistered
                            ? Container(
                                height: 30,
                                width: 70,
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Center(child: Text('Used')),
                              )
                            : const SizedBox(),
                      ),
                    ),
                  );
                }),
            error: (err, trace) => ErrorScreen(error: err.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
