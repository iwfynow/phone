import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:phone_book/generated/l10n.dart';
import 'package:phone_book/models/contact_mapper.dart';
import 'package:phone_book/viewmodels/contact_view_model.dart';
import 'package:phone_book/views/pages/create_or_edit_page.dart';
import 'package:phone_book/views/pages/settings.dart';
import 'package:phone_book/views/pages/share_contact.dart';
import 'package:url_launcher/url_launcher.dart';
import 'message/message_page.dart';
import 'package:provider/provider.dart';


class ContactProfile extends StatefulWidget {
  Contact contact;
  ContactProfile({super.key, required this.contact});

  @override
  ContactProfileState createState() => ContactProfileState();
}

class ContactProfileState extends State<ContactProfile> {
  bool isFavourite = false;
  @override
  void initState(){
    super.initState();
    isFavourite = ContactViewModel().containsFavouriteContact(widget.contact.toContactEntity(widget.contact));
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cvm = Provider.of<ContactViewModel>(context);
    ButtonStyle iconTheme = Theme.of(context).brightness == Brightness.light ?  const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Color(0xFFDFE1F8))
                    ) : const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Color(0xFF1B1B23))
                    );
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                Contact? newContact = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CreateOrEditPage(contact: widget.contact)));
                if(newContact != null){
                  setState(() {
                    widget.contact = newContact;
                  });
                }
              },
              icon: const Icon(Icons.edit)),
          IconButton(
              onPressed: () {
               cvm.addFavouriteContact(widget.contact.toContactEntity(widget.contact));
                setState(() {
                  isFavourite = !isFavourite;
                });
              },
              icon: isFavourite ? const Icon(Icons.star) : const Icon(Icons.star_border) ),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Settings()));
              },
              icon: const Icon(Icons.settings)),
        ],
      ),
      body: Column(
        children: [
          Center(
            child: SizedBox(
              height: screenWidth * 0.4,
              width: screenWidth * 0.4,
              child: CircleAvatar(
                  child: widget.contact.photo == null
                      ? const Icon(Icons.person)
                      : ClipOval(
                          child: Image.memory((widget.contact.photo!)))),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            widget.contact.displayName,
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  onPressed: () => cvm.createCall(widget.contact.phones.isNotEmpty ? widget.contact.phones.first.number : ""),
                  iconSize: 33,
                  style: iconTheme,
                  icon: const Icon(Icons.call)
              ),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                MessagePage(contact: widget.contact)));
                  },
                  iconSize: 33,
                  style: iconTheme,
                  icon: const Icon(Icons.message)),
              IconButton(
                  onPressed: (){
                    final url = Uri.parse("market://details?id=com.google.android.apps.tachyon");
                      launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      );
                  },
                  iconSize: 33,
                  style: iconTheme,
                  icon: const Icon(Icons.videocam)),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            decoration: Theme.of(context).brightness == Brightness.light ? const BoxDecoration(
              color:Color(0xFFF4F2FD),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ) : const BoxDecoration(
              color:Color(0xFF1B1B23),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            width: screenWidth * 0.9,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [Text(S.of(context).contact_info, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))]
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.call),
                  title: Text(widget.contact.phones.first.number),
                  trailing: IconButton(icon: const Icon(Icons.message), onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MessagePage(contact: widget.contact)));
                  },),
                  onTap: (){
                    cvm.createCall(widget.contact.phones.first.number);
                  },
                ),
                if(widget.contact.emails.isNotEmpty)
                const Divider(),
                if(widget.contact.emails.isNotEmpty)
                ListTile(
                  leading: const Icon(Icons.email),
                  title: Text(widget.contact.emails.isNotEmpty ? widget.contact.emails.first.address : ""),
                  onTap: () async {
                    final Uri emailUri = Uri.parse('mailto:${widget.contact.emails.isNotEmpty ? widget.contact.emails.first.address : ""}');
                        const String playStoreUri = 'https://play.google.com/store/apps/details?id=com.google.android.gm';
                        if (await canLaunchUrl(emailUri)) {
                          await launchUrl(emailUri, mode: LaunchMode.externalApplication);
                        } else if (await canLaunchUrl(Uri.parse(playStoreUri))) {
                          await launchUrl(Uri.parse(playStoreUri));
                        }
                  },
                ),
                if(widget.contact.notes.isNotEmpty)
                const Divider(),
                if(widget.contact.notes.isNotEmpty)
                ListTile(
                  leading: const Icon(Icons.notes),
                  title: Text(widget.contact.notes.isNotEmpty ? widget.contact.notes.first.note : ""),
                )
              ],
            ),
          ),
          const SizedBox(height: 25),
          const Divider(),
          const SizedBox(height: 20),
          ListTile(leading: const Icon(Icons.share), title: Text(S.of(context).share_contact), onTap: (){
            showDialog(context: context, builder: (context) => ShareContact(contact: widget.contact));
          },),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: Text(S.of(context).delete, style: const TextStyle(color: Colors.red)),
            onTap: (){
              ContactViewModel().removeContact(widget.contact);
            },
          )
        ],
      )
    );
  }
}