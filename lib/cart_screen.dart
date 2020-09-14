import 'package:book_store/db_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './book.dart';
import './user.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final dbHelper = DBHelper();
  List<Book> books;

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;
    final double buttonWidth = size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('CartList'),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(10, 24, 10,0),
        child: Stack(
          children: [
           FutureBuilder<List<Book>>(
              future: fetchCartItem(),
              builder: (context, snapshot) {
                return ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot?.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      Book book = snapshot.data[index];
                      return Container(
                        height: 150,
                        margin: EdgeInsets.all(4),
                        child: Card(
                          elevation: 1,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    image: DecorationImage(
                                        image: book.image != null
                                            ? AssetImage(book.image)
                                            : AssetImage('assets/book1.jpg'),
                                        fit: BoxFit.fill),
                                  ),
                                ),
                              ),
                              Expanded(
                                  flex: 2,
                                  child: Container(
                                    margin: EdgeInsets.only(left: 10, right: 10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(book.bookName,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15)),
                                        Text(book.bookDescription,
                                            style: TextStyle(fontSize: 12),
                                            overflow: TextOverflow.fade,
                                            maxLines: 3),
                                        Container(
                                          margin: EdgeInsets.only(top: 8),
                                          child: Text('Price:${book.bookPrice.toString()}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14)),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 80),
                                          child: RaisedButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                              side: BorderSide(color: Colors.redAccent)
                                            ),
                                            color: Colors.white,
                                            onPressed: () {
                                              dbHelper.deleteCart(book.bookId);
                                              setState(() {
                                                snapshot.data.removeAt(index);
                                              });
                                            },
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.delete,
                                                    color: Colors.redAccent,
                                                  ),
                                                  Text('Remove')
                                                ]),
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      );
                    });
              }),
            Positioned(
              bottom: 1,
              height: 45,
              width: buttonWidth,
              child: Padding(
                padding: EdgeInsets.only(right: 20),
                child: RaisedButton(
                  onPressed: (){},
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),color: Colors.blue,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.account_balance_wallet,color: Colors.white),
                      Text('CHECKOUT',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
              ),
            )
    ],
        ),
      ),
    );
  }

  Future<List<Book>> fetchCartItem() {
    final books = dbHelper.getCart();
    return books;
  }
}
