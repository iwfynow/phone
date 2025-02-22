import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:phone_book/viewmodels/message_view_model.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../models/message_entity.dart';
import '../../../services/contact_service.dart';
import 'package:intl/intl.dart';
import 'message_input_field.dart';
import 'package:provider/provider.dart';
import 'image_browser.dart';

class MessagePage extends StatefulWidget {
  final Contact contact;
  const MessagePage({super.key, required this.contact});

  @override
  MessagePageState createState() => MessagePageState();
}

class MessagePageState extends State<MessagePage> {
  late MessageViewModel messageViewModel;
  final ScrollController _scrollController = ScrollController();

  bool _selectionMode = false;
  final Set<int> _selectedMessages = {};

  @override
  void initState(){
    super.initState();
    MessageViewModel().initSms(widget.contact.phones.first.number);
  }

  void _toggleSelectionMode(int index) {
    setState(() {
      if (_selectedMessages.contains(index)) {
        _selectedMessages.remove(index);
        if (_selectedMessages.isEmpty) {
          _selectionMode = false;
        }
      } else {
        _selectionMode = true;
        _selectedMessages.add(index);
      }
    });
  }

  void _deleteSelectedMessages() {
    MessageViewModel().removeSms(_selectedMessages, widget.contact.phones.first.number);
    setState(() {
      _selectedMessages.clear();
      _selectionMode = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final displayName = widget.contact.displayName.isNotEmpty ? widget.contact.displayName : "";
    final number = widget.contact.phones.isNotEmpty ? widget.contact.phones.first.number : "";
    final messageViewModel = Provider.of<MessageViewModel>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        title: Row(
          children: [
            CircleAvatar(
                child: widget.contact.photo == null
                    ? const Icon(Icons.person)
                    : ClipOval(child: Image.memory((widget.contact.photo!)))),
            const SizedBox(width: 10),
            SizedBox(width: 150, child: Text(displayName.isNotEmpty ? displayName : number))
          ],
        ),
        actions: [
          if(_selectionMode) IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: _deleteSelectedMessages,
          ),
          IconButton(
              onPressed: () {
                ContactService.makeCall(widget.contact.phones.isNotEmpty ? widget.contact.phones.first.number : "");
              },
              icon: const Icon(Icons.call)),
          IconButton(
                  onPressed: (){
                    final url = Uri.parse("market://details?id=com.google.android.apps.tachyon");
                      launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      );
                  },
                  iconSize: 33,
                  icon: const Icon(Icons.videocam))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ValueListenableBuilder<List<MessageEntity>>(
                valueListenable: messageViewModel.smsMessage,
                builder: (context, smsList, child){
                  return _buildMessage(context, smsList);
                },
              )
            ),
            if(messageViewModel.selectedImage != null)
             Stack(children: [Container(
              width: 100,
              height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: MemoryImage(messageViewModel.selectedImage!, scale: 1.2),
                      fit: BoxFit.cover
                      ),
                      
                  ),
                ),
                Positioned(
                  bottom: screenWidth * 0.16,
                  left: screenWidth * 0.16,
                  child: IconButton(onPressed: (){}, icon: const Icon(Icons.close, color: Colors.black,)))
                
                
              ]
            ),
              MessageInputFields(
                  onSend: (message) async {
                    if (message.isNotEmpty) {
                      MessageViewModel().sendSMS(number, message);
                      var messageEntity  = MessageEntity(
                        content: message,
                        senderNumber: widget.contact.phones.first.number,
                        timeStamp: DateTime.now(),
                        image: messageViewModel.selectedImage
                      );
                      await Future.delayed(const Duration(milliseconds: 100));
                      _scrollController.animateTo(_scrollController.position.maxScrollExtent, 
                      duration: const Duration(milliseconds: 100), 
                      curve: Curves.easeOut
                      );
                      messageViewModel.addSms(messageEntity);
                    }
                },
                
            ),
            
          ],
        ),
      ),
    );
  }

  Widget _buildMessage(BuildContext context, List<MessageEntity> smsList){
    final screenWidth = MediaQuery.of(context).size.width;
    return ListView.builder(
      controller: _scrollController,
      itemCount: smsList.length,
      itemBuilder: (context, index) {
        final isSelected =_selectedMessages.contains(index);
        final msg = smsList[index];
        return GestureDetector(
          onLongPress: (){
            _toggleSelectionMode(index);
          },
          onTap: (){
            if(_selectionMode){
              _toggleSelectionMode(index);
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
              children: [
          if(_selectionMode)  Checkbox(
            value: isSelected,
            shape: const CircleBorder(),
            onChanged: (_) => _toggleSelectionMode(index),
          ),
              Container(
                constraints: BoxConstraints(
                  maxWidth: screenWidth * 0.75
                ),
                margin: const EdgeInsets.symmetric(vertical: 5),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.light ?const Color(0xFFDFE1F8) : const Color(0xFF1B1B23),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: IntrinsicWidth(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if(msg.image != null) GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ImageBrowser(imagePath: msg.image!, timeStamp: msg.timeStamp, fullName: widget.contact.displayName)));
                        },
                        child: ClipRRect(
                          child: Image.memory(msg.image!)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [Text(msg.content, style: const TextStyle(fontSize: 18))]
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [Text(DateFormat.jm().format(msg.timeStamp), style: const TextStyle(fontSize: 10))]
                      )
                    ]
                  )
                ),
              )]
            ),
        );
      },
    );
  }
}