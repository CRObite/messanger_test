import 'package:flutter/material.dart';

import 'config/app_navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'MessangerTest',

      theme: ThemeData(
        fontFamily: 'Gilroy',
      ),

      routerConfig: AppNavigation.router,
    );
  }
}
