import 'dart:typed_data';
import 'package:hive/hive.dart';
part 'media_file.g.dart';

@HiveType(typeId: 2)
class MediaFile extends HiveObject{
  @HiveField(0)
  String fileName;

  @HiveField(1)
  Uint8List? fileData;

  MediaFile(this.fileName, this.fileData);
}