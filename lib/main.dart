import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'config/app_navigation.dart';

void main() async {
  await Hive.initFlutter();
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
