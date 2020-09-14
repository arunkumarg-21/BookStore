//import 'dart:html';

import 'package:book_store/cart_screen.dart';
import 'package:book_store/details_screen.dart';
import 'package:book_store/user_profile.dart';
import 'package:flutter/material.dart';
import './home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyBottomNavigationBar(),
    );
  }
}

class MyBottomNavigationBar extends StatefulWidget {
  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int _currentIndex = 0;
  final List<Widget> _children = [MyHomePage(), DetailsScreen(), UserProfile()];

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: _children[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home), title: Text('Home')),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart), title: Text('Cart')),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle), title: Text('Profile'))
          ],
          onTap: onTapped,
        ),
      ),
    );
  }

  void onTapped(int value) {
    switch (value) {
      case 0:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyHomePage()));
        break;
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => CartScreen()));
        break;
      /*case 2:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => UserProfile()));
        break;*/

    }
  }
}
