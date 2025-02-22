import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/contact_entity.dart';
import '../repositories/contact_repository.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import '../services/contact_service.dart';

class ContactViewModel extends ChangeNotifier {
  static final ContactViewModel _instance = ContactViewModel._internal();
  ContactViewModel._internal();
  factory ContactViewModel() {
    return _instance;
  }

  final ContactsRepository _contactsRepository = ContactsRepository();
  Set<ContactEntity> favouriteContactList = {};
  List<Map> callHistory = [];


  List<Contact> contactList = [];

  void init() async {
    favouriteContactList = await _contactsRepository.initDB();
    callHistory = await _contactsRepository.fetchCallLogs();
    contactList = await _contactsRepository.fetchContacts();
    notifyListeners();
  }

  void addContact(Contact contact) {
    contactList.add(contact);
    sortContactList();
    _contactsRepository.addContact(contact);
  }

  void removeContact(Contact contact) {
    contactList.removeWhere((el) {
      return el == contact;
    });
    sortContactList();
    _contactsRepository.removeContact(contact);
  }

  void update(Contact contact) async {
    Contact? updatedContact = await _contactsRepository.updateContact(contact);
    if (updatedContact != null) {
      contactList.add(updatedContact);
    }
    sortContactList();
  }


  void removeFavouriteContact(ContactEntity contact) {
    favouriteContactList.remove(contact);
    notifyListeners();
    _contactsRepository.removeFavouriteContact(contact);
  }


  void addFavouriteContact(ContactEntity contact) {
    favouriteContactList.add(contact);
    notifyListeners();
    _contactsRepository.addFavouriteContact(contact);
  }

  void sortContactList() {
    contactList.sort((a, b) {
      int firstNameComparison = a.name.first.compareTo(b.name.first);
      if (firstNameComparison != 0) {
        return firstNameComparison;
      } else {
        return a.name.last.compareTo(b.name.last);
      }
    });
    notifyListeners();
  }

  void createCall(String number) async {
    if (await _contactsRepository.checkPermission()) {
      ContactService.makeCall(number);
    }
  }

  bool containsFavouriteContact(ContactEntity contact) {
    return favouriteContactList.contains(contact);
  }
}
