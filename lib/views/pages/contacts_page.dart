import 'package:flutter/material.dart';
import 'package:phone/generated/l10n.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/contact_view_model.dart';
import 'create_or_edit_page.dart';
import '../widgets/contact_list_tile.dart';
import 'package:flutter_contacts/flutter_contacts.dart';


class Contacts extends StatefulWidget {
  const Contacts({super.key});

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  @override
  Widget build(BuildContext context) {
    ContactViewModel contactProvider = Provider.of<ContactViewModel>(context);
    return Column(
      children: [
        Center(
          child: ElevatedButton(
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CreateOrEditPage()),
              );
            },
            style: Theme.of(context).brightness == Brightness.light ? const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.white),
            ) : const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Color(0xFF1B1B23)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add_call),
                Text(S.of(context).create_new_contact ,
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
                  itemCount: contactProvider.contactList.length,
                  itemBuilder: (context, index) {
                    Contact contact = contactProvider.contactList[index];
                    return ContactListTile(contact: contact);
                  },
          ))
      ],
    );
  }
}
