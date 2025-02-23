import 'dart:typed_data';
import 'package:objectbox/objectbox.dart';
import 'package:phone/models/objectbox.g.dart';

@Entity()
class ContactEntity {
  @Id()
  int? id;
  String? displayName;
  Uint8List? photo;
  String? firstName;
  String? lastName;
  String? phone;
  String? emails;
  String? address;
  String? company;
  String? notes;

  ContactEntity();

  ContactEntity.fromContact(
      {required String id,
      required this.displayName,
      required this.firstName,
      required this.lastName,
      required this.phone,
      required this.emails,
      required this.company,
      required this.address,
      required this.photo,
      required this.notes});

  @override
  bool operator ==(Object other) {
    if (other is ContactEntity) {
      return phone == other.phone && displayName == other.displayName;
    }
    return super == other;
  }

  @override
  int get hashCode {
    return phone.hashCode ^ displayName.hashCode;
  }
}
