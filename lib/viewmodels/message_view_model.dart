import 'dart:typed_data';
import '../repositories/contact_repository.dart';
import 'package:flutter/material.dart';
import '../models/message_entity.dart';
import '../services/contact_service.dart';

class MessageViewModel extends ChangeNotifier{
  static final MessageViewModel _instance = MessageViewModel._internal();
  MessageViewModel._internal();
  factory MessageViewModel(){
    return _instance;
  }

  final ContactsRepository _contactsRepository = ContactsRepository();

  ValueNotifier<List<MessageEntity>> smsMessage = ValueNotifier([]);
  Uint8List? selectedImage;

  void initSms(String number) async {
    smsMessage.value = await _contactsRepository.initSmsDB(number) as List<MessageEntity>;
  }

  void addSms(MessageEntity msg) async {
    _contactsRepository.addSms(msg);
    smsMessage.value = [...smsMessage.value, msg];
  }


  void removeSms(Set<int> msg, String number) async {
  for (var e in msg) {
    final messageToRemove = smsMessage.value[e];
    _contactsRepository.removeSms(messageToRemove);
  }
  final updatedMessages = await _contactsRepository.initSmsDB(number);
  smsMessage.value = updatedMessages as List<MessageEntity>;
}

  void sendSMS(String number, String message) async{
    if (await _contactsRepository.checkPermission()) {
      ContactService.sendSms(number, message);
    }
  } 

  void selecImage(Uint8List image){
    selectedImage = image;
    notifyListeners();
  }
  void clearImage(){
    selectedImage = null;
    notifyListeners();
  }
}