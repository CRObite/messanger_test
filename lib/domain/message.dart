import 'dart:typed_data';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messanger_test/domain/media_file.dart';
part 'message.g.dart';

@HiveType(typeId: 0)
class Message extends HiveObject{
  @HiveField(0)
  String messageUUID;

  @HiveField(1)
  String senderUUID;

  @HiveField(2)
  String receiverUUID;

  @HiveField(3)
  String text;

  @HiveField(4)
  Uint8List? image;

  @HiveField(5)
  DateTime timestamp;

  @HiveField(6)
  bool read; // i can use enum for 3 types of status. but in design only 2 types of check mark so i select boolean in this case

  @HiveField(7)
  MediaFile? file;

  Message(this.messageUUID, this.senderUUID, this.receiverUUID, this.text,
      this.image, this.timestamp, this.read, this.file);
}