
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:messanger_test/domain/user_message.dart';

import '../../domain/message.dart';
import '../../domain/user.dart';

part 'home_page_state.dart';

class HomePageCubit extends Cubit<HomePageState> {
  List<UserMessage> _allUsers = [];
  User? _currentUser;

  HomePageCubit() : super(HomePageInitial());

  void loadUserMessages() {
    emit(HomePageLoading());

    var userBox = Hive.box<User>('users');
    var messageBox = Hive.box<Message>('messages');

    if (userBox.isNotEmpty) {
      List<User> allUsers = userBox.values.toList();
      _currentUser = allUsers.first;

      _allUsers = allUsers.skip(1).map((user) {
        var messagesBetween = messageBox.values.where((message) =>
        (message.senderUUID == _currentUser!.uuid && message.receiverUUID == user.uuid) ||
            (message.senderUUID == user.uuid && message.receiverUUID == _currentUser!.uuid)).toList();

        messagesBetween.sort((a, b) => b.timestamp.compareTo(a.timestamp)); //srtByTiMw

        return UserMessage(user, messagesBetween.isNotEmpty ? messagesBetween.first : null);
      }).toList();

      emit(HomePageFetched(userAndMessages: _allUsers, currentUser: _currentUser!));
    } else {
      emit(HomePageError(errorText: 'Нет данных'));
    }
  }

  void searchUsers(String query) {

    emit(HomePageLoading());

    if (query.isEmpty) {
      emit(HomePageFetched(userAndMessages: _allUsers, currentUser: _currentUser!));
    } else {
      var filteredUsers = _allUsers
          .where((userMessage) =>
          userMessage.user.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
      emit(HomePageFetched(userAndMessages: filteredUsers, currentUser: _currentUser!));
    }
  }
}
