import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';
import './notes_services.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => NoteServices(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes dApp',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
