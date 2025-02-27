
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

import 'package:uuid/uuid.dart';

import '../domain/message.dart';
import '../domain/user.dart';

class InitialData {
  static Future<void> setUserData() async {
    var userBox = Hive.box<User>('users');
    var uuid = Uuid();

    Uint8List avatar1 = (await rootBundle.load('assets/images/avatar1.jpg')).buffer.asUint8List();
    Uint8List avatar2 = (await rootBundle.load('assets/images/avatar2.jpg')).buffer.asUint8List();

    if (userBox.isEmpty) {
      List<User> initialUsers = [
        User(uuid.v4(), "Куаныш", "Абдраманов", null, Color(0xff1FDB5F),DateTime.now().subtract(Duration(hours: 1))),
        User(uuid.v4(), "Алмас", "Мусабеков", avatar1, Color(0xffF66700),DateTime.now().subtract(Duration(minutes: 5))),
        User(uuid.v4(), "Кирил", "Леченко", null,  Color(0xff00ACF6),DateTime.now().subtract(Duration(days: 15))),
        User(uuid.v4(), "Гани", "Орынбай", avatar2,  Color(0xff00ACF6),DateTime.now().subtract(Duration(hours: 2,minutes: 25))),
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
            Message(uuid.v4(), sender.uuid, currentUser.uuid, "Привет, ${currentUser.name}!", null, DateTime.now().subtract(Duration(days: 1)),false),
            Message(uuid.v4(), sender.uuid, currentUser.uuid, "Как дела?", null, DateTime.now().subtract(Duration(days: 1,minutes: 15)),false),
            Message(uuid.v4(), currentUser.uuid, sender.uuid, "Привет, ${sender.name}!", null, DateTime.now().subtract(Duration(minutes: 2)),true),
            Message(uuid.v4(), currentUser.uuid, sender.uuid, "Как сам?", null, DateTime.now(),false),
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
