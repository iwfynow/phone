
import 'dart:convert';

import 'package:flutter_contacts/flutter_contacts.dart';
import 'contact_entity.dart';

extension ContactEntityMapper  on Contact {
  ContactEntity toContactEntity(Contact contact) {
    return ContactEntity.fromContact(
        id: contact.id,
        displayName: contact.displayName,
        firstName: contact.name.first,
        lastName: contact.name.last,
        phone: contact.phones.isNotEmpty ? contact.phones.first.number : "",
        emails: contact.emails.isEmpty ? "" : contact.emails.first.address,
        company: contact.organizations.isEmpty
            ? ""
            : contact.organizations.first.company,
        address:
            contact.addresses.isEmpty ? "" : contact.addresses.first.address,
        photo: contact.photo,
        notes: contact.notes.isEmpty ? "" : contact.notes.first.note);
  }
  String toVcard(
      {required Contact contact, required int bitFlag}) {
    var vcfText = "";
    if (bitFlag == 1 || bitFlag == 3 || bitFlag == 7) {
      var image64 = base64Encode(contact.photo!);
      vcfText = """
BEGIN:VCARD
VERSION:3.0
FN:${bitFlag == 2 || bitFlag == 3 || bitFlag == 7 ? contact.displayName : ""}}
N:${bitFlag == 2 || bitFlag == 3 || bitFlag == 7 ? contact.name.first : ""};${bitFlag == 2 || bitFlag == 3 || bitFlag == 7 ? contact.name.last : ""};;;
TEL;TYPE=CELL:${bitFlag == 4 || bitFlag == 6 || bitFlag == 7 ? contact.phones.first.number : ""}
PHOTO;ENCODING=b;TYPE=JPEG:$image64
END:VCARD
""";
    } else {
      vcfText = """
BEGIN:VCARD
VERSION:3.0
FN:${bitFlag == 2 || bitFlag == 3 || bitFlag == 7 ? contact.displayName : ""}}
N:${bitFlag == 2 || bitFlag == 3 || bitFlag == 7 ? contact.name.first : ""};${bitFlag == 2 || bitFlag == 3 || bitFlag == 7 ? contact.name.last : ""};;;
TEL;TYPE=CELL:${bitFlag == 4 || bitFlag == 6 || bitFlag == 7 ? contact.phones.first.number : ""}
END:VCARD
""";
    }
    return vcfText;
  }
}

extension ContactMapper on ContactEntity{
  Contact toContact(ContactEntity contact) {
    return Contact(
        displayName: "${contact.firstName} ${contact.lastName}",
        name: Name(first: contact.firstName!, last: contact.lastName!),
        photo: contact.photo,
        emails: [Email(contact.emails ?? "")],
        addresses: [Address(contact.address ?? "")],
        phones: [Phone(contact.phone!)],
        organizations: [Organization(company: contact.company ?? "")],
        notes: [Note(contact.notes ?? "")]);
  }
}