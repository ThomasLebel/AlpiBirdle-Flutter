import 'package:birdle/widgets/game_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(Icons.quiz, color: Colors.blueGrey),
                ),
              ),
              Align(alignment: Alignment.centerLeft, child: Text("Birdle")),
            ],
          ),
        ),
        body: Center(child: Column(children: [GamePage()])),
      ),
    );
  }
}
