import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_file.dart';

import 'config/app_navigation.dart';
import 'config/initial_data.dart';
import 'domain/message.dart';
import 'domain/user.dart';

void main() async {
  await Hive.initFlutter();
  WidgetsFlutterBinding.ensureInitialized();

  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(MessageAdapter());
  Hive.registerAdapter(ColorAdapter());

  await Hive.openBox<User>('users');
  await Hive.openBox<Message>('messages');

  await InitialData.setUserData();
  await InitialData.setMessageData();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'MessengerTest',
      theme: ThemeData(
        fontFamily: 'Gilroy',
      ),
      routerConfig: AppNavigation.router,
    );
  }
}
