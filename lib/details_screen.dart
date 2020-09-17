import 'package:book_store/home.dart';
import 'package:book_store/shared_preference.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './book.dart';
import './db_helper.dart';
import './login.dart';
import 'orders_screen.dart';

class DetailsScreen extends StatelessWidget {
  final Book book;

  DetailsScreen({this.book});

  @override
  Widget build(BuildContext context) {
    var dbHelper = DBHelper();
    return Scaffold(
      appBar: AppBar(
        title: Text('BookStore'),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(20, 24, 20, 20),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            Container(
              height: 400,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                      image: book.image != null
                          ? AssetImage(book.image)
                          : AssetImage('assets/book1'),
                      fit: BoxFit.fill)),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(book.bookName,
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                  Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Text(
                      book.bookDescription,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.grey[800],
                          fontStyle: FontStyle.normal,
                          fontSize: 14),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 20),
                    child: Text(
                      'Price: ${book.bookPrice.toString()}',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                  Row(children: [
                    Expanded(
                      flex: 3,
                      child: RaisedButton(
                        color: Colors.blueGrey,
                        textColor: Colors.white,
                        elevation: 2,
                        onPressed: () {
                          final sharedPref = MySharedPreference();
                          String name;
                          Future.delayed(Duration(seconds: 2),() => sharedPref.getUser().then((value) {
                            name = value;
                            if (name.contains('noData')) {
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Login()), (route) => false);
                            } else {
                              var id = List<int>();
                              id.add(book.bookId);
                              dbHelper.insertOrder(id, name);
                              Navigator.push(context,
                                  MaterialPageRoute(
                                      builder: (context) => OrdersPage()));
                            }
                          }));
                        },
                        child: Text('BUY NOW',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: IconButton(
                        color: Colors.grey,
                        icon: Icon(Icons.add_shopping_cart,
                            color: Colors.blueGrey),
                        onPressed: () {
                          final sharedPref = MySharedPreference();
                          String name;
                          Future.delayed(Duration(seconds: 2),() => sharedPref.getUser().then((value) {
                            name = value;
                            print('pressed==$name====');
                            dbHelper.insertCart(book.bookId,name);
                          }
                          ));
                        },
                      ),
                    ),
                  ])
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
