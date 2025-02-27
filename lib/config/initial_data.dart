import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:uuid/uuid.dart';

import '../domain/message.dart';
import '../domain/user.dart';

class InitialData {
  static Future<void> setUserData() async {
    var userBox = Hive.box<User>('users');
    var uuid = Uuid();

    if (userBox.isEmpty) {
      List<User> initialUsers = [
        User(uuid.v4(), "Куаныш", "Абдраманов", null, Color(0xff1FDB5F)),
        User(uuid.v4(), "Алмас", "Мусабеков", null, Color(0xffF66700)),
        User(uuid.v4(), "Кирил", "Леченко", null,  Color(0xff00ACF6)),
        User(uuid.v4(), "Гани", "Орынбай", null,  Color(0xff00ACF6)),
      ];
      for (var user in initialUsers) {
        await userBox.put(user.uuid, user);
      }

      print('пользователи добавлены!');
    }
  }

  static Future<void> setMessageData() async {
    var userBox = Hive.box<User>('users');
    var messageBox = Hive.box<Message>('messages');
    var uuid = Uuid();

    if (userBox.isNotEmpty && messageBox.isEmpty) {
      List<User> users = userBox.values.toList();

      if (users.length > 1) {
        User currentUser = users[0];

        for (int i = 1; i < users.length; i++) {
          User sender = users[i];

          List<Message> messages = [
            Message(uuid.v4(), sender.uuid, currentUser.uuid, "Привет, ${currentUser.name}!", null, DateTime.now(),false),
            Message(uuid.v4(), sender.uuid, currentUser.uuid, "Как дела?", null, DateTime.now().add(Duration(minutes: 2)),false),
            Message(uuid.v4(), currentUser.uuid, sender.uuid, "Привет, ${sender.name}!", null, DateTime.now().add(Duration(minutes: 2)),false),
          ];

          for (var message in messages) {
            await messageBox.put(message.messageUUID, message);
          }
        }
        print('сообщения добавлены!');
      }
    }
  }
}
