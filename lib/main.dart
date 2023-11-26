import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import './models/task.dart';
import './home_page.dart';

import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [TaskSchema],
    directory: dir.path,
  );

  runApp(MainApp(isar: isar));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key, required this.isar});
  final Isar isar;

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
      home: HomePage(isar: isar),
    );
  }
}
