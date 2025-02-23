import 'package:flutter/material.dart';
import 'package:phone/generated/l10n.dart';
import 'package:phone/models/contact_entity.dart';
import 'package:phone/models/contact_mapper.dart';
import 'package:phone/viewmodels/contact_view_model.dart';
import 'package:phone/views/pages/contact_profile.dart';
import 'package:phone/views/pages/message/message_page.dart';
import 'choose_favourite_contact.dart';
import 'package:provider/provider.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});
  @override
  FavoritesState createState() => FavoritesState();
}

class FavoritesState extends State<Favorites> with SingleTickerProviderStateMixin{
  final List<GlobalKey> _keys = [];

  @override
  Widget build(BuildContext context) {
    final ContactViewModel cvm = Provider.of<ContactViewModel>(context);

    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(S.of(context).favourites, style: const TextStyle(fontWeight: FontWeight.bold)),
        TextButton(
          child: Text(S.of(context).add),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ChooseFavouriteContact()));
          },
        )
      ]),
      Expanded(
        child: cvm.favouriteContactList.isEmpty
            ? Text(S.of(context).no_favourite_contact)
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemCount: cvm.favouriteContactList.length,
                itemBuilder: (context, index) {
                  ContactEntity contact =
                      cvm.favouriteContactList.elementAt(index);
                  GlobalKey key = GlobalKey();
                  _keys.add(key);
                  return _builFavouriteContact(contact, key, cvm);
                },
              ),
      ),
    ]);
  }
  Widget _builFavouriteContact(ContactEntity contact, GlobalKey key, ContactViewModel cvm){
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: (){
        ContactViewModel().createCall(contact.phone!);
      },
      onLongPress: () {
        final RenderBox renderBox = key.currentContext?.findRenderObject() as RenderBox;
        final Offset offset = renderBox.localToGlobal(Offset.zero);
        showMenu(
          context: context,
          position: RelativeRect.fromLTRB(
            offset.dx,
            offset.dy + renderBox.size.height,
            offset.dx + renderBox.size.width,
            offset.dy + renderBox.size.height + 50,
          ),
          items: <PopupMenuEntry>[
            PopupMenuItem(
              onTap: (){
                cvm.createCall(contact.phone!);
              },
              child: Row(children: [
                const Icon(Icons.call),
                const SizedBox(
                  width: 10,
                ),
                Text(S.of(context).voice_call)
                ]
              )
            ),
            PopupMenuItem(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => MessagePage(contact: contact.toContact(contact))));
              },
              child: Row(children: [
                const Icon(Icons.message),
                const SizedBox(
                  width: 10,
                ),
                Text(S.of(context).message)
                ]
              )
            ),
            const PopupMenuDivider(),
            PopupMenuItem(
              onTap: (){
                cvm.removeFavouriteContact(contact);
              },
              child: Row(children: [
                const Icon(Icons.close),
                const SizedBox(
                  width: 10,
                ),
                Text(S.of(context).remove)
                ]
              )
            ),
            PopupMenuItem(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ContactProfile(contact: contact.toContact(contact))));
              },
              child: Row(children: [
                const Icon(Icons.info),
                const SizedBox(
                  width: 10,
                ),
                Text(S.of(context).contact_info)
                ]
              )
            ),
          ],
        );
      },
      child: SizedBox(
        key: key,
        child: Column(
          children: [
            CircleAvatar(
              minRadius: screenWidth * 0.14,
              child: contact.photo == null ? const Icon(Icons.image_search_rounded): 
              ClipOval(
                child: Image.memory(
                  contact.photo!,
                  fit: BoxFit.cover,
                  width: screenWidth * 0.28,
                  height: screenWidth * 0.28,
                )
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                contact.displayName!,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
