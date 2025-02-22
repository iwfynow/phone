import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import '../viewmodels/filtration_viewmodel.dart';
import 'package:provider/provider.dart';
import 'widgets/contact_list_tile.dart';

class DialingPad extends StatefulWidget {
  const DialingPad({super.key});
  @override
  State<DialingPad> createState() => _DialingPadState();
}

class _DialingPadState extends State<DialingPad> {
  final TextEditingController _textController = TextEditingController();
  Filtration? filtrationViewModal;
  double screenHeight = 0;
  double screenWidth = 0;

  final List<String> buttons = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '*',
    '0',
    '#'
  ];
  @override
  void initState(){
    super.initState();
    _textController.text = "";
  }

  void addNumber(String number) {
    _textController.text = _textController.text + number;
    filtration();
  }

  void filtration() {
    filtrationViewModal!.filtrationNumberContact(_textController.text);
    filtrationViewModal!.filtrationContactList = filtrationViewModal!.filtrationContactList;
  }

  void removeCharacter() {
    if (_textController.text.isNotEmpty) {
      _textController.text =
          _textController.text.substring(0, _textController.text.length - 1);
    }
    filtration();
  }

  @override
  Widget build(BuildContext context) {
    filtrationViewModal = Provider.of<Filtration>(context);
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return FloatingActionButton(
      onPressed: () async {
        showModalBottomSheet(
          isScrollControlled: true,
          shape: const BeveledRectangleBorder(),
          context: context,
          builder: (BuildContext build) {
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter modalSetState) {
                return SingleChildScrollView(
                  child: SizedBox(
                    height: screenHeight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: screenHeight * 0.44,
                          child: ValueListenableBuilder(
                            valueListenable: filtrationViewModal!.filtrationContactList, 
                            builder: (context, filtrationContactList, child){
                              return ListView.builder(
                                  padding: const EdgeInsets.only(top: 30),
                                  itemCount: filtrationContactList.length,
                                  itemBuilder: (context, index) {
                                    Contact contact = filtrationContactList[index];
                                    return SizedBox(
                                      width: 50,
                                      child: ContactListTile(contact: contact),
                                    );
                                  },
                                );
                            })
                        ),
                        Row(
                          children: [
                            const SizedBox(width: 20),
                            SizedBox(
                              width: screenWidth * 0.8,
                              child: TextField(
                                focusNode: AlwaysDisabledFocusNode(),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                                style: const TextStyle(fontSize: 25),
                                controller: _textController,
                                maxLength: 20,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                removeCharacter();
                              },
                              icon: const Icon(Icons.backspace),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: screenHeight * 0.37,
                          child: GridView.count(
                            mainAxisSpacing: screenWidth * 0.01,
                            crossAxisCount: 3,
                            crossAxisSpacing: screenWidth * 0.08,
                            childAspectRatio: screenWidth * 0.004,
                            children: List.generate(buttons.length, (index) {
                              return ElevatedButton(
                                onPressed: () {
                                  modalSetState(() {
                                    addNumber(buttons[index]);
                                  });
                                },
                                child: Text(buttons[index]),
                              );
                            }),
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.065,
                          width: screenWidth * 0.25,
                          child: ElevatedButton(
                            style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.green)),
                            onPressed: () {},
                            child: const Text(
                              "Call",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
      child: const Icon(Icons.dialpad),
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
