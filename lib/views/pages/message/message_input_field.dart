import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phone/viewmodels/message_view_model.dart';
import 'package:phone/viewmodels/speech_recognition_view_model.dart';

class MessageInputFields extends StatefulWidget {
  final void Function(String message) onSend;
  const MessageInputFields({super.key, required this.onSend});

  @override
  State<MessageInputFields> createState() => MessageInputState();
}

class MessageInputState extends State<MessageInputFields> {
  TextEditingController textController = TextEditingController();
  final List<Widget> toggledIcon = [
    const Icon(Icons.mic), 
    const Icon(Icons.send), 
    Transform.scale(
      scale: 2,
      child: const Icon(Icons.mic, color: Colors.red)
    )
  ];
  late Widget iconToggle;

  @override
  void initState() {
    super.initState();
    iconToggle = toggledIcon.first;
  }

   Future<void> _pickPhoto(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final photoBytes = await pickedFile.readAsBytes();
      MessageViewModel().selecImage(photoBytes);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Row(children: [
          IconButton(onPressed: () => _pickPhoto(context), 
          icon: const Icon(Icons.add_circle_outline)),
          Expanded(
              child: SizedBox(
                  height: screenHeight * 0.06,
                  child: SearchBar(
                    controller: textController,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            iconToggle = toggledIcon[1];
                          });
                        } else {
                          setState(() {
                            iconToggle = toggledIcon[0];
                          });
                        }
                      },
                      elevation: const WidgetStatePropertyAll(0),
                      trailing: [
                        GestureDetector(
                          onTap: (){
                            if(iconToggle == toggledIcon[1]){
                                widget.onSend(textController.text);
                                textController.clear();
                                MessageViewModel().selectedImage = null;
                            }
                          },
                          onLongPress: (){
                            if(iconToggle == toggledIcon[0]){
                              setState(() {
                                iconToggle = toggledIcon[2];
                              });
                              SpeechRecognitionViewModel().startListening();
                            }                           
                          },
                          onLongPressUp: () async {
                            if(iconToggle == toggledIcon[2]){
                              await SpeechRecognitionViewModel().stopListening();
                              textController.text = SpeechRecognitionViewModel().recognizedText ?? "";
                              setState(() {
                                iconToggle = toggledIcon[0];
                              });
                              widget.onSend(textController.text);
                              textController.clear();
                            }
                          },
                          child: iconToggle,
                        )
                      ])))
        ]));
  }
}