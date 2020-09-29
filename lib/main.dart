
import 'package:book_store/screens/cart/cart_screen.dart';
import 'package:book_store/screens/details/details_screen.dart';
import 'package:book_store/screens/profile/user_profile.dart';
import 'package:book_store/theme.dart';
import 'package:flutter/material.dart';
import 'screens/home/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme(),
      home: Scaffold(body: MyBottomNavigationBar()),
    );
  }
}

class MyBottomNavigationBar extends StatefulWidget {
  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int _currentIndex = 0;

  /*final homeScreen = GlobalKey<NavigatorState>();
  final cartScreen = GlobalKey<NavigatorState>();
  final profileScreen = GlobalKey<NavigatorState>();*/

  final List<Widget> _children = [MyHomePage(), CartScreen(), UserProfile()];

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        elevation: 3,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home,color: _currentIndex == 0? Colors.blue : Colors.grey,), title: Text('Home',style: TextStyle(color: _currentIndex == 0? Colors.blue : Colors.grey ),)),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart,color: _currentIndex == 1? Colors.blue : Colors.grey), title: Text('Cart',style: TextStyle(color: _currentIndex == 1? Colors.blue : Colors.grey ))),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle,color: _currentIndex == 2? Colors.blue : Colors.grey), title: Text('Profile',style: TextStyle(color: _currentIndex == 2? Colors.blue : Colors.grey )))
        ],
        onTap: onTapped,
      ),
    );
  }

  void onTapped(int value) {
    setState(() {
      _currentIndex = value;
    });
    /*switch (value) {
      case 0:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyHomePage()));
        break;
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => CartScreen()));
        break;*/
    /*case 2:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => UserProfile()));
        break;

    }*/
  }
}
