

import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messanger_test/domain/media_file.dart';
import 'package:messanger_test/domain/message.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;

part 'message_page_state.dart';

class MessagePageCubit extends Cubit<MessagePageState> {
  MessagePageCubit() : super(MessagePageInitial());

  Uint8List? selectedImage;
  MediaFile? selectedFile;

  bool fileImagePanelOpened = false;

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
    if (text.isEmpty && selectedImage == null && selectedFile == null) return;

    var messageBox = Hive.box<Message>('messages');

    var uuid = Uuid();
    var newMessage = Message(
      uuid.v4(),
      currentUserUUID,
      targetUserUUID,
      text,
      selectedImage,
      DateTime.now(),
      false,
      selectedFile
    );

    await messageBox.add(newMessage);
    loadMessages(currentUserUUID,targetUserUUID);
  }


  Future<void> setSelectedImage(String currentUserUUID, String targetUserUUID) async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      selectedImage = await pickedFile.readAsBytes();
      fileImagePanelOpened = false;
    }
    loadMessages(currentUserUUID,targetUserUUID);
  }

  Future<void> removeSelectedImage(String currentUserUUID, String targetUserUUID) async {
    selectedImage = null;
    loadMessages(currentUserUUID,targetUserUUID);
  }

  Future<void> openPanel(String currentUserUUID, String targetUserUUID) async {

    selectedFile = null;
    selectedImage = null;
    fileImagePanelOpened = true;
    loadMessages(currentUserUUID,targetUserUUID);
  }

  Future<void> closePanel(String currentUserUUID, String targetUserUUID) async {
    fileImagePanelOpened = false;
    selectedImage = null;
    loadMessages(currentUserUUID,targetUserUUID);
  }

  Future<void> setFile(String senderUUID, String receiverUUID) async {
    var result = await FilePicker.platform.pickFiles(withData: true);
    if (result != null && result.files.single.bytes != null) {
      var file = result.files.single;
      selectedFile = MediaFile(file.name, file.bytes);
      fileImagePanelOpened = false;
      loadMessages(senderUUID, receiverUUID);
    }
  }

  Future<void> removeFile(String senderUUID, String receiverUUID) async {
    selectedFile = null;
    loadMessages(senderUUID, receiverUUID);
  }

  Future<void> saveFile(Uint8List bytes, String fileName) async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory != null) {
      String filePath = path.join(selectedDirectory, fileName);
      File file = File(filePath);
      await file.writeAsBytes(bytes);
    }
  }

}
