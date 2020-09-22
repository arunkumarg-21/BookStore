import 'package:book_store/shared_preference.dart';
import 'package:book_store/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './book.dart';
import './db_helper.dart';
import './login.dart';
import 'orders_screen.dart';

class DetailsScreen extends StatefulWidget {
  final Book book;

  DetailsScreen({this.book});

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  var user = User();
  var dbHelper = DBHelper();
  var quantity = 1;

  TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var dbHelper = DBHelper();
    return Scaffold(
      appBar: AppBar(title: Text('BookStore')),
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
                      image: widget.book.image != null
                          ? AssetImage(widget.book.image)
                          : AssetImage('assets/book1'),
                      fit: BoxFit.fill)),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(widget.book.bookName,
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                  Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Text(
                      widget.book.bookDescription,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.grey[800],
                          fontStyle: FontStyle.normal,
                          fontSize: 14),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Text(
                      'Price: ${widget.book.bookPrice.toString()}',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                  Padding(padding:EdgeInsets.symmetric(vertical: 10),child: Text('Quantity:')),
                  Row(children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            border: Border.all(width: 3, color: Colors.cyan),
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                if (quantity != 0) {
                                  quantity--;
                                }
                              });
                            },
                            icon: Icon(
                              Icons.remove,
                              color: Colors.redAccent,
                            ),
                          ),
                          Expanded(
                              child: Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    quantity.toString(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ))),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                quantity++;
                              });
                            },
                            icon: Icon(
                              Icons.add,
                              color: Colors.greenAccent,
                            ),
                          )
                        ]),
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
                          sharedPref.getUser().then((value) {
                            name = value;
                            if (name == 'noData') {
                              _showLoginDialog(context);
                            } else {
                              Future.delayed(
                                  Duration(seconds: 1),
                                  () => dbHelper.insertCart(
                                      widget.book.bookId, name,quantity));
                            }
                          });
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


  _showLoginDialog(BuildContext context) async {
    await showDialog<String>(
      context: context,
      child: AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: new Text('Please Login To Purchase'),
            ),
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              }),
          new FlatButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                    (route) => false);
              })
        ],
      ),
    );
  }

}

