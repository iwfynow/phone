import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:intl/intl.dart';
import 'package:phone/generated/l10n.dart';
import 'package:phone/viewmodels/filtration_viewmodel.dart';
import 'package:phone/views/pages/create_or_edit_page.dart';
import 'package:phone/views/pages/message/message_page.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../viewmodels/contact_view_model.dart';


class CallLogExpansionTile extends StatelessWidget {
  final String phoneNumber;
  final int timestamp;
  final Icon icon;

  const CallLogExpansionTile({
    super.key,
    required this.phoneNumber,
    required this.timestamp,
    required this.icon
  });

  @override
  Widget build(BuildContext context) {
    final filtration = Filtration();
    final cvm = Provider.of<ContactViewModel>(context, listen: false);

    filtration.filtrationNumberContact(phoneNumber);
    var contact = filtration.filtrationContactList.value;
    var contactPhoto = contact.isNotEmpty && contact.first.photo != null
        ? Image.memory(
            contact.first.photo!,
            width: 40,
            height: 40,
            fit: BoxFit.cover,
          )
        : const Icon(Icons.person);

    var dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var formattedDate = DateFormat("MMM d, h:mm a").format(dateTime);


    return ExpansionTile(
      leading: CircleAvatar(
        child: contactPhoto,
      ),
      title: Text(phoneNumber),
      subtitle: Row(
        children: [
          icon,
          const SizedBox(width: 8),
          Text(
            formattedDate,
            style: TextStyle(
                color: icon.color == Colors.red
                    ? Colors.red
                    : Theme.of(context).brightness == Brightness.light
                        ? Colors.black
                        : Colors.white),
          ),
        ],
      ),
      trailing: IconButton(
        onPressed: () {
          cvm.createCall(phoneNumber);
        },
        icon: const Icon(Icons.call),
      ),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
              GestureDetector(
                onTap: (){
                  var contact = Contact(
                    phones: [Phone(phoneNumber)]
                  );
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CreateOrEditPage(contact: contact)));
                }, child: Column(
                  children: [const Icon(Icons.person_add), Text(S.of(context).add_contact)]
                )
              ),
              GestureDetector(
                onTap: (){
                  var contact = Contact(
                    phones: [Phone(phoneNumber)]
                  );
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> MessagePage(contact: contact)));
                }, child: Column(
                  children: [const Icon(Icons.message), Text(S.of(context).message)]
                )
              ),
              GestureDetector(
                onTap: (){
                  final url = Uri.parse("https://google.com/search?q=$phoneNumber");
                      launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      );
                }, 
                child: Column(
                  children: [const Icon(Icons.person_search), Text(S.of(context).lookup)]
                )
              )
            ]
        ),
      ],
    );
  }
}
