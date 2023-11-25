import 'package:flutter/material.dart';
import 'package:santas/empty_app_bar.dart';
import 'package:santas/home_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSwatch(
            brightness: Brightness.light,
            primarySwatch: Colors.lightGreen,
            accentColor: Colors.white,
          ),
          scaffoldBackgroundColor: Colors.white),
      home: const HomePage(),
    );
  }
}
