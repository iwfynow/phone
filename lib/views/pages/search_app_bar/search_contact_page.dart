import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:phone/views/widgets/contact_list_tile.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/filtration_viewmodel.dart';

class SearchContactPage extends StatefulWidget {
  final String contactSearchQuery;
  const SearchContactPage({super.key, required this.contactSearchQuery});
  @override
  State<SearchContactPage> createState() => _SearchContactPageState();
}

class _SearchContactPageState extends State<SearchContactPage> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.contactSearchQuery);
  }

  @override
  Widget build(BuildContext context) {
    final filtrationProvider = Provider.of<Filtration>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back)),
        title: TextField(
          controller: _textController,
          autofocus: true,
          decoration: const InputDecoration(border: InputBorder.none),
          onChanged: (value) {
            filtrationProvider.filtrationContact(value);
            setState(() {});
          },
        ),
      ),
      body: Column(children: [
        Expanded(
            child: ListView.builder(
          itemCount: filtrationProvider.filtrationContactList.value.length,
          itemBuilder: (context, index) {
            Contact contact =
                filtrationProvider.filtrationContactList.value[index];
            return ContactListTile(contact: contact);
          },
        ))
      ]),
    );
  }
}
