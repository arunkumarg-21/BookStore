
import 'package:book_store/screens/cart/cart_screen.dart';
import 'package:book_store/screens/orders/orders_screen.dart';
import 'package:book_store/screens/user_address/user_address.dart';
import 'package:flutter/widgets.dart';

import 'bottom_nav/bottom_navigation.dart';

final Map<String,WidgetBuilder> routes = {
  MyBottomNavigationBar.routeName :(context) => MyBottomNavigationBar(),
  CartScreen.routeName :(context) => CartScreen(),
  UserAddress.routeName :(context) => UserAddress(),
  OrdersScreen.routeName :(context) => OrdersScreen(),

};