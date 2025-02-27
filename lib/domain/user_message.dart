import 'package:messanger_test/domain/message.dart';
import 'package:messanger_test/domain/user.dart';

class UserMessage{
  User user;
  Message? lastMessage;

  UserMessage(this.user, this.lastMessage);
}