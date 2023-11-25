import 'package:flutter/material.dart';

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
      home: Scaffold(
        floatingActionButton: SizedBox(
          width: 90.0,
          height: 90,
          child: FloatingActionButton(
            onPressed: () {},
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
            ),
            backgroundColor: Colors.teal,
            child: const Icon(
              Icons.add_task,
              size: 50,
              color: Colors.white,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          color: Colors.lightGreen,
          shape: const CircularNotchedRectangle(),
          notchMargin: 14,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(left: 40.0),
                child: IconButton(
                  icon: const Icon(
                    Icons.directions_run,
                    color: Colors.white,
                    size: 46.0,
                  ),
                  onPressed: () {},
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 40.0),
                child: IconButton(
                  icon: const Icon(
                    Icons.history,
                    color: Colors.white,
                    size: 46.0,
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
