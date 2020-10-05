
import 'package:book_store/bottom_nav/bottom_navigation.dart';
import 'package:book_store/routes.dart';
import 'package:book_store/theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme(),
      routes: routes,
      initialRoute: MyBottomNavigationBar.routeName,
    );
  }
}

