import 'dart:async';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter/material.dart';
import 'contact_view_model.dart';

class Filtration extends ChangeNotifier {
  static final Filtration _instance = Filtration._internal();
  Filtration._internal();
  factory Filtration() {
    return _instance;
  }

  final StreamController _streamController =
      StreamController<List<Contact>>.broadcast();
  Stream get contactsStream => _streamController.stream;
  ValueNotifier<List<Contact>> filtrationContactList =
      ValueNotifier<List<Contact>>([]);

  void filtrationContact(String query) async {
    final fileteredContact = ContactViewModel().contactList.where((contact) {
      final number = contact.phones.isNotEmpty ? contact.phones.first.number : "";
      final name = contact.displayName.toLowerCase();
      final phoneNumbers = number.toLowerCase();
      return name.contains(query.toLowerCase()) ||
          phoneNumbers.contains(query.toLowerCase());
    });
    filtrationContactList.value = fileteredContact.toList();
  }

  void filtrationNumberContact(String query) async {
    final fileteredContact = ContactViewModel().contactList.where((contact) {
      final number = contact.phones.isNotEmpty ? contact.phones.first.number : "";
      final phoneNumbers = number.toLowerCase();
      return phoneNumbers.contains(query.toLowerCase());
    });
    filtrationContactList.value = fileteredContact.toList();
  }
}
