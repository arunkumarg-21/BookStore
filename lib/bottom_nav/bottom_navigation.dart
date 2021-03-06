import 'package:book_store/screens/cart/cart_screen.dart';
import 'package:book_store/screens/home/home.dart';
import 'package:book_store/screens/profile/user_profile.dart';
import 'package:flutter/material.dart';
class MyBottomNavigationBar extends StatefulWidget {
  static String routeName = '/bottom_nav';
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

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.grey,offset: Offset(0.0,1.0),blurRadius: 6.0)],
        ),
        child: BottomNavigationBar(
          elevation: 3,
          backgroundColor: Color(0xFFF5F6F9),

          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home,color: _currentIndex == 0? Colors.blue : Colors.grey,), title: Text('Home',style: TextStyle(color: _currentIndex == 0? Colors.blue : Colors.grey ),)),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart,color: _currentIndex == 1? Colors.blue : Colors.grey), title: Text('Cart',style: TextStyle(color: _currentIndex == 1? Colors.blue : Colors.grey ))),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle,color: _currentIndex == 2? Colors.blue : Colors.grey), title: Text('Profile',style: TextStyle(color: _currentIndex == 2? Colors.blue : Colors.grey )))
          ],
          onTap: onTapped,
        ),
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
