

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messanger_test/domain/message.dart';
import 'package:uuid/uuid.dart';

part 'message_page_state.dart';

class MessagePageCubit extends Cubit<MessagePageState> {
  MessagePageCubit() : super(MessagePageInitial());

  Uint8List? selectedImage;

  void loadMessages(String currentUserUUID, String targetUserUUID) {
    emit(MessagePageLoading());

    var messageBox = Hive.box<Message>('messages');

    if(messageBox.isNotEmpty){
      var messages = messageBox.values.where((message) =>
      (message.senderUUID == currentUserUUID && message.receiverUUID == targetUserUUID) ||
          (message.senderUUID == targetUserUUID && message.receiverUUID == currentUserUUID)).toList();

      messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));

      emit(MessagePageFetched(listOfMessages: messages));
    }
  }

  Future<void> sendMessage(String currentUserUUID, String targetUserUUID,String text) async {
    if (text.isEmpty && selectedImage == null) return;

    var messageBox = Hive.box<Message>('messages');

    var uuid = Uuid();
    var newMessage = Message(
      uuid.v4(),
      currentUserUUID,
      targetUserUUID,
      text,
      selectedImage,
      DateTime.now(),
      false
    );

    await messageBox.add(newMessage);
    loadMessages(currentUserUUID,targetUserUUID);
  }


  Future<void> setSelectedImage(String currentUserUUID, String targetUserUUID) async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      selectedImage = await pickedFile.readAsBytes();
    }
    loadMessages(currentUserUUID,targetUserUUID);
  }

  Future<void> removeSelectedImage(String currentUserUUID, String targetUserUUID) async {
    selectedImage = null;
    loadMessages(currentUserUUID,targetUserUUID);
  }
}
