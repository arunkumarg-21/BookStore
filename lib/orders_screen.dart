import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './book.dart';
import './db_helper.dart';
import './shared_preference.dart';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('OrderList'),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(10, 24, 10, 0),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Container(
            margin: EdgeInsets.all(16),
            child: Text(
              'Your Orders',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 20),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Book>>(
                future: fetchOrderItem(),
                builder: (context, snapshot) {
                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot?.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        print('name${snapshot.data[index].bookName}');
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
                                      borderRadius:
                                          BorderRadius.circular(16),
                                      image: DecorationImage(
                                          image: book.image != null
                                              ? AssetImage(book.image)
                                              : AssetImage(
                                                  'assets/book1.jpg'),
                                          fit: BoxFit.fill),
                                    ),
                                  ),
                                ),
                                Expanded(
                                    flex: 2,
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          left: 10, right: 10),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(book.bookName,
                                              overflow:
                                                  TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold,
                                                  fontSize: 15)),
                                          Text(book.bookDescription,
                                              style:
                                                  TextStyle(fontSize: 12),
                                              overflow: TextOverflow.fade,
                                              maxLines: 3),
                                          Container(
                                            margin: EdgeInsets.only(top: 8),
                                            child: Text(
                                                'Price:${book.bookPrice.toString()}',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold,
                                                    fontSize: 14)),
                                          ),
                                          /* Container(
                                            margin: EdgeInsets.only(left: 80),
                                            child: RaisedButton(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  side: BorderSide(
                                                      color: Colors.redAccent)),
                                              color: Colors.white,
                                              onPressed: () {
                                                dbHelper
                                                    .deleteCart(book.bookId);
                                                setState(() {
                                                  snapshot.data.removeAt(index);
                                                });
                                              },
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
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
                                          )*/
                                        ],
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        );
                      });
                }),
          )
        ]),
      ),
    );
  }

  Future<List<Book>> fetchOrderItem() async {
    var books;
    var sharedPref = MySharedPreference();
    String name;
    await sharedPref.getUser().then((value) {
      name = value;
    });
    books = dbHelper.getOrder(name);
    if (books == null) {
      print('null===');
    }
    print('orderbooks====$books');
    return books;
  }
}
