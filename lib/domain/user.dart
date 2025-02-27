import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
part 'user.g.dart';

@HiveType(typeId: 1)
class User extends HiveObject{
  @HiveField(0)
  String uuid;

  @HiveField(1)
  String name;

  @HiveField(2)
  String surname;

  @HiveField(3)
  Uint8List? avatar;

  @HiveField(4)
  Color noAvatarColor;

  User(this.uuid, this.name, this.surname, this.avatar, this.noAvatarColor);
}