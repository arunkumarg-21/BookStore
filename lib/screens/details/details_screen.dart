import 'package:book_store/screens/cart/cart_screen.dart';
import 'package:book_store/screens/home/components/icon_button.dart';
import 'package:book_store/shared_preference/shared_preference.dart';
import 'package:book_store/modals/user.dart';
import 'package:book_store/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../modals/book.dart';
import '../../database/db_helper.dart';
import '../login/login.dart';
import '../orders/orders_screen.dart';

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

  /*Future<int> numOfItem() async{
    var sharedPref = MySharedPreference();
    var name;
    int items=0;
    await sharedPref.getUser().then((value) => name=value);
    await dbHelper.getCart(name).then((value) => value.forEach((element) {++items;}));
    return items;
  }*/

  @override
  Widget build(BuildContext context) {
    var dbHelper = DBHelper();
    return Scaffold(
      backgroundColor: Color(0xFFF5F6F9),
      appBar: AppBar(
        backgroundColor: Color(0xFFF5F6F9),
        title: Text('Details',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
        elevation: 2,
        actions: [
          IconBtnWithCounter(
            numOfitem: 0,
            press: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CartScreen())),
            svgSrc: 'assets/icons/Cart Icon.svg',
          )
        ],
      ),
      body: Builder(
        builder: (context) => Container(
         // margin: EdgeInsets.fromLTRB(20,0, 20, 20),
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
                  Container(
                  height: 400,
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      //borderRadius: BorderRadius.all(Radius.circular(20)),
                      image: DecorationImage(
                          image: widget.book.image != null
                              ? AssetImage(widget.book.image)
                              : AssetImage('assets/book1'),
                          fit: BoxFit.fill)),
                ),
              Container(
                margin: EdgeInsets.only(top: 10,left: 20,right: 20,bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children:[ Expanded(
                        child: Text(widget.book.bookName,
                            textAlign: TextAlign.left,
                            style:
                                TextStyle(fontWeight: FontWeight.bold, fontSize: 22,color: Colors.black)),
                      ),
                        Container(
                          width: 60,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(widget.book.rating.toString(),style: TextStyle(color: Colors.black),),
                              Icon(Icons.star,color: Colors.blueAccent,)
                            ],

                          ),
                        ),
                    ]),
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
                        'Price: Rs.${widget.book.bookPrice.toString()}',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                    Row(
                        children: [
                      Padding(padding:EdgeInsets.symmetric(vertical: 10),child: Text('Quantity:',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),)),
                      SizedBox(
                        width: 180,
                        child: Container(
                          margin: EdgeInsets.only(left: 15),
                          height: 50,
                          decoration: BoxDecoration(
                              border: Border.all(width: 3, color: Colors.cyan),
                              borderRadius: BorderRadius.circular(20)),
                          child: Row(children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  if (quantity != 1) {
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
                    ]),
                    SizedBox(height: getProportionateScreenWidth(context,20),),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                      color: Colors.blue,
                        borderRadius: BorderRadius.circular(16)
                      ),
                      child: FlatButton(
                        child: Row(mainAxisAlignment: MainAxisAlignment.center,
                          children:[
                            Icon(Icons.add_shopping_cart,
                              color: Colors.white),
                            Padding(padding:EdgeInsets.only(left: 10),child: Text("Add To Cart",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
                        ]),
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
                                      () {
                                    dbHelper.insertCart(widget.book.bookId, name,quantity);
                                    Scaffold.of(context).showSnackBar(SnackBar(content: Text('Successfully added to the cart',)));
                                  });
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
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

