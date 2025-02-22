import 'dart:typed_data';
import 'package:objectbox/objectbox.dart';

@Entity()
class MessageEntity {
  @Id()
  int? id;
  String content;
  String senderNumber;
  DateTime timeStamp;
  Uint8List? image;
  MessageEntity({required this.content, required this.senderNumber, required this.timeStamp, required this.image});
}