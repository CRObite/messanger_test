part of 'message_page_cubit.dart';

@immutable
abstract class MessagePageState {}

class MessagePageInitial extends MessagePageState {}

class MessagePageLoading extends MessagePageState {}

class MessagePageFetched extends MessagePageState {
  final List<Message> listOfMessages;

  MessagePageFetched({required this.listOfMessages});
}

class MessagePageError extends MessagePageState {
  final String errorText;

  MessagePageError({required this.errorText});
}
