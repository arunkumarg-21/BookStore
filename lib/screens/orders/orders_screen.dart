import 'package:book_store/bottom_nav/bottom_navigation.dart';
import 'package:book_store/modals/cartlist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../modals/book.dart';
import '../../database/db_helper.dart';
import '../../shared_preference/shared_preference.dart';

class OrdersScreen extends StatefulWidget {
  static String routeName = '/orders';
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xFFF5F6F9),
      appBar: AppBar(
        backgroundColor: Color(0xFFF5F6F9),
        elevation: 3,
        title: Text('OrderList',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Container(
            child: Text(
              'Your Orders',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 20),
            ),
          ),
          FutureBuilder<List<CartList>>(
              future: fetchOrderItem(),
              builder: (context, snapshot) {
                if(snapshot.hasData) {
                  return Expanded(
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot?.data?.length ?? 0,
                        itemBuilder: (context, index) {
                          print('name${snapshot.data[index].book.bookName}');
                          Book book = snapshot.data[index].book;
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.circular(16),
                                boxShadow: [BoxShadow(color: Colors.grey,offset: Offset(0.0,1.0),blurRadius: 6.0)],
                              ),
                              height: 150,
                              margin: EdgeInsets.fromLTRB(4,10,4,10),
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
                                                  color: Colors.black,
                                                    fontWeight:
                                                    FontWeight.bold,
                                                    fontSize: 15)),
                                            Text(book.bookDescription,
                                                style:
                                                TextStyle(fontSize: 12,color: Colors.black87),
                                                overflow: TextOverflow.fade,
                                                maxLines: 3),
                                            Container(
                                              margin: EdgeInsets.only(top: 8),
                                              child: Text(
                                                  'Price:${book.bookPrice
                                                      .toString()}',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      fontSize: 14)),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(top: 8),
                                              child: Text(
                                                  'Quantity:${snapshot.data[index].quantity
                                                      .toString()}',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      fontSize: 14)),
                                            ),
                                          ],
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          );
                        }),
                  );
                }
                return Container(
                  alignment: Alignment.center,
                  child: Text('No Orders',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                );
              }),
          Container(
            margin: EdgeInsets.all(10),
            child: RaisedButton(
              color: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)
              ),
              onPressed: (){
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> MyBottomNavigationBar()), (route) => false);
              },
              child: Text('Back to Shopping',style: TextStyle(color: Colors.white),),
            ),
          )
        ]),
      ),
    );
  }

  Future<List<CartList>> fetchOrderItem() async {
    var books;
    var sharedPref = MySharedPreference();
    String name;
    await sharedPref.getUser().then((value) {
      name = value;
    });
    books = await dbHelper.getOrder(name);
    return books;
  }
}
