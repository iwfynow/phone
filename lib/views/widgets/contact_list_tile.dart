import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import '../pages/contact_profile.dart';

class ContactListTile extends StatelessWidget {
  final Contact contact;
  const ContactListTile({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: (){
        Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ContactProfile(contact: contact)),
        );
      },
      leading: CircleAvatar(
        child: contact.photo == null
            ? const Icon(Icons.person)
            : ClipOval(
                child: Image.memory(
                  contact.photo!,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
      ),
      title: Text(contact.displayName),
    );
  }
}