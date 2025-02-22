import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phone_book/models/message_entity.dart';
import '../services/contact_service.dart';
import '../models/contact_entity.dart';
import '../models/objectbox.g.dart';

class ContactsRepository {
  static final ContactsRepository _instance = ContactsRepository._internal();
  ContactsRepository._internal();
  factory ContactsRepository() {
    return _instance;
  }

  late Store contactStore;
  late Box<ContactEntity> favouriteContactBox;
  late Box<MessageEntity> smsBox;

  Future<List<Map>> fetchCallLogs() async {
    return ContactService.getCallLogs();
  }

  Future<Set<ContactEntity>> initDB() async {
    contactStore = await openStore();
    favouriteContactBox = contactStore.box<ContactEntity>();
    return favouriteContactBox.getAll().toSet();
  }

  Future<List<MessageEntity?>> initSmsDB(String number) async {
    smsBox = contactStore.box<MessageEntity>();
    List<MessageEntity> usersSms = smsBox.getAll().where((el) {
      return el.senderNumber == number;
    }).toList();
    return usersSms;
  }

  Future<void> addSms(MessageEntity msg) async {
    smsBox.put(msg);
  }

  Future<void> removeSms(MessageEntity msg) async {
    final query = smsBox
        .query(MessageEntity_.senderNumber.equals(msg.senderNumber).and(
            MessageEntity_.timeStamp
                .equals(msg.timeStamp.millisecondsSinceEpoch)))
        .build();
    final messages = query.find();
    for (var el in messages) {
      smsBox.remove(el.id!);
    }
    query.close();
  }

  Future<bool> checkPermission() async {
    final status = await Permission.contacts.status;
    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      await Permission.contacts.request();
      return await Permission.contacts.isGranted;
    }
    return false;
  }

  Future<List<Contact>> fetchContacts() async {
    if (await checkPermission()) {
      try {
        return await FlutterContacts.getContacts(
            withProperties: true, withPhoto: true);
      } catch (e) {
        return Future.error("Ошибка при загрузке контактов: $e");
      }
    } else {
      return Future.error("Нет разрешения на чтение контактов");
    }
  }

  Future<void> addContact(Contact contact) async {
    contact.id = "";
    await FlutterContacts.insertContact(contact);
  }

  Future<void> removeContact(Contact contact) async {
    await FlutterContacts.deleteContact(contact);
  }

  Future<Contact?> updateContact(Contact contact) async {
    String id = contact.id;
    await FlutterContacts.updateContact(contact);
    return FlutterContacts.getContact(id,
        withPhoto: true, withProperties: true);
  }

  Future<void> addFavouriteContact(ContactEntity contact) async {
    int count = favouriteContactBox
        .query(ContactEntity_.firstName
            .equals(contact.firstName!)
            .and(ContactEntity_.lastName.equals(contact.lastName!)))
        .build()
        .count();
    if (count == 0) {
      favouriteContactBox.put(contact);
    } else {
    }
  }

  Future<void> removeFavouriteContact(ContactEntity contact) async {
    final favouriteContact = favouriteContactBox
        .query(ContactEntity_.phone.equals(contact.phone!))
        .build()
        .find();
    for (var item in favouriteContact) {
      favouriteContactBox.remove(item.id!);
    }
  }
}
