import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sample_project2/common/widgets/error.dart';
import 'package:sample_project2/common/widgets/loader.dart';
import 'package:sample_project2/features/select_contacts/controller/select_contact_controller.dart';

final selectedGroupsContacts = StateProvider<List<Contact>>(
  (ref) => [],
);
List<int> selectedContactsIndex = [];

class SelectContactsGroup extends ConsumerStatefulWidget {
  const SelectContactsGroup({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectContactsGroupState();
}

class _SelectContactsGroupState extends ConsumerState<SelectContactsGroup> {
  List<int> selectedContactsIndex = [];

  List<String> registeredPhoneNumbers = [];

  Future<void> fetchregisteredPhoneNumbers() async {
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
  void initState() {
    super.initState();

    fetchregisteredPhoneNumbers();
  }

  void selectContact(int index, Contact contact) {
    setState(() {
      if (selectedContactsIndex.contains(index)) {
      } else {
        selectedContactsIndex.add(index);
      }
    });

    ref
        // ignore: deprecated_member_use
        .read(selectedGroupsContacts.state)
        .update((state) => [...state, contact]);
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(getContactsProvider).when(
        data: (contactList) {
          final filteredContacts = filterContacts(contactList);
        
          return Expanded(
            child: ListView.builder(
                itemCount: filteredContacts.length,
                itemBuilder: (context, index) {
                  final contact = filteredContacts[index];
                  return InkWell(
                    onTap: () => selectContact(index, contact),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                          title: Row(
                            children: [
                              const CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.grey,
                                backgroundImage: NetworkImage(
                                    'https://static.vecteezy.com/system/resources/thumbnails/020/765/399/small/default-profile-account-unknown-icon-black-silhouette-free-vector.jpg'),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                contact.displayName,
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          leading: selectedContactsIndex.contains(index)
                              ? IconButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedContactsIndex.remove(index);
                                    });
                                  },
                                  icon: const CircleAvatar(
                                    radius: 10,
                                    backgroundColor: Colors.green,
                                    child: Icon(
                                      Icons.done,
                                      size: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              : null),
                    ),
                  );
                }),
          );
        },
        error: (err, trace) => ErrorScreen(error: err.toString()),
        loading: () => const Loader());
  }
}
