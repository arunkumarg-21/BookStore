
import 'package:book_store/database/db_helper.dart';
import 'package:book_store/screens/delivery_address.dart';
import 'package:book_store/shared_preference/shared_preference.dart';
import 'package:book_store/screens/profile/user_profile.dart';
import 'package:book_store/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../modals/book.dart';
import '../../modals/user.dart';
import '../../modals/cartlist.dart';
import '../login/login.dart';
import '../orders/orders_screen.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final dbHelper = DBHelper();
  var books = List<CartList>();
  var quantity = List<int>();

  var total;
  var name;
  var user = User();
  var selectedAddress;

  final sharedPref = MySharedPreference();

  @override
  Widget build(BuildContext context) {
    sharedPref.getUser().then((value) => name = value);
    var size = MediaQuery
        .of(context)
        .size;
    final double buttonWidth = size.width;
    return Scaffold(
      backgroundColor: Color(0xFFF5F6F9),
      appBar: AppBar(
        backgroundColor: Color(0xFFF5F6F9),
        elevation: 3,
        title: Text('CartList',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<CartList>>(
                  future: fetchCartItem(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot?.data?.length ?? 0,
                          itemBuilder: (context, index) {
                            print('name${snapshot.data[index].book.bookName}');
                            Book book = snapshot.data[index].book;
                            quantity.add(snapshot.data[index].quantity);

                            return Container(
                              height: 180,
                              margin: EdgeInsets.all(4),
                              child: Card(
                                elevation: 1,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
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
                                                      color: Colors.black,
                                                      fontSize: 15)),
                                              Text(book.bookDescription,
                                                  style: TextStyle(fontSize: 12),
                                                  overflow: TextOverflow.fade,
                                                  maxLines: 3),
                                              Container(
                                                margin: EdgeInsets.only(top: 8),
                                                child: Text(
                                                    'Price:Rs.${book.bookPrice
                                                        .toString()}',
                                                    style: TextStyle(
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        color: Colors.black,
                                                        fontSize: 14)),
                                              ),
                                              Row(children: [
                                                Text('Quantity:',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                                Expanded(
                                                  child: SizedBox(
                                                    width:getProportionateScreenWidth(context, 100),
                                                      child: Row(children: [
                                                        IconButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              if (quantity[index] != 1) {
                                                                quantity[index]--;
                                                                total -= snapshot.data[index].book.bookPrice;
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
                                                                  quantity[index].toString(),
                                                                  style:
                                                                  TextStyle(fontWeight: FontWeight.bold),
                                                                ))),
                                                        IconButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              quantity[index]++;
                                                              total += snapshot.data[index].book.bookPrice;
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
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child:Container(
                margin: EdgeInsets.all(10),
                height: 45,
              width: buttonWidth,
              child: RaisedButton(
                onPressed: () {
                  if (name.contains('noData')) {
                    _showLoginDialog(context);
                  } else {
                    dbHelper.getUser(name).then((value) => user = value);
                    Future.delayed(Duration(seconds: 1), () => check(name,context));
                  }
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
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
                          total = snapshot.data;
                          return Text('Total:${total.toString()}',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),);
                        },
                      ),
                      ),

                    Text('CHECKOUT',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        )),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                        child: Icon(Icons.account_balance_wallet,
                            color: Colors.white))
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

  check(String name,BuildContext context) async{
    if (user.userAddress == null) {
      _showDialog(context);
    } else {
        await fetchCartItem().then((value) => books = value);
        var id = List<int>();
        var quantity = List<int>();
        for (int i = 0; i < books.length; i++) {
          id.add(books[i].book.bookId);
          quantity.add(books[i].quantity);
        }
        await dbHelper.insertOrders(id, name, quantity);
        Future.delayed(Duration(seconds: 1), () =>
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DeliveryAddress())));
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
