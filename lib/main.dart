import 'package:flutter/material.dart';

void main() {
  runApp(const ChefMindApp());
}

class ChefMindApp extends StatelessWidget {
  const ChefMindApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChefMind',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2D6A4F),
        ),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Text('ChefMind is running!'),
        ),
      ),
    );
  }
}
