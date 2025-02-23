import 'package:phone/models/contact_mapper.dart';
import '../../../viewmodels/contact_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChooseFavouriteContact extends StatefulWidget {
  const ChooseFavouriteContact({super.key});
  @override
  State<ChooseFavouriteContact> createState() => _ChooseFavouriteContactState();
}

class _ChooseFavouriteContactState extends State<ChooseFavouriteContact> {
  Icon avatar = const Icon(Icons.image_search_rounded);
  @override
  Widget build(BuildContext context) {
    final contactProvider = Provider.of<ContactViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: ListView.builder(
        itemCount: contactProvider.contactList.length,
        itemBuilder: (context, index) {
          var contact = contactProvider.contactList[index];
          return InkWell(
            child: ListTile(
              title: Row(
                children: [
                  CircleAvatar(
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
                  const SizedBox(width: 10),
                  SizedBox(width: 250, child: Text(contact.displayName)),
                ],
              ),
            ),
            onTap: () {
              contactProvider.addFavouriteContact(contact.toContactEntity(contact));
              Navigator.pop(context, true);
            },
          );
        }
      ),
    );
  }
}
