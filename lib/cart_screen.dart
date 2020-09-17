import 'package:book_store/db_helper.dart';
import 'package:book_store/shared_preference.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './book.dart';
import './user.dart';
import 'login.dart';
import 'orders_screen.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final dbHelper = DBHelper();
  var books = List<Book>();

  @override
  Widget build(BuildContext context) {
    int total=0;

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
                      print('name${snapshot.data[index].bookName}');
                      Book book = snapshot.data[index];
                      total = total+book.bookPrice;
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
                  onPressed: (){
                    final sharedPref = MySharedPreference();
                    String name;
                    Future.delayed(Duration(seconds: 2),() => sharedPref.getUser().then((value) {
                      name = value;
                      if (name.contains('noData')) {
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Login()), (route) => false);
                      } else {
                        fetchCartItem().then((value) => books = value);
                        print('booksss=====$books');
                        var id = List<int>();
                        for(int i=0;i<books.length;i++){
                          id.add(books[i].bookId);
                        }
                        dbHelper.insertOrder(id, name);
                        Navigator.push(context,
                            MaterialPageRoute(
                                builder: (context) => OrdersPage()));
                      }
                    }));
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),color: Colors.blue,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          margin: EdgeInsets.only(left:6,right: 14),
                          child: Text('Total${total.toString()}',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
                      Icon(Icons.account_balance_wallet,color: Colors.white),
                      Text('CHECKOUT',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,))
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

  Future<List<Book>> fetchCartItem() async{
    var books;
    var sharedPref = MySharedPreference();
    String name;
     await sharedPref.getUser().then((value) {
       name = value;
     });
      books=dbHelper.getCart(name);
      if(books == null){
        print('null===');
      }
      print('$books');
      return books;
    }

}
