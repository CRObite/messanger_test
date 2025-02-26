import 'dart:typed_data';
import 'package:hive/hive.dart';
part 'message.g.dart';

@HiveType(typeId: 0)
class Message extends HiveObject{
  @HiveField(0)
  String senderUUID;

  @HiveField(1)
  String receiverUUID;

  @HiveField(2)
  String text;

  @HiveField(3)
  Uint8List? image;

  @HiveField(4)
  DateTime timestamp;

  Message(this.senderUUID, this.receiverUUID, this.text, this.image,
      this.timestamp);

}