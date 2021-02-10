import 'dart:convert';
import 'dart:math';

import 'package:book_store/Response/response.dart';
import 'package:book_store/database/db_helper.dart';
import 'package:book_store/screens/cart/firebase_demo.dart';
import 'package:book_store/screens/payment_response/payment_response.dart';
import 'package:book_store/screens/user_address/user_address.dart';
import 'package:book_store/shared_preference/shared_preference.dart';
import 'package:book_store/screens/profile/user_profile.dart';
import 'package:book_store/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../modals/book.dart';
import '../../modals/user.dart';
import '../../modals/cartlist.dart';
import '../login/login.dart';
import '../orders/orders_screen.dart';
import 'package:http/http.dart' as http;

class CartScreen extends StatefulWidget {
  static String routeName = '/cart';
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final dbHelper = DBHelper();
  var books = List<CartList>();
  var quantity = List<int>();
  var RES;

  var total=0;
  var name;
  var user = User();
  bool first=true;
  var _deliveryAddress;

  final sharedPref = MySharedPreference();
  var _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();
  var amount;
  var orderId;


  Future<ResponseResult> getResponse(String orderId,String amount) async{
    final response = await http.post('YOUR-SERVER-WEBSITE-TO-GET-RESPONSE',
        body: <String,String>{
          "orderId" : orderId,
          "amount" : amount
        }
    );
    if(response.statusCode == 200){
      return ResponseResult.fromJson(jsonDecode(response.body));
    }else{
      throw Exception('Failed to load website');
    }

  }


  static const platform = const MethodChannel('com.example.paytm/payment');

  @override
  Widget build(BuildContext context) {
    sharedPref.getUser().then((value) => name = value);
    var size = MediaQuery.of(context).size;
    final double buttonWidth = size.width;
    return Scaffold(
        backgroundColor: Color(0xFFF5F6F9),
        appBar: AppBar(
          backgroundColor: Color(0xFFF5F6F9),
          elevation: 3,
          title: Text(
            'CartList',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        body: Builder(
          builder: (context) => Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                height: 75,
                child: FutureBuilder<String>(
                    future: deliveryAddress(),
                    builder: (context,snapshot) {
                      _deliveryAddress = snapshot.data;
                      return Column(
                          children: [
                            Row(
                              children: [
                                Text('Delivery Address',
                                  style: TextStyle(color: Colors.black,
                                      fontWeight: FontWeight.w500),),
                                Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: SizedBox(width: 20,
                                        child: Icon(Icons.location_on,
                                          color: Colors.blueGrey,)))
                              ],
                            ),
                            Row(
                              mainAxisAlignment:MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(child: Text(_deliveryAddress == null? 'select address':_deliveryAddress,style: TextStyle(color: Colors.black),overflow: TextOverflow.ellipsis,maxLines: 1,)),
                                FlatButton(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>UserAddress()));
                                  },
                                  child: Text('Change Address',
                                    style: TextStyle(
                                        color: Colors.lightBlueAccent),
                                    overflow: TextOverflow.ellipsis,),
                                )
                              ],
                            ),
                          ]);

                    }),
              ),
              Expanded(
                child: FutureBuilder<List<CartList>>(
                  future: fetchCartItem(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if(first) {
                        for (int i = 0; i < snapshot.data.length; i++) {
                          total += snapshot.data[i].book.bookPrice * snapshot.data[i].quantity;
                        }
                        first = false;
                      }
                      return Column(
                          children: [
                        Expanded(
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: snapshot?.data?.length ?? 0,
                              itemBuilder: (context, index) {
                                print('name${snapshot.data[index].book.bookName}');
                                Book book = snapshot.data[index].book;
                                quantity.add(snapshot.data[index].quantity);

                                return Container(
                                  height: 155,
                                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Card(
                                    elevation: 1,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(16))),
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
                                                mainAxisSize: MainAxisSize.min,
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
                                                          color: Colors.black,
                                                          fontSize: 15)),
                                                  Text(book.bookDescription,
                                                      style:
                                                          TextStyle(fontSize: 12),
                                                      overflow: TextOverflow.fade,
                                                      maxLines: 3),
                                                  Text(
                                                      'Price:Rs.${book.bookPrice.toString()}',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                          fontSize: 14)),
                                                  Row(
                                                      //crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                    Text(
                                                      'Quantity:',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Expanded(
                                                      child: Row(
                                                          //crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                        IconButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              if (quantity[
                                                                      index] !=
                                                                  1) {
                                                                quantity[index]--;
                                                                total -= snapshot
                                                                    .data[index]
                                                                    .book
                                                                    .bookPrice;
                                                              }
                                                            });
                                                          },
                                                          icon: Icon(
                                                            Icons.remove,
                                                            color:
                                                                Colors.redAccent,
                                                          ),
                                                        ),
                                                        Expanded(
                                                            child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                  quantity[index]
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
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
                                                            color: Colors
                                                                .greenAccent,
                                                          ),
                                                        )
                                                      ]),
                                                    ),
                                                    SizedBox(
                                                      width: 40,
                                                      child: FlatButton(
                                                        /*shape:
                                                            RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12),
                                                                side: BorderSide(
                                                                    color: Colors
                                                                        .redAccent)),*/
                                                        //color: Colors.white,
                                                        onPressed: () {
                                                            dbHelper.deleteCart(
                                                                book.bookId, name);
                                                            setState(() {
                                                              snapshot.data
                                                                  .removeAt(index);
                                                            });
                                                          },
                                                        child:Icon(
                                                                Icons.delete,
                                                                color: Colors
                                                                    .redAccent,
                                                              ),

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
                              }),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            margin: EdgeInsets.all(10),
                            height: 45,
                            width: buttonWidth,
                            child: RaisedButton(
                              onPressed: () {
                                if(_deliveryAddress==null){
                                  _showDialog(context);
                                }else{
                                 Future.delayed(Duration(seconds: 1),()=> _showOrderDialog(context,name));
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
                                    child: Text(
                                          'Total:${total.toString()}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
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
                      ]);
                    }
                    return Container(
                        alignment: Alignment.center,
                        child: Text(
                          'Cart Is Empty',
                          style:
                              TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ));
                  }),
              ),
          ]),
        ));
  }

  Future<List<CartList>> fetchCartItem() async {
    var sharedPref = MySharedPreference();
    String name;
    await sharedPref.getUser().then((value) {
      name = value;
    });
    return await dbHelper.getCart(name);
  }

  Future<String> deliveryAddress() async{
    var sharedPref = MySharedPreference();
    String name;
    await sharedPref.getUser().then((value) {
      name = value;
    });
    return await dbHelper.getDeliveyAddress(name);
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
                Navigator.pop(context);
              })
        ],
      ),
    );
  }

  void _showOrderDialog(BuildContext context,String name) async {
    await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: Text('Are you sure?'),
        content: Text('Do you want to place order'),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text('No'),
          ),
          FlatButton(
            onPressed: () async{

              orderId = getRandomString(15);
              amount = total.toString();
              var res = await payment();
              if(res == "success"){
                var name;
                var sharedPref = MySharedPreference();
                await sharedPref.getUser().then((value) => name = value);
                await fetchCartItem().then((value) => books = value);
                var id = List<int>();
                var quantity = List<int>();
                for (int i = 0; i < books.length; i++) {
                  id.add(books[i].book.bookId);
                  quantity.add(books[i].quantity);
                }
                await dbHelper.insertOrders(id, name, quantity);
                dbHelper.deleteUserCart(name);
                Navigator.popAndPushNamed(context, OrdersScreen.routeName);
              }else{
                Navigator.popAndPushNamed(context, PaymentFailed.routeName);
                //Scaffold.of(context).showSnackBar(SnackBar(content: Text('Payment Failed',)));
              }

            },
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }


  Future<String> payment() async{
    ResponseResult res = await getResponse(orderId,amount);
    String body = res.body.txnToken;
    var sendMap = <String,dynamic>{
      "mid" : "YOUR_PAYTM_MID",
      "amount": amount,
      "token" : body,
      "orderId":orderId
    };
    try{
      var result = await platform.invokeMethod("payment",sendMap);
      print("result=================$result");
      if(result == "success"){
        RES = "success";
      }else{
        RES ="failed";
      }
    }catch(e){
      print(e.message);
    }
    return RES;
  }

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));


}
