import 'package:flutter/material.dart';
import 'package:galaapp/pages/AddPlace.dart';
import 'package:galaapp/pages/Dashboard.dart';
import 'package:galaapp/pages/ListItem.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => const ListItems(),
        '/dashboard': (context) => Dashboard(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

