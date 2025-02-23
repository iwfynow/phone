import 'package:flutter/material.dart';
import 'package:phone/generated/l10n.dart';
import 'package:phone/viewmodels/speech_recognition_view_model.dart';
import 'package:phone/views/pages/call_history.dart';
import 'package:phone/views/pages/settings.dart';
import 'search_contact_page.dart';
import 'package:provider/provider.dart';

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SearchAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SpeechRecognitionViewModel>(context);
    return AppBar(
      toolbarHeight: preferredSize.height * 0.9,
      title: SizedBox(
        height: preferredSize.height * 0.8,
        child: SearchBar(
          elevation: const WidgetStatePropertyAll(0),
          focusNode: AlwaysDisabledFocusNode(),
          leading: const Icon(Icons.search),
          trailing: <Widget>[
            GestureDetector(
              onLongPress: () {
                searchProvider.startListening();
              },
              onLongPressUp: () async {
                if (await searchProvider.requestMicrophonePermission()) {
                  await searchProvider.stopListening();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SearchContactPage(
                              contactSearchQuery:
                                  searchProvider.recognizedText ?? "")));
                }
              },
              child: const Icon(Icons.mic_none),
            ),
            Tooltip(
              message: "",
              child: PopupMenuButton(
                onSelected: (value){
                  switch(value){
                    case 0: Navigator.push(context, MaterialPageRoute(builder: (context) => const CallHistory()));
                    break;
                    case 1: Navigator.push(context, MaterialPageRoute(builder: (context) => const Settings()));
                    break;
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                  PopupMenuItem(value: 0, child: Text(S.of(context).call_history)),
                        PopupMenuItem(
                            value: 1, child: Text(S.of(context).settings))
                ]
              ),
            ),
          ],
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const SearchContactPage(contactSearchQuery: "")));
          },
        ),
      ),
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}