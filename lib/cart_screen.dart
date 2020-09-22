import 'package:book_store/db_helper.dart';
import 'package:book_store/shared_preference.dart';
import 'package:book_store/user_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './book.dart';
import './user.dart';
import 'cartlist.dart';
import 'login.dart';
import 'orders_screen.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final dbHelper = DBHelper();
  var books = List<CartList>();
  int quantity;

  var total;
  var name;
  var user = User();

  final sharedPref = MySharedPreference();





  @override
  Widget build(BuildContext context) {
    sharedPref.getUser().then((value) => name = value);
    var size = MediaQuery
        .of(context)
        .size;
    final double buttonWidth = size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('CartList'),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(10, 24, 10, 0),
        child: Stack(
          children: [
            FutureBuilder<List<CartList>>(
                future: fetchCartItem(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot?.data?.length ?? 0,
                        itemBuilder: (context, index) {
                          print('name${snapshot.data[index].book.bookName}');
                          Book book = snapshot.data[index].book;
                          quantity = snapshot.data[index].quantity;

                          /* total = total + book.bookPrice;
                            print('total=====$total');*/
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
                                              child: Text(
                                                  'Price:${book.bookPrice
                                                      .toString()}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      fontSize: 14)),
                                            ),
                                            Row(children: [
                                              Expanded(
                                                child: Container(
                                                  height: 40,
                                                  child: Text('Quantity: $quantity',style: TextStyle(fontWeight: FontWeight.bold),),
                                                  ),
                                                ),
                                              SizedBox(
                                                width: 56,
                                                child: RaisedButton(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          12),
                                                      side: BorderSide(
                                                          color: Colors
                                                              .redAccent)),
                                                  color: Colors.white,
                                                  onPressed: () {
                                                    dbHelper.getUser(name).then(
                                                            (value) =>
                                                        user = value);
                                                    if (user.userName == null) {
                                                      dbHelper.deleteCart1(
                                                          book.bookId);
                                                      setState(() {
                                                        snapshot.data
                                                            .removeAt(index);
                                                      });
                                                    } else {
                                                      dbHelper.deleteCart(
                                                          book.bookId,
                                                          user.userName);
                                                      setState(() {
                                                        snapshot.data
                                                            .removeAt(index);
                                                      });
                                                    }
                                                  },
                                                  child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .center,
                                                      children: [
                                                        Icon(
                                                          Icons.delete,
                                                          color:
                                                          Colors.redAccent,
                                                        ),
                                                        // Text('Remove')
                                                      ]),
                                                ),
                                              ),
                                            ])
                                          ],
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          );
                        });
                  }
                  return Container(
                      alignment: Alignment.center,
                      child: Text(
                        'Cart Is Empty',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ));
                }),
            Positioned(
              bottom: 1,
              height: 45,
              width: buttonWidth,
              child: Padding(
                padding: EdgeInsets.only(right: 20),
                child: RaisedButton(
                  onPressed: () {
                    if (name.contains('noData')) {
                      _showLoginDialog(context);
                    } else {
                      dbHelper.getUser(name).then((value) => user = value);
                      Future.delayed(Duration(seconds: 1), () => check(name));
                    }
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  color: Colors.blue,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: FutureBuilder(
                          future: textFuture(),
                          builder: (context,snapshot){
                            return Text('Total:${snapshot.data.toString()}',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),);
                          },
                        ),
                        ),

                      Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Icon(Icons.account_balance_wallet,
                              color: Colors.white)),
                      Text('CHECKOUT',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ))
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

  Future<List<CartList>> fetchCartItem() async {
    var sharedPref = MySharedPreference();
    String name;
    await sharedPref.getUser().then((value) {
      name = value;
    });
     return await dbHelper.getCart(name);
  }
  _showDialog(BuildContext context) async {
    await showDialog<String>(
      context: context,
      child: AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: new Text('Update Address'),
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfile()));
              })
        ],
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

  check(String name) async{
    if (user.userAddress == null) {
      _showDialog(context);
    } else {
      await fetchCartItem().then((value) => books = value);
      var id = List<int>();
      for (int i = 0; i < books.length; i++) {
        id.add(books[i].book.bookId);
      }
      await dbHelper.insertOrder(id, name);
      Future.delayed(Duration(seconds: 1),()=>Navigator.push(
          context, MaterialPageRoute(builder: (context) => OrdersPage())));
    }
  }

  Future<int> textFuture() async {
    var sharedPref = MySharedPreference();
    String name;
    await sharedPref.getUser().then((value) {
      name = value;
    });
    return await dbHelper.getTotal(name);
  }
}
