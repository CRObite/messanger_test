part of 'home_page_cubit.dart';

@immutable
abstract class HomePageState {}

class HomePageInitial extends HomePageState {}

class HomePageLoading extends HomePageState {}

class HomePageFetched extends HomePageState {
  final List<UserMessage> userAndMessages;
  final User currentUser;

  HomePageFetched({required this.userAndMessages, required this.currentUser});


}

class HomePageError extends HomePageState {
  final String errorText;

  HomePageError({required this.errorText});
}

