import 'package:flutter/material.dart';
import 'package:galaapp/pages/AddPlace.dart';
import 'package:galaapp/pages/Dashboard.dart';
import 'package:galaapp/pages/ListItem.dart';
import 'package:galaapp/World Time//home_time.dart';
import 'package:galaapp/World Time//choose_location.dart';
import 'package:galaapp/World Time//loading.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => const ListItems(),
          '/worldtime': (context) => const Loading(),
          '/home_time': (context) => const HomeTime(),
          '/choose_location': (context) => const ChooseLocation(), // ✅ must exist
        }
    );
  }
}